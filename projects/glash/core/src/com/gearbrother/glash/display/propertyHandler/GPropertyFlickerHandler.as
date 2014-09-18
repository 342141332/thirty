package com.gearbrother.glash.display.propertyHandler {
	import flash.display.DisplayObject;
	import flash.utils.Timer;
	import flash.utils.getTimer;


	/**
	 * @author lifeng
	 * @create on 2014-6-19
	 */
	public class GPropertyFlickerHandler extends GPropertyHandler {
		private var _timer:Timer;
		
		private var _timerHandler:GPropertyTimerHandler;
		
		public function GPropertyFlickerHandler(propertyOwner:DisplayObject, isValidateLater:Boolean = false) {
			super(propertyOwner, isValidateLater);

			_timerHandler = new GPropertyTimerHandler(_handleTimer, propertyOwner);
		}
		
		override protected function doValidate():void {
			_timerHandler.value = 100;
		}
		
		protected function _handleTimer(e:*):void {
			if (value > getTimer()) {
				propertyOwner.alpha = int(getTimer() / 300) % 2 == 0 ? 1 : .0;
			} else {
				propertyOwner.alpha = 1.0;
				_timerHandler.value = 0;
			}
			trace("propertyOwner.alpha", propertyOwner.alpha);
		}
	}
}
