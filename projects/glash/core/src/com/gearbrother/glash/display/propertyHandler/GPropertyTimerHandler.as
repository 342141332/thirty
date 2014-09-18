package com.gearbrother.glash.display.propertyHandler {
	import flash.display.DisplayObject;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	/**
	 * @author neozhang
	 * @create on Aug 16, 2013
	 */
	public class GPropertyTimerHandler extends GPropertyHandler {
		public var refreshCall:Function;
		
		public var timer:Timer;

		public var start:int;

		public function GPropertyTimerHandler(refreshCall:Function, propertyOwner:DisplayObject, isValidateLater:Boolean = false) {
			super(propertyOwner, isValidateLater);
			
			this.refreshCall = refreshCall;
		}

		override protected function doValidate():void {
			if (value) {
				timer ||= new Timer(value as Number);
				timer.delay = value;
				timer.addEventListener(TimerEvent.TIMER, _handleTimerEvent);
				timer.start();
				start = getTimer();
			} else {
				if (timer)
					timer.stop();
			}
		}

		final private function _handleTimerEvent(event:TimerEvent):void {
			refreshCall.call(propertyOwner, getTimer() - start);
		}

		override public function dispose():void {
			if (timer) {
				timer.removeEventListener(TimerEvent.TIMER, _handleTimerEvent);
				timer.stop();
			}
			timer = null;
		}
	}
}
