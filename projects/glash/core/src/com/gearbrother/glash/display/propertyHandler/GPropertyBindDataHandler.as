package com.gearbrother.glash.display.propertyHandler {
	import com.gearbrother.glash.display.GDisplaySprite;
	import com.gearbrother.glash.display.IGDisplay;
	import com.gearbrother.glash.mvc.model.GBean;
	import com.gearbrother.glash.mvc.model.GBeanPropertyEvent;
	
	import flash.display.DisplayObject;

	/**
	 * @author neozhang
	 * @create on Aug 8, 2013
	 */
	public class GPropertyBindDataHandler extends GPropertyHandler {
		private var _events:Object;

		private var _updateCall:Function;
		
		private var _oldModel:*;
		
		override public function set value(newValue:*):void {
			if (value != newValue)
				_events = null;
			super.value = newValue;
		}

		public function GPropertyBindDataHandler(updateCall:Function, propertyOwner:DisplayObject, isValidateLater:Boolean = true) {
			super(propertyOwner, isValidateLater);

			_updateCall = updateCall;
		}

		override protected function doValidate():void {
			if (_oldModel is GBean)
				(_oldModel as GBean).removeEventListener(GBeanPropertyEvent.PROPERTY_CHANGE, _handleModelChanged);
			_oldModel = value;
			if (value is GBean)
				(value as GBean).addEventListener(GBeanPropertyEvent.PROPERTY_CHANGE, _handleModelChanged);
			_updateCall.call(propertyOwner, _events);
			_events = null;
		}

		private function _handleModelChanged(event:GBeanPropertyEvent = null):void {
			_events ||= {};
			_events[event.propertyKey] = event;
			revalidate();
		}

		override public function dispose():void {
			if (value is GBean)
				(value as GBean).removeEventListener(GBeanPropertyEvent.PROPERTY_CHANGE, _handleModelChanged);
			_events = null;
		}
	}
}
