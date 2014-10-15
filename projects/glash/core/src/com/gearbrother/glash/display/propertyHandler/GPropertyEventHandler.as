package com.gearbrother.glash.display.propertyHandler {
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;


	/**
	 *
	 * @author 	Neo.Zhang
	 * @create 	2014-8-14 下午2:10:18
	 *
	 */
	public class GPropertyEventHandler extends GPropertyHandler {
		private var _event:String;
		
		private var _handle:Function;
		
		private var _oldValue:IEventDispatcher;
		
		public function GPropertyEventHandler(event:String, handle:Function, propertyOwner:DisplayObject, isValidateLater:Boolean = false) {
			super(propertyOwner, isValidateLater);
			
			_handle = handle;
			_event = event;
		}
		
		override protected function doValidate():void {
			if (_oldValue)
				_oldValue.removeEventListener(_event, _handle);
			_oldValue = value;
			if (_oldValue)
				_oldValue.addEventListener(_event, _handle);
			_handle.call(propertyOwner);
		}

		override public function dispose():void {
			propertyOwner.removeEventListener(_event, _handle);
		}
	}
}
