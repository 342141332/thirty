package com.gearbrother.glash.display.flixel.position {
	import flash.geom.Point;
	
	import flash.geom.Point;

	public class SimplePositionTransformer implements IPositionTransformer {
		public var offestX:Number;
		public var offestY:Number;

		public function SimplePositionTransformer(offestX:Number = 0.0, offestY:Number = 0.0):void {
			this.offestX = offestX;
			this.offestY = offestY;
		}

		public function pixelToLocation(p:Point, zoom:int):* {
			return new Point(p.x - offestX, p.y - offestY);
		}

		public function locationToPixel(p:*, zoom:int):Point {
			return new Point(p.x + offestX, p.y + offestY);
		}
		
		public function getZoomMagnification(startZoom:int, endZoom:int):Number {
			throw new Error("unimplement");
		}
	}
}