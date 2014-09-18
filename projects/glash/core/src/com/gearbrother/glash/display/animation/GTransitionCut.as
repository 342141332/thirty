package com.gearbrother.glash.display.animation {
	import com.gearbrother.glash.display.GDisplayConst;
	import com.gearbrother.glash.util.display.GDisplayUtil;
	import com.greensock.easing.Back;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Circ;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Quint;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author feng.lee
	 * create on 2013-2-4
	 */
	public class GTransitionCut extends GBitmapAnimation {
		private var _pieceSize:int;

		private var _direction:int;

		private var _clone:BitmapData;

		override public function set process(newValue:Number):void {
			super.process = newValue;

			bitmap.bitmapData.fillRect(new Rectangle(0, 0, bitmap.width, bitmap.height), 0x00000000);
			var reverse:int = 1;
			if (_direction == GDisplayConst.AXIS_X) {
				for (var h:int = 0; h < bitmap.height; h += _pieceSize) {
					bitmap.bitmapData.copyPixels(_clone, new Rectangle(0, h, bitmap.width, _pieceSize)
						, new Point(reverse * bitmap.width * newValue, h));
					reverse *= -1;
				}
			} else if (_direction == GDisplayConst.AXIS_Y) {
				for (var w:int = 0; w < bitmap.width; w += _pieceSize) {
					bitmap.bitmapData.copyPixels(_clone, new Rectangle(w, 0, _pieceSize, bitmap.height)
						, new Point(w, reverse * bitmap.height * newValue));
					reverse *= -1;
				}
			}
		}

		public function GTransitionCut(pieceSize:int = 50, direction:int = GDisplayConst.AXIS_X, duration:Number = 1) {
			super(duration);

			_pieceSize = pieceSize;
			_direction = direction;
//			ease = Quint.easeInOut;
//			ease = Back.easeInOut;
//			ease = Expo.easeInOut;
		}

		override public function execute():void {
			_clone = bitmap.bitmapData.clone();
			super.execute();
		}
		
		override public function notifyResult(event:*=null):void {
			_clone.dispose();
			super.notifyResult(event);
		}
	}
}
