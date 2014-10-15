package com.gearbrother.glash.display.animation {
	import com.gearbrother.glash.util.display.GDisplayUtil;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;

	/**
	 * @author neozhang
	 * @create on May 15, 2013
	 */
	public class GAlphaAnimation extends GAnimation {
		private var _preViewGrab:Bitmap;

		override public function set process(newValue:Number):void {
			super.process = newValue;

			_preViewGrab.bitmapData.applyFilter(_preViewGrab.bitmapData, _preViewGrab.bitmapData.rect, new Point()
				, new ColorMatrixFilter([
						1, 0, 0, 0, 0
						, 0, 1, 0, 0, 0
						, 0, 0, 1, 0, 0
						, 1 / 3, 1 / 3, 1 / 3, 0, 255 * newValue
					])
			);
		}

		public function GAlphaAnimation(duration:Number = 4) {
			super(duration);
		}

		override public function execute():void {
			super.execute();
		}
	}
}
