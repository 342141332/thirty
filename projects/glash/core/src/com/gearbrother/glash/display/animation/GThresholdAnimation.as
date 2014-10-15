package com.gearbrother.glash.display.animation {
	import com.gearbrother.glash.util.display.GColorUtil;
	import com.gearbrother.glash.util.display.GDisplayUtil;
	import com.greensock.easing.Back;
	import com.greensock.easing.Circ;
	import com.greensock.easing.Quint;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.geom.Point;

	/**
	 * @author neozhang
	 * @create on May 14, 2013
	 */
	public class GThresholdAnimation extends GBitmapAnimation {
		//从深到浅
		static public const THRESHOLD_DEEP_TO_TINT:int = 1;
		
		//从浅到深
		static public const THRESHOLD_TINT_TO_DEEP:int = 2;
		
		private var _mode:int;
		
		private var _toColor:uint;
		
		override public function set process(newValue:Number):void {
			if (_mode == THRESHOLD_DEEP_TO_TINT) {
				bitmap.bitmapData.threshold(bitmap.bitmapData, bitmap.getRect(bitmap), new Point()
					, "<=", GColorUtil.RGB(255 * newValue, 255 * newValue, 255 * newValue), 0xFFFFFF, 0xFFFFFF);
			} else if (_mode == THRESHOLD_TINT_TO_DEEP) {
				bitmap.bitmapData.threshold(bitmap.bitmapData, bitmap.getRect(bitmap), new Point()
					, ">=", GColorUtil.RGB(255 * (1 - newValue), 255 * (1 - newValue), 255 * (1 - newValue)), 0xFFFFFF, 0xFFFFFF);
			}

			super.process = newValue;
		}
		
		public function GThresholdAnimation(threshold:int = THRESHOLD_TINT_TO_DEEP, toColor:uint = 0x00FFFFFF, duration:Number = .7) {
			super(duration);
			_mode = threshold;
			_toColor = toColor;
//			ease = Circ.easeInOut;
		}
	}
}
