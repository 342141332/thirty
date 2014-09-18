package com.gearbrother.glash.display.animation {
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.GSkinSprite;
	import com.gearbrother.glash.display.GSprite;
	import com.gearbrother.glash.util.display.GDisplayUtil;
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;


	/**
	 * @author feng.lee
	 * @create on 2013-2-2
	 */
	public class GTransitionDisslove extends GBitmapAnimation {
		private var _dissolveBmd:BitmapData;

		private var _enlargedBmd:BitmapData;

		private var _matrix:Matrix;

		private var _boxSize:int;

		override public function set process(newValue:Number):void {
			super.process = newValue;
			_dissolveBmd.pixelDissolve(_dissolveBmd
				, new Rectangle(0, 0, _dissolveBmd.width, _dissolveBmd.height), new Point()
				, Math.random() * int.MAX_VALUE, _dissolveBmd.width * _dissolveBmd.height * process, 0xff0000ff);
			_enlargedBmd.draw(_dissolveBmd, _matrix);
			bitmap.bitmapData.copyChannel(_enlargedBmd
				, new Rectangle(0, 0, _enlargedBmd.width, _enlargedBmd.height), new Point(), BitmapDataChannel.RED, BitmapDataChannel.ALPHA);
		}

		public function GTransitionDisslove(boxSize:int = 10, duration:Number = 1.7) {
			super(duration);
			this._boxSize = boxSize;
		}

		override public function execute():void {
			_dissolveBmd = new BitmapData(Math.ceil(bitmap.width / _boxSize), Math.ceil(bitmap.height / _boxSize), false, 0xffffffff);
			_matrix = new Matrix();
			_matrix.scale(_boxSize, _boxSize);
			_enlargedBmd = new BitmapData(bitmap.width, bitmap.height, false, 0xffffafaf);

			super.execute();
		}

		override public function notifyResult(event:*=null):void {
			_dissolveBmd.dispose();
			_enlargedBmd.dispose();
			
			super.notifyResult(event);
		}
	}
}
