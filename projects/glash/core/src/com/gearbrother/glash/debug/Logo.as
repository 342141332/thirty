package com.gearbrother.glash.debug {
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.Shape;


	/**
	 * @author feng.lee
	 * create on 2012-9-28 下午12:00:31
	 */
	public class Logo extends Shape {
		public function Logo() {
			super();

			graphics.lineStyle(4, 0, 1, false, "normal", CapsStyle.SQUARE, JointStyle.MITER);
			//G
			graphics.moveTo(25, 25);
			graphics.lineTo(45, 25);
			graphics.lineTo(45, 50);
			graphics.lineTo(0, 50);
			graphics.lineTo(0, 0);
			graphics.lineTo(45, 0);
			
			//e
			graphics.moveTo(75, 24);
			graphics.lineTo(55, 24);
			graphics.lineTo(55, 50);
			graphics.lineTo(75, 50);
			graphics.moveTo(75, 37);
			graphics.lineTo(55, 37);
		}
	}
}