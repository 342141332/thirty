package com.gearbrother.mushroomWar.view.layer.scene.battle {
	import com.gearbrother.glash.common.oper.GOper;
	import com.gearbrother.glash.common.oper.ext.GAliasFile;
	import com.gearbrother.glash.common.oper.ext.GFile;
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.util.camera.Camera;
	import com.gearbrother.glash.util.display.GDisplayUtil;
	import com.gearbrother.mushroomWar.model.BattleItemModel;
	import com.gearbrother.mushroomWar.model.BattleModel;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;


	/**
	 * 静态背景
	 * 
	 * @author lifeng
	 * @create on 2014-5-18
	 */
	public class BattleSceneLayerTerrian extends GNoScale {
		private var _camera:Camera;
		
		override protected function _handleLibsSuccess(res:*):void {
			var file:GFile = libsHandler.cachedOper[libs[0]];
			var shape:Sprite = file.getInstance("BackgroundStyle1");
			var bmd:BitmapData = GDisplayUtil.grab(shape);
			this.graphics.beginBitmapFill(bmd);
			this.graphics.drawRect(0, 0, _camera.bound.width, _camera.bound.height);
			this.graphics.endFill();
			this.graphics.beginFill(0xffffff, .1);
			this.graphics.drawRect(0, 0, 200, 200);
			this.graphics.endFill();
			cacheAsBitmap = true;
		}

		public function BattleSceneLayerTerrian(battleModel:BattleModel, camera:Camera) {
			super(skin);

			bindData = battleModel;
			_camera = camera;
			libs = [new GAliasFile("static/asset/background/1.swf")];
		}

		override protected function doInit():void {
			super.doInit();

			_camera.addEventListener(Event.CHANGE, _handleCameraChanged);
		}

		private function _handleCameraChanged(event:Event = null):void {
			scrollRect = _camera.screenRect;
		}

		override public function handleModelChanged(events:Object=null):void {
			var model:BattleModel = bindData;
			/*var file0:GFile = libsHandler.cachedOper[libs[0]];
			var file1:GFile = libsHandler.cachedOper[libs[1]];
			if (file0 && file0.state == GOper.STATE_END && file1 && file1.state == GOper.STATE_END) {
				while (_bmps.length) {
					var bmp:Bitmap = _bmps.shift();
					bmp.bitmapData.dispose();
				}
				var _bitmap:Bitmap = new Bitmap(new BitmapData(battleModel.col * battleModel.cellPixel, battleModel.row * battleModel.cellPixel, false));
				_bmps.push(_bitmap);
				addChild(_bitmap);
				//draw background
				var gradientSprite:Shape = new Shape();
				var bmd:BitmapData = GDisplayUtil.grab(file0.getInstance("Value"));
				gradientSprite.graphics.beginBitmapFill(bmd);
				gradientSprite.graphics.drawRect(0, 0, _camera.bound.width, _camera.bound.height);
				gradientSprite.graphics.endFill();
				_bitmap.bitmapData.draw(gradientSprite);
				
				bmd = GDisplayUtil.grab(file1.getInstance("Value"));
				for (var rString:String in battleModel.collisions) {
					for (var cString:String in battleModel.collisions[rString]) {
						var r:int = int(rString);
						var c:int = int(cString);
						_bitmap.bitmapData.copyPixels(bmd, new Rectangle(0, 0, bmd.width, bmd.height), new Point(c * battleModel.cellPixel, r * battleModel.cellPixel));
					}
				}
			}
			return;*/
			/*var file0:GFile = libsHandler.cachedOper[libs[0]];
			var file1:GFile = libsHandler.cachedOper[libs[1]];
			if (file0 && file0.state == GOper.STATE_END && file1 && file1.state == GOper.STATE_END) {
				while (_bmps.length) {
					var bmp:Bitmap = _bmps.shift();
					bmp.bitmapData.dispose();
				}
				var _bitmap:Bitmap = new Bitmap(new BitmapData(model.col * model.cellPixel, model.row * model.cellPixel, false));
				_bmps.push(_bitmap);
				addChild(_bitmap);
				//draw background
				var gradientSprite:Shape = new Shape();
				var m:Matrix = new Matrix();
				m.createGradientBox(_camera.bound.width, _camera.bound.height, Math.PI / 2, 0, 0);
				gradientSprite.graphics.beginGradientFill(GradientType.LINEAR, [0x000000, 0x0c2c4c], [1, 1], [0, 255], m);
				gradientSprite.graphics.drawRect(0, 0, _camera.bound.width, _camera.bound.height);
				gradientSprite.graphics.endFill();
				_bitmap.bitmapData.draw(gradientSprite);
				
				//draw grid
				for (var r:int = 1; r < Math.ceil(_camera.bound.height / (model.cellPixel << 1)); r++)
					_bitmap.bitmapData.fillRect(new Rectangle(0, r * (model.cellPixel << 1), _camera.bound.width, 1), 0xff142c54);
				for (var c:int = 1; c < Math.ceil(_camera.bound.width / (model.cellPixel << 1)); c++)
					_bitmap.bitmapData.fillRect(new Rectangle(c * (model.cellPixel << 1), 0, 1, _camera.bound.height), 0xff142c54);
				
				_drawBlock(model
					, _bitmap, file0.getInstance("Value")
					, function(collision:BattleItemModel):Boolean {
						return collision.isSheepPassable == false && collision.isWolfPassable == false;
					}
				);
				_drawBlock(model
					, _bitmap, file1.getInstance("Value")
					, function(collision:BattleItemModel):Boolean {
						return collision.isSheepPassable == true && collision.isWolfPassable == false;
					}
				);
			}*/
			_handleCameraChanged();
		}
		
		override protected function doDispose():void {
			_camera.removeEventListener(Event.CHANGE, _handleCameraChanged);
			super.doDispose();
		}
	}
}
