package com.gearbrother.monsterHunter.flash.view.replay {
	import com.gearbrother.glash.paper.position.IPositionTransformer;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;


	/**
	 * @author 		lifeng
	 * @version 	1.0.0
	 * create on	2012-12-8 下午2:14:23
	 */
	public class ReplayPositionTransformer implements IPositionTransformer {
		private var _offset:Point;

		private var _colX:Array;

		private var _rowHeight:int;

		public function ReplayPositionTransformer(offset:Point, colWidths:Array, rowHeight:int) {
			_offset = offset;
			_colX = [];
			var lastX:int = 0
			for (var i:int = 0; i < colWidths.length + 1; i++) {
				_colX.push(lastX);
				lastX += colWidths[i];
			}
			_rowHeight = rowHeight;
		}

		public function locationToPixel(location:*, zoom:int):Point {
			var l:Point = location;
			return new Point(_offset.x + _colX[l.x] + ((_colX[l.x + 1] - _colX[l.x]) >> 1)// + _padding * l.x
				, _offset.y + _rowHeight * l.y + (_rowHeight >> 1));
		}

		public function pixelToLocation(pixel:Point, zoom:int):* {
			throw new Error("unimplements");
		}

		public function getZoomMagnification(startZoom:int, endZoom:int):Number {
			return 0;
		}

		public function getEdge(pos:Point):Point {
			return new Point(_offset.x + _colX[pos.x], _offset.y + pos.y * (_rowHeight));
		}
	}
}
