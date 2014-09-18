package com.gearbrother.glash.common.oper.ext {
	import com.gearbrother.glash.GMain;
	import com.gearbrother.glash.common.collections.IGObject;
	import com.gearbrother.glash.common.oper.GOper;
	import com.gearbrother.glash.common.oper.GOperEvent;
	import com.gearbrother.glash.common.oper.GOperPool;
	import com.gearbrother.glash.common.oper.GQueue;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	import org.as3commons.lang.StringUtils;

	/**
	 * @author feng.lee
	 * create on 2012-10-31 下午12:10:09
	 */
	public class GBmdDefinition extends GOper implements IGObject {
		static public const queue:GQueue = new GQueue(-1);

		protected var definition:GDefinition;
		
		private var skip:int;

		private var removeDuplicate:Boolean;

		private var removeTransparent:Boolean;

		private var signalChildrenNames:Array;

		public var userData:Object;

		protected var _toBmdOper:GDisplayToBmdOper;

		public function GBmdDefinition(definition:GDefinition, skip:int = 0, removeDuplicate:Boolean = false, removeTransparent:Boolean = false, signalChildrenNames:Array = null) {
			super(queue);

			this.definition = definition;
			this.skip = skip;
			this.removeDuplicate = removeDuplicate;
			this.removeTransparent = removeTransparent;
			this.signalChildrenNames = signalChildrenNames;
			this.userData = {};
		}

		override public function execute():void {
			super.execute();

			definition = GOperPool.instance.getInstance(definition) as GDefinition;
			if (definition.state == GOper.STATE_END)
				_handleDefinitionEvent();
			else
				definition.addEventListener(GOperEvent.OPERATION_COMPLETE, _handleDefinitionEvent);
		}

		protected function _handleDefinitionEvent(event:Event = null):void {
			if (definition.resultType == GOper.RESULT_TYPE_SUCCESS) {
				var result:* = definition.result;
				if (result is BitmapData) {
					throw new Error("unimplement");
				} else {
					_toBmdOper = new GDisplayToBmdOper(filterConvertItem(result), null, 1, -1, 0, this.removeDuplicate, this.removeTransparent);
					_toBmdOper.addEventListener(GOperEvent.OPERATION_COMPLETE, _handleBmdEvent);
					_toBmdOper.commit();
				}
			} else {
				notifyFault();
			}
		}
		
		protected function _handleBmdEvent(event:Event):void {
			_toBmdOper.removeEventListener(GOperEvent.OPERATION_COMPLETE, _handleBmdEvent);
			if (_toBmdOper.resultType == GOper.RESULT_TYPE_SUCCESS)
				notifyResult(_toBmdOper.result);
			else
				notifyFault(_toBmdOper.result);
		}

		protected function filterConvertItem(display:DisplayObject):DisplayObject {
			if (display is DisplayObjectContainer) {
				if (display is MovieClip)
					(display as MovieClip).stop();
				var container:DisplayObjectContainer = display as DisplayObjectContainer;
				for each (var childName:String in signalChildrenNames) {
					if (container[childName]) {
						var child:DisplayObject = container[childName];
						userData[childName] = new Point(child.x, child.y);
						container.removeChild(child);
						container[childName] = null;
					}
				}
			}
			return display;
		}

		private function _handleBmdResult():void {
			switch (_toBmdOper.resultType) {
				case GOper.RESULT_TYPE_SUCCESS:
					notifyResult(_toBmdOper.result);
					break;
				case GOper.RESULT_TYPE_ERROR:
					notifyFault(_toBmdOper.result);
					break;
			}
		}
		
		public function equals(o:Object):Boolean {
			if (o is GBmdDefinition) {
				var other:GBmdDefinition = o as GBmdDefinition;
				return other.skip == skip && other.removeDuplicate == removeDuplicate
					&& other.removeTransparent == removeTransparent && other.definition.equals(definition);
			} else {
				return false;
			}
		}

		public function hashCode():Object {
			return definition.hashCode() + "?skip=" + skip + "&removeDuplicate=" + removeDuplicate + "&removeTransparent=" + removeTransparent;
		}
		
		override public function dispose():void {
			GOperPool.instance.returnInstance(definition);
			_toBmdOper.dispose();

			super.dispose();
		}

		override public function toString():String {
			return StringUtils.substitute("{file= {0}, skip = {1}}", definition, skip);
		}
	}
}
