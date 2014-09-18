package com.gearbrother.glash.display.control {
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.events.ResizeEvent;
	
	import com.gearbrother.glash.common.geom.GDimension;
	import com.gearbrother.glash.display.event.GDisplayEvent;
	import com.gearbrother.glash.util.display.GBitmapGrid9Util;
	import com.gearbrother.glash.display.GBitmap;


	/**
	 * @author feng.lee
	 * create on 2012-9-25 下午2:26:46
	 */
	public class GScale9Bitmap extends GBitmap {
		protected var _bitmapData:BitmapData;
		override public function set bitmapData(value:BitmapData):void {
			super.bitmapData = value;
			_bitmapData = value;
			refresh9Grid();
		}

		private var _scale9Grid:Rectangle;
		public override function get scale9Grid():Rectangle {
			return _scale9Grid;
		}
		public override function set scale9Grid(value:Rectangle):void {
			_scale9Grid = value;
		}

		/**
		 * Grid9缩放时的临时位图
		 */
		protected var renderedBmd:BitmapData;
		protected function refresh9Grid():void {
			if (_scale9Grid && _bitmapData)
				if (_scale9Grid) {
					if (renderedBmd)
						renderedBmd.dispose();
//					renderedBmd = GBitmapGrid9Util.grid9(_bitmapData, size.width, size.height, _scale9Grid, isTileGrid9);
					super.bitmapData = renderedBmd;
				} else {
					var newBitmapData:BitmapData = new BitmapData(width, height, _bitmapData.transparent, 0);
					newBitmapData.copyPixels(_bitmapData, _bitmapData.rect, new Point());
					_bitmapData.dispose();
					_bitmapData = newBitmapData;
					super.bitmapData = _bitmapData;
				}
		}

		/**
		 * 进行Grid9缩放时是否以平铺方式展开
		 */
		public var isTileGrid9:Boolean = false;

		public function GScale9Bitmap(bitmapData:BitmapData = null, pixelSnapping:String = "auto", smoonthing:Boolean = false) {
			super(bitmapData, pixelSnapping, smoonthing);
		}
	}
}
