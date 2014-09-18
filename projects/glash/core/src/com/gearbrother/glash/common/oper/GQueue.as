package com.gearbrother.glash.common.oper {
	import flash.events.Event;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;


	[Event(name = "child_operation_start", type = "com.gearbrother.glash.common.oper.GOperEvent")]
	[Event(name = "child_operation_complete", type = "com.gearbrother.glash.common.oper.GOperEvent")]
	[Event(name = "child_operation_error", type = "com.gearbrother.glash.common.oper.GOperEvent")]

	/**
	 * 队列系统
	 *
	 * 引用defaultQueue将会创建默认queue。而这个默认queue是最常用的，一般情况下不需要再手动创建队列。
	 *
	 * @author flashyiyi
	 *
	 */
	public class GQueue extends GOper {
		public static const logger:ILogger = getLogger(GQueue);
		
		/**
		 * 同时允许处理Oper操作数量,默认为1 
		 * @param value
		 * 
		 */
		public var thread:int;
		
		/**
		 * 子Oper数组
		 */
		private var _children:Array;
		public function get children():Array {
			return _children.concat();
		}
		public function getChildByID(id:String):GOper {
			for each (var child:GOper in _children) {
				if (child.id == id)
					return child;
			}
			return null;
		}

		/**
		 * 是否在队列不为空时自动执行
		 */
		public var autoStart:Boolean = true;
		
		public function get runningNum():int {
			var num:int = 0;
			for each (var child:GOper in _children) {
				if (child.isStateRunning())
					num++;
			}
			return num;
		}

		public function get runningOpers():Array {
			var res:Array = [];
			for each (var child:GOper in _children) {
				if (child.isStateRunning())
					res.push(child);
			}
			return res;
		}

		public function GQueue(thread:int = 1, _childrenOpers:Array = null, holdInstance:Boolean = false) {
			super(null);

			this.holdInstance = holdInstance;
			this.thread = thread;

			for each (var child:GOper in _childrenOpers) {
				child._queue = this;
				(child as GOper)._state = GOper.STATE_WAIT;
			}
			this._children = _childrenOpers || [];
		}

		/**
		 * 推入队列
		 *
		 */
		public function commitChild(obj:GOper):void {
			obj._queue = this;
			obj._state = GOper.STATE_WAIT;

			_children.push(obj);
			if (autoStart)
				doLoad();
		}

		/**
		 * 移出队列
		 *
		 */
		public function haltChild(obj:GOper):void {
			obj._queue = null;
			obj._state = GOper.STATE_NONE;

			var index:int = _children.indexOf(obj);
			if (index == -1)
				return;

			if (index == 0) //如果正在加载，而跳到下一个
				doLoad();
			else
				_children.splice(index, 1);
		}

		private function doLoad():void {
			if (_children.length == 0) {
				notifyResult();
			} else if (thread == -1) {
				for (i = _children.length - 1; i > -1; i--) {
					oper = _children[i];
					if (oper.isStateWaiting()) {
						oper.addEventListener(GOperEvent.OPERATION_START, startHandler);
						oper.addEventListener(GOperEvent.OPERATION_COMPLETE, nextHandler);
						oper.execute();
					} else {
						break;
					}
				}
			} else if (thread > runningNum) {
				var min:Number = Math.min(thread, _children.length);
				for (var i:int = 0; i < min; i++) {
					var oper:GOper = _children[i];
					if (oper.isStateWaiting()) {
						oper.addEventListener(GOperEvent.OPERATION_START, startHandler);
						oper.addEventListener(GOperEvent.OPERATION_COMPLETE, nextHandler);
						oper.execute();
					}
				}
			}
		}

		private function startHandler(event:GOperEvent):void {
			var oper:GOper = event.currentTarget as GOper;
			oper.removeEventListener(GOperEvent.OPERATION_START, startHandler);

			var e:GOperEvent = new GOperEvent(GOperEvent.CHILD_OPERATION_START);
			e.task = this;
			e.childTask = oper;
			dispatchEvent(e);
		}

		private function nextHandler(event:GOperEvent):void {
			var oper:GOper = event.target as GOper;
			oper.removeEventListener(GOperEvent.OPERATION_START, startHandler);
			oper.removeEventListener(GOperEvent.OPERATION_COMPLETE, nextHandler);

			_children.splice(_children.indexOf(oper), 1);

			if (oper.continueWhenFail || !event || event.type == GOperEvent.OPERATION_COMPLETE)
				doLoad();
			else
				notifyFault(event);

			if (event) {
				var e:GOperEvent = new GOperEvent(GOperEvent.CHILD_OPERATION_COMPLETE);
				e.task = this;
				e.childTask = oper;
				dispatchEvent(e);
			}
		}

		public override function commit(queue:GQueue = null):void {
			if (queue || _queue == this)
				throw new Error("不能将自己推入自己的队列中")
			else
				super.commit();
		}

		public override function execute():void {
			super.execute();

			doLoad();
		}

		public override function halt():void {
			super.halt();

			if (_children.length > 0) {
				_children = _children.slice(0, 1);
				(_children[0] as GOper).halt();
			}
		}
	}
}
