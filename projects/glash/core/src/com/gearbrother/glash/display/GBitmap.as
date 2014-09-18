package com.gearbrother.glash.display {
	import flash.display.BitmapData;

	/**
	 * @author feng.lee
	 * create on 2012-8-30 下午4:15:31
	 */
	public class GBitmap extends GDisplayBitmap {
		public function GBitmap(bitmapData:BitmapData = null, pixelSnapping:String = "auto", smoonthing:Boolean = false) {
			super(bitmapData, pixelSnapping, smoonthing);
		}
	}
}
