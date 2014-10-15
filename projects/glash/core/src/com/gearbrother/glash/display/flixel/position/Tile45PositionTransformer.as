package com.gearbrother.glash.display.flixel.position {
	import flash.geom.Point;
	
	import flash.geom.Point;


	/**
	 * 等角网格转换器
	 *
	 */
	public class Tile45PositionTransformer extends TilePositionTransformer {
		public function Tile45PositionTransformer(tileWidth:Number, tileHeight:Number, offestX:Number = 0.0, offestY:Number = 0.0):void {
			super(tileWidth, tileHeight, offestX, offestY);
		}

		override public function pixelToLocation(p:Point, zoom:int):* {
			var x:Number = p.x;
			var y:Number = p.y;
			return new Point((x + y) / tileWidth - offestX, (y - x) / tileHeight - offestY);
		}

		override public function locationToPixel(p:*, zoom:int):Point {
			var x:Number = p.x;
			var y:Number = p.y;
			return new Point((x - y) / 2 * tileWidth + offestX, (x + y) / 2 * tileHeight + offestY);
		}
	}
}