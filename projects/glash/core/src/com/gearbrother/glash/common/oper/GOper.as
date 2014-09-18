package com.gearbrother.glash.common.oper {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	[Event(name = "operation_start", type = "com.gearbrother.glash.common.oper.GOperEvent")]
	[Event(name = "operation_complete", type = "com.gearbrother.glash.common.oper.GOperEvent")]

	/**
	 * 队列基类
	 *
	 * 队列可使用Queue（顺序加载）或者GroupOper（并发加载）启动。加载队列本身同时也是一个加载器。
	 *
	 * 事件调用顺序：result -> resultFuncition -> end -> 触发OPERATION_COMPLETE事件 -> 触发队列的CHILD_OPERATION_COMPLETE -> 执行下个队列
	 * 重写result方法要注意它的super.result会立即启动下个队列，因此需要放在最后（如果没有队列则会中断）。或者用重写resultFuncition代替，它一定是在队列切换前执行的。
	 * 而end方法无论成功或者失败都已经执行，可以在此放置回收代码。
	 *
	 *
	 */
	public class GOper extends EventDispatcher {
		static public const STATE_NONE:int = 1 << 0;
		static public const STATE_WAIT:int = 1 << 1;
		static public const STATE_RUN:int = 1 << 2;
		static public const STATE_END:int = 1 << 3;

		static public const RESULT_TYPE_SUCCESS:int = 1 << 4;
		static public const RESULT_TYPE_ERROR:int = 1 << 5;
		
		private static var instances:Dictionary = new Dictionary(); //维持实例字典

		/**
		 * 标示
		 */
		private var _id:String;
		public function set id(v:String):void {
			_id = v;
		}
		public function get id():String {
			return _id;
		}

		private var _name:String;
		public function get name():String {
			return _name;
		}
		
		public function get progress():Number {
			return .0;
		}

		/**
		 * 当前状态
		 */
		internal var _state:int;
		public function get state():int {
			return _state;
		}
		public function isStateNone():Boolean {
			return _state == STATE_NONE;
		}
		public function isStateWaiting():Boolean {
			return _state == STATE_WAIT;
		}
		public function isStateRunning():Boolean {
			return _state == STATE_RUN;
		}
		public function isStateEnd():Boolean {
			return (_state & STATE_END) == STATE_END;
		}
		
		private var _resultType:int;
		public function get resultType():int {
			return _resultType;
		}

		/**
		 * 最后一次的结果
		 */
		private var _result:*;
		public function get result():* {
			return _result;
		}

		/**
		 * 是否不等待而立即执行下一个Oper
		 */
		public var immediately:Boolean = false;

		/**
		 * 是否在出错的时候继续队列
		 */
		private var _continueWhenFail:Boolean = true;
		public function get continueWhenFail():Boolean {
			return _continueWhenFail;
		}

		/**
		 * 是否在执行期间维持自身实例（必须在执行前设置）
		 */
		public var holdInstance:Boolean = false;
		
		internal var _queue:GQueue;

		public function GOper(queue:GQueue = null) {
			_queue = queue;
			_state = STATE_NONE;
		}

		/**
		 * 立即执行
		 *
		 */
		public function execute():void {
			var e:GOperEvent = new GOperEvent(GOperEvent.OPERATION_START);
			e.task = this;
			dispatchEvent(e);

			_state = STATE_RUN;

			if (holdInstance)
				instances[this] = true;

			//立即执行则立即触发完成事件
			if (immediately) {
				e = new GOperEvent(GOperEvent.OPERATION_COMPLETE);
				e.task = this;
				dispatchEvent(e);
			}
		}

		/**
		 * 调用成功函数
		 *
		 */
		public function notifyResult(event:* = null):void {
			_result = event;
			_queue = null;
			_state = STATE_END;
			_resultType = RESULT_TYPE_SUCCESS;
			end(event);
			var e:GOperEvent = new GOperEvent(GOperEvent.OPERATION_COMPLETE);
			e.task = this;
			dispatchEvent(e);
		}

		/**
		 * 调用失败函数
		 *
		 */
		public function notifyFault(event:* = null):void {
			_result = event;
			_queue = null;
			_state = STATE_END;
			_resultType = RESULT_TYPE_ERROR;
			end(event);
			var e:GOperEvent = new GOperEvent(GOperEvent.OPERATION_COMPLETE);
			e.task = this;
			dispatchEvent(e);
		}

		/**
		 * 推入队列
		 *
		 * @param queue	使用的队列，为空则为默认队列
		 *
		 */
		public function commit(queue:GQueue = null):void {
			if (queue)
				_queue = queue;
			_queue.commitChild(this);
		}

		/**
		 * 结束函数
		 * @param event
		 *
		 */
		protected function end(event:* = null):void {
			if (holdInstance)
				delete instances[this];
		}

		/**
		 * 中断队列
		 *
		 */
		public function halt():void {
			end();

			if (_queue)
				_queue.haltChild(this);
		}
		
		public function dispose():void {
		}
	}
}