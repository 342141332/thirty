package com.gearbrother.glash.display.flixel {

	import com.gearbrother.glash.GMain;
	import com.gearbrother.glash.common.oper.GOper;
	import com.gearbrother.glash.common.oper.ext.GDefinition;
	import com.gearbrother.glash.common.oper.ext.GFile;
	import com.gearbrother.glash.common.oper.ext.GLoadOper;
	import com.gearbrother.glash.display.GBitmap;
	import com.gearbrother.glash.display.propertyHandler.GPropertyPoolOperHandler;
	import com.gearbrother.glash.util.camera.Camera;
	
	import flash.display.Bitmap;
	import flash.geom.Rectangle;


	/**
	 * @author 		lifeng
	 * @version 	1.0.0
	 * create on	2012-12-9 下午1:41:07
	 */
	public class GPaperLayerBackground extends GBitmap {
		private var _definitionOper:GPropertyPoolOperHandler;
		public function set definition(newValue:GOper):void {
			_definitionOper ||= new GPropertyPoolOperHandler(null, this);
			var t:GPaperLayerBackground = this;
			_definitionOper.succHandler = function(handler:GPropertyPoolOperHandler):void {
				if (newValue is GDefinition) {
					var bmdDefinition:GDefinition = _definitionOper.cachedOper as GDefinition;
					if (bmdDefinition) {
						t.bitmapData = bmdDefinition.result;
					} else
						throw new Error("unknown file type");
				} else if (newValue is GFile && (newValue as GFile).type == GFile.TYPE_IMAGE) {
					var file:GFile = _definitionOper.cachedOper as GFile;
					if (file)
						t.bitmapData = ((_definitionOper.cachedOper as GFile).result as Bitmap).bitmapData;
				}
			};
			_definitionOper.processHandler = function():void {
			};
			_definitionOper.value = newValue;
		}
		public function get definition():GOper {
			return _definitionOper ? _definitionOper.value : null;
		}

		private var _moveRate:Number;

		private var _camera:Camera;

		private var _scrollRect:Rectangle;

		public function GPaperLayerBackground(camera:Camera, moveRate:Number = 1.0) {
			super();

			_camera = camera;
			_moveRate = moveRate;
			_scrollRect = new Rectangle();
		}

		override public function tick(interval:int):void {
			if (!_scrollRect.equals(_camera.screenRect)) {
				var rect:Rectangle = _camera.screenRect.clone();
				rect.x *= _moveRate;
				rect.y *= _moveRate;
				scrollRect = rect;
				_scrollRect = _camera.screenRect.clone();
			}
		}
	}
}
