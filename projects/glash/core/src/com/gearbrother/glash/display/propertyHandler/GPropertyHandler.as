package com.gearbrother.glash.display.propertyHandler {
	import com.gearbrother.glash.display.IGDisplay;
	import com.gearbrother.glash.display.IGPropertyManagable;
	import com.gearbrother.glash.display.manager.GPaintManager;
	
	import flash.display.DisplayObject;
	import flash.events.Event;


	/**
	 * 处理对象上属性的类
	 * 在更新图形的时间片中执行，用以处理与现实对象同一生命周期的复杂操作
	 *
	 * @author neozhang
	 * @create on Aug 13, 2013
	 */
	public class GPropertyHandler implements IGPropertyManagable {
		protected var propertyOwner:DisplayObject;

		private var _value:*;
		public function get value():* {
			return _value;
		}
		public function set value(newValue:*):void {
			if (_value === undefined || _value != newValue) {
				_value = newValue;
				revalidate();
			}
		}

		private var _isValidateLater:Boolean;
		public function get isValidateLater():Boolean {
			return _isValidateLater;
		}
		public function set isValidateLater(newValue:Boolean):void {
			_isValidateLater = newValue;
		}

		public function GPropertyHandler(propertyOwner:DisplayObject, isValidateLater:Boolean) {
			this.propertyOwner = propertyOwner;
			if (propertyOwner.stage)
				propertyOwner.addEventListener(Event.REMOVED_FROM_STAGE, _handleRemovedFromStage);
			else
				propertyOwner.addEventListener(Event.ADDED_TO_STAGE, _handleAddedToStage);
			this.isValidateLater = isValidateLater;
			_value = undefined;
		}

		private function _handleAddedToStage(event:Event):void {
			propertyOwner.removeEventListener(event.type, _handleAddedToStage);
			propertyOwner.addEventListener(Event.REMOVED_FROM_STAGE, _handleRemovedFromStage);

			revalidate();
		}

		private function _handleRemovedFromStage(event:Event):void {
			propertyOwner.removeEventListener(event.type, _handleRemovedFromStage);
			propertyOwner.addEventListener(Event.ADDED_TO_STAGE, _handleAddedToStage);
			
			dispose();
		}

		public function revalidate():void {
			if (isValidateLater) {
				GPaintManager.instance.addInvalidProperties(this);
			} else {
				validateNow();
			}
		}

		final public function validateNow():void {
			if (propertyOwner.stage)
				doValidate();
		}

		protected function doValidate():void {
		}

		public function dispose():void {}
	}
}
