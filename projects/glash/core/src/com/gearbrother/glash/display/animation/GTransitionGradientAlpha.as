package com.gearbrother.glash.display.animation {
	import com.gearbrother.glash.util.display.GDisplayUtil;
	import com.greensock.easing.Circ;
	import com.greensock.easing.Quint;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	/**
	 * @author neozhang
	 * @create on May 14, 2013
	 */
	public class GTransitionGradientAlpha extends GAnimation {
		protected function get mask():Shape {
			return target as Shape;
		}
		
		public var gradientRotation:Number;
		
		public var alphaRotion:Number;

		override public function set process(newValue:Number):void {
			super.process = newValue;

			var m:Matrix = new Matrix();
			var bounds:Rectangle = target.getBounds(target.parent);
			m.createGradientBox(bounds.width * 3, bounds.height * 3, gradientRotation / 180 * Math.PI, -bounds.width, -bounds.height);
			mask.graphics.clear();
			mask.graphics.beginGradientFill(GradientType.LINEAR
				, [0x000000, 0x000000]
				, [1, .0]
				, [Math.max(0, 255 * process - alphaRotion * 255), 255 * process]
				, m);
			mask.graphics.drawRect(0, 0, bounds.width, bounds.height);
			mask.graphics.endFill();
		}

		public function GTransitionGradientAlpha(gradientRotation:int = -45, alphaRotion:Number = .1, duration:Number = 1) {
			super(duration);
			this.alphaRotion = alphaRotion;
			this.gradientRotation = gradientRotation;
//			ease = Circ.easeInOut;
		}
	}
}
