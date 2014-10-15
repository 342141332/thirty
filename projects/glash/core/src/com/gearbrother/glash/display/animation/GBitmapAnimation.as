package com.gearbrother.glash.display.animation {
	import flash.display.Bitmap;

	/**
	 * @author neozhang
	 * @create on May 27, 2013
	 */
	public class GBitmapAnimation extends GAnimation {
		protected function get bitmap():Bitmap {
			return target as Bitmap;
		}

		public function GBitmapAnimation(duration:Number = .7) {
			super(duration);
		}
	}
}
