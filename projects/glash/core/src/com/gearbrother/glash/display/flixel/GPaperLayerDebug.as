package com.gearbrother.glash.display.flixel {
	import com.gearbrother.glash.util.camera.Camera;
	import com.gearbrother.glash.util.math.GMathUtil;
	
	import flash.geom.Rectangle;



	/**
	 * @author feng.lee
	 * create on 2012-6-7 下午9:13:24
	 */
	public class GPaperLayerDebug extends GPaperLayer {
		private var _dirty:Boolean;
		
		private var _gridSize:uint;
		
		private var _data:Array;
		
		private var _lineColor:uint;
		
		private var _fillColor:uint;
		
		private var _scollrect:Rectangle;
		
		public function GPaperLayerDebug(camera:Camera, gridSize:uint, data:Array, lineColor:uint = 0xfb3305) {
			super(camera);

			_gridSize = gridSize;
			_data = data;
			_lineColor = lineColor;
			mouseEnabled = mouseChildren = false;
			cacheAsBitmap = true;
		}

		public function dirty():void {
			_dirty = true;
		}
		
		override public function tick(interval:int):void {
			if (_dirty || !_scollrect || !camera.screenRect.equals(_scollrect)) {
				_scollrect = camera.screenRect.clone();
				graphics.clear();
				graphics.lineStyle(1, _lineColor, .1);
				graphics.beginFill(_lineColor, .4);
				var c:int;
				var r:int;
				for (c = GMathUtil.roundUpToMultiple(camera.screenRect.left, _gridSize)
					; c < GMathUtil.roundDownToMultiple(camera.screenRect.right, _gridSize)
					; c += _gridSize) {
					graphics.moveTo(c, GMathUtil.roundUpToMultiple(camera.screenRect.top, _gridSize));
					graphics.lineTo(c, GMathUtil.roundDownToMultiple(camera.screenRect.bottom, _gridSize));
				}
				for (r = GMathUtil.roundUpToMultiple(camera.screenRect.top, _gridSize)
					; r < GMathUtil.roundDownToMultiple(camera.screenRect.bottom, _gridSize)
					; r += _gridSize) {
					graphics.moveTo(GMathUtil.roundUpToMultiple(camera.screenRect.left, _gridSize), r);
					graphics.lineTo(GMathUtil.roundDownToMultiple(camera.screenRect.right, _gridSize), r);
				}
				for (c = GMathUtil.roundUpToMultiple(camera.screenRect.left, _gridSize)
					; c < GMathUtil.roundDownToMultiple(camera.screenRect.right, _gridSize)
					; c += _gridSize) {
					for (r = GMathUtil.roundUpToMultiple(camera.screenRect.top, _gridSize)
						; r < GMathUtil.roundDownToMultiple(camera.screenRect.bottom, _gridSize)
						; r += _gridSize) {
						if (_data.hasOwnProperty(r / _gridSize) && _data[r / _gridSize][c / _gridSize]) {
							graphics.drawRect(c, r, _gridSize, _gridSize);
						}
					}
				}
				_dirty = false;
			}
		}
	}
}
