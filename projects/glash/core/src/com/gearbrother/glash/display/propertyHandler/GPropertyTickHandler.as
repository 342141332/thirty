package com.gearbrother.glash.display.propertyHandler {
	import com.gearbrother.glash.display.manager.GPaintManager;
	import com.gearbrother.glash.display.manager.GTickEvent;
	
	import flash.display.DisplayObject;

	/**
	 * @author neozhang
	 * @create on Aug 8, 2013
	 */
	public class GPropertyTickHandler extends GPropertyHandler {
		private var _tickCall:Function;

		public function GPropertyTickHandler(tickCall:Function, propertyOwner:DisplayObject, isValidateLater:Boolean = false) {
			super(propertyOwner, isValidateLater);
			
			_tickCall = tickCall;
		}

		override protected function doValidate():void {
			if (value)
				GPaintManager.instance.tickChannel.addEventListener(GTickEvent.TICK, tickHandler);
			else
				GPaintManager.instance.tickChannel.removeEventListener(GTickEvent.TICK, tickHandler);
		}

		final private function tickHandler(event:GTickEvent):void {
			_tickCall.call(propertyOwner, event.interval);
		}

		override public function dispose():void {
			GPaintManager.instance.tickChannel.removeEventListener(GTickEvent.TICK, tickHandler);
		}
	}
}
