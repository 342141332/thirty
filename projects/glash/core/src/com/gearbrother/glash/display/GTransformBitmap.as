package com.gearbrother.glash.display {
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	


	/**
	 * 可修改注册点
	 * 
	 * @author feng.lee
	 * create on 2012-10-25 下午4:57:00
	 */
	public class GTransformBitmap extends GBitmap {
		protected var _x:Number = 0.0;
		override public function get x():Number {
			return _x;
		}
		override public function set x(value:Number):void {
			_x = value;
			applyRegPosition();
		}

		protected var _y:Number = 0.0;
		override public function get y():Number {
			return _y;
		}
		override public function set y(value:Number):void {
			_y = value;
			applyRegPosition();
		}
		
		private var _rotation:Number = 0.0;
		override public function set rotation(value:Number):void {
			if (_rotation != value) {
				_rotation = value;
				applyRegPosition();
			}
		}
		override public function get rotation():Number {
			return _rotation;
		}
		
		private var _scaleX:Number = 1.0;
		override public function set scaleX(value:Number):void {
			if (_scaleX != value) {
				_scaleX = value;
				applyRegPosition();
			}
		}
		override public function get scaleX():Number {
			return _scaleX;
		}
		private var _scaleY:Number = 1.0;
		override public function set scaleY(value:Number):void {
			if (_scaleY != value) {
				_scaleY = value;
				applyRegPosition();
			}
		}
		override public function get scaleY():Number {
			return _scaleY;
		}
		
		public var regX:Number = 0.0;
		public var regY:Number = 0.0;
		
		public var rotateRegX:Number = NaN;
		public var rotateRegY:Number = NaN;
		
		protected var _offsetX:Number = .0;
		public function set offsetX(v:Number):void {
			if (_offsetX != v) {
				_offsetX = v;
				applyRegPosition();
			}
		}
		protected var _offsetY:Number = .0;
		public function set offsetY(v:Number):void {
			if (_offsetY != v) {
				_offsetY = v;
				applyRegPosition();
			}
		}

		public function GTransformBitmap(bitmapData:BitmapData = null, pixelSnapping:String = "auto", smoonthing:Boolean = false) {
			super(bitmapData, pixelSnapping, smoonthing);
		}
		
		public function applyRegPosition():void {
			var m:Matrix;
			if (_scaleX == 1.0 && _scaleY == 1.0 && _rotation == 0.0) {
				m = new Matrix(1, 0, 0, 1, _x - regX + _offsetX, _y - regY + _offsetY);
			} else {
				var dx:Number = isNaN(rotateRegX) ? regX - _offsetX : rotateRegX - _offsetX;
				var dy:Number = isNaN(rotateRegY) ? regY - _offsetY : rotateRegY - _offsetY;
				
				m = new Matrix(_scaleX, 0, 0, _scaleY, -dx * _scaleX, -dy * _scaleY);
				m.rotate(_rotation / 180 * Math.PI);
				m.tx += dx - (regX - _offsetX) + _x;
				m.ty += dy - (regY - _offsetY) + _y;
			}
			super.transform.matrix = m;
		}
	}
}
