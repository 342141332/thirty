package com.gearbrother.sheepwolf.view.layer.scene.battle {
	import com.gearbrother.glash.common.oper.GOper;
	import com.gearbrother.glash.common.oper.ext.GAliasFile;
	import com.gearbrother.glash.common.oper.ext.GFile;
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.util.camera.Camera;
	import com.gearbrother.sheepwolf.model.BattleItemModel;
	import com.gearbrother.sheepwolf.model.BattleModel;
	import com.gearbrother.sheepwolf.model.IBattleItemModel;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Shape;
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

		private var _bmps:Vector.<Bitmap>;

		public function BattleSceneLayerTerrian(battleModel:BattleModel, camera:Camera) {
			super(skin);

			bindData = battleModel;
			_camera = camera;
			_bmps = new Vector.<Bitmap>();
			libs = [new GAliasFile("static/asset/item/block.swf"), new GAliasFile("static/asset/item/block_wolf.swf")];
//			libs = [new GAliasFile("static/asset/item/floor_3.swf"), new GAliasFile("static/asset/item/graden.swf")];
		}

		override protected function _handleLibsSuccess(res:*):void {
			revalidateBindData();
		}

		override protected function doInit():void {
			super.doInit();

			_camera.addEventListener(Event.CHANGE, _handleCameraChanged);
		}

		private function _handleCameraChanged(event:Event = null):void {
			if (_bmps.length)
				_bmps[0].scrollRect = _camera.screenRect;
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
			var file0:GFile = libsHandler.cachedOper[libs[0]];
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
			}
			_handleCameraChanged();
		}
		
		private function _drawBlock(battleModel:BattleModel, _bitmap:Bitmap, instance:DisplayObject, filter:Function):void {
			var emptyArray:Array = [];
			//draw elements
			for (var rString:String in battleModel.items) {
				for (var cString:String in battleModel.items[rString]) {
					var r:int = int(rString);
					var c:int = int(cString);
					var up:Array = [r - 1, c];
					var right:Array = [r, c + 1];
					var down:Array = [r + 1, c];
					var left:Array = [r, c - 1];
					var upBoolean:Boolean = false;
					var rightBoolean:Boolean = false;
					var downBoolean:Boolean = false;
					var leftBoolean:Boolean = false;
					if (battleModel.row > up[0] && up[0] > -1 && up[1] < battleModel.col)
						upBoolean = battleModel.getCollision(up[0], up[1]) != null && filter(battleModel.getCollision(up[0], up[1]));
					if (battleModel.row > right[0] && right[1] < battleModel.col)
						rightBoolean = battleModel.getCollision(right[0], right[1]) != null && filter(battleModel.getCollision(right[0], right[1]));
					if (battleModel.row > down[0] && down[1] < battleModel.col)
						downBoolean = battleModel.getCollision(down[0], down[1]) != null && filter(battleModel.getCollision(down[0], down[1]));
					if (battleModel.row > left[0] && left[1] < battleModel.col)
						leftBoolean = battleModel.getCollision(left[0], left[1]) != null && filter(battleModel.getCollision(left[0], left[1]));
					var cell:IBattleItemModel = battleModel.getCollision(r, c);
					if (filter(cell)) {
						if (upBoolean && leftBoolean) {
							_bitmap.bitmapData.draw(instance
								, new Matrix(1, 0, 0, 1, c * battleModel.cellPixel - (battleModel.cellPixel >> 1), r * battleModel.cellPixel - (battleModel.cellPixel >> 1)), null, null
								, new Rectangle(c * battleModel.cellPixel, r * battleModel.cellPixel, battleModel.cellPixel >> 1, battleModel.cellPixel >> 1)
							);
						} else if (upBoolean && leftBoolean == false) {
							_bitmap.bitmapData.draw(instance
								, new Matrix(1, 0, 0, 1, c * battleModel.cellPixel, r * battleModel.cellPixel - (battleModel.cellPixel >> 1)), null, null
								, new Rectangle(c * battleModel.cellPixel, r * battleModel.cellPixel, battleModel.cellPixel >> 1, battleModel.cellPixel >> 1)
							);
						} else if (upBoolean == false && leftBoolean) {
							_bitmap.bitmapData.draw(instance
								, new Matrix(1, 0, 0, 1, c * battleModel.cellPixel - (battleModel.cellPixel >> 1), r * battleModel.cellPixel), null, null
								, new Rectangle(c * battleModel.cellPixel, r * battleModel.cellPixel, battleModel.cellPixel >> 1, battleModel.cellPixel >> 1)
							);
						} else if (upBoolean == false && leftBoolean == false) {
							_bitmap.bitmapData.draw(instance
								, new Matrix(1, 0, 0, 1, c * battleModel.cellPixel, r * battleModel.cellPixel), null, null
								, new Rectangle(c * battleModel.cellPixel, r * battleModel.cellPixel, battleModel.cellPixel >> 1, battleModel.cellPixel >> 1)
							);
						}
						if (upBoolean && rightBoolean) {
							_bitmap.bitmapData.draw(instance
								, new Matrix(1, 0, 0, 1, c * battleModel.cellPixel - (battleModel.cellPixel >> 1), r * battleModel.cellPixel - (battleModel.cellPixel >> 1)), null, null
								, new Rectangle(c * battleModel.cellPixel + (battleModel.cellPixel >> 1), r * battleModel.cellPixel, battleModel.cellPixel >> 1, battleModel.cellPixel >> 1)
							);
						} else if (upBoolean && rightBoolean == false) {
							_bitmap.bitmapData.draw(instance
								, new Matrix(1, 0, 0, 1, c * battleModel.cellPixel - battleModel.cellPixel, r * battleModel.cellPixel - battleModel.cellPixel), null, null
								, new Rectangle(c * battleModel.cellPixel + (battleModel.cellPixel >> 1), r * battleModel.cellPixel, battleModel.cellPixel >> 1, battleModel.cellPixel >> 1)
							);
						} else if (upBoolean == false && rightBoolean) {
							_bitmap.bitmapData.draw(instance
								, new Matrix(1, 0, 0, 1, c * battleModel.cellPixel - battleModel.cellPixel * .5, r * battleModel.cellPixel), null, null
								, new Rectangle(c * battleModel.cellPixel + (battleModel.cellPixel >> 1), r * battleModel.cellPixel, battleModel.cellPixel >> 1, battleModel.cellPixel >> 1)
							);
						} else if (upBoolean == false && rightBoolean == false) {
							_bitmap.bitmapData.draw(instance
								, new Matrix(1, 0, 0, 1, c * battleModel.cellPixel - battleModel.cellPixel, r * battleModel.cellPixel), null, null
								, new Rectangle(c * battleModel.cellPixel + (battleModel.cellPixel >> 1), r * battleModel.cellPixel, battleModel.cellPixel >> 1, battleModel.cellPixel >> 1)
							);
						}
						if (downBoolean && leftBoolean) {
							_bitmap.bitmapData.draw(instance
								, new Matrix(1, 0, 0, 1, c * battleModel.cellPixel - battleModel.cellPixel * .5, r * battleModel.cellPixel - battleModel.cellPixel * .5), null, null
								, new Rectangle(c * battleModel.cellPixel, r * battleModel.cellPixel + battleModel.cellPixel * .5, battleModel.cellPixel >> 1, battleModel.cellPixel >> 1)
							);
						} else if (downBoolean && leftBoolean == false) {
							_bitmap.bitmapData.draw(instance
								, new Matrix(1, 0, 0, 1, c * battleModel.cellPixel, r * battleModel.cellPixel - battleModel.cellPixel * .5), null, null
								, new Rectangle(c * battleModel.cellPixel, r * battleModel.cellPixel + battleModel.cellPixel * .5, battleModel.cellPixel >> 1, battleModel.cellPixel >> 1)
							);
						} else if (downBoolean == false && leftBoolean) {
							_bitmap.bitmapData.draw(instance
								, new Matrix(1, 0, 0, 1, c * battleModel.cellPixel - battleModel.cellPixel * .5, r * battleModel.cellPixel - battleModel.cellPixel), null, null
								, new Rectangle(c * battleModel.cellPixel, r * battleModel.cellPixel + battleModel.cellPixel * .5, battleModel.cellPixel >> 1, battleModel.cellPixel >> 1)
							);
						} else if (downBoolean == false && leftBoolean == false) {
							_bitmap.bitmapData.draw(instance
								, new Matrix(1, 0, 0, 1, c * battleModel.cellPixel, r * battleModel.cellPixel - battleModel.cellPixel), null, null
								, new Rectangle(c * battleModel.cellPixel, r * battleModel.cellPixel + battleModel.cellPixel * .5, battleModel.cellPixel >> 1, battleModel.cellPixel >> 1)
							);
						}
						if (downBoolean && rightBoolean) {
							_bitmap.bitmapData.draw(instance
								, new Matrix(1, 0, 0, 1, c * battleModel.cellPixel - battleModel.cellPixel * .5, r * battleModel.cellPixel - battleModel.cellPixel * .5), null, null
								, new Rectangle(c * battleModel.cellPixel + battleModel.cellPixel * .5, r * battleModel.cellPixel + battleModel.cellPixel * .5, battleModel.cellPixel >> 1, battleModel.cellPixel >> 1)
							);
						} else if (downBoolean && rightBoolean == false) {
							_bitmap.bitmapData.draw(instance
								, new Matrix(1, 0, 0, 1, c * battleModel.cellPixel - battleModel.cellPixel, r * battleModel.cellPixel - battleModel.cellPixel * .5), null, null
								, new Rectangle(c * battleModel.cellPixel + battleModel.cellPixel * .5, r * battleModel.cellPixel + battleModel.cellPixel * .5, battleModel.cellPixel >> 1, battleModel.cellPixel >> 1)
							);
						} else if (downBoolean == false && rightBoolean) {
							_bitmap.bitmapData.draw(instance
								, new Matrix(1, 0, 0, 1, c * battleModel.cellPixel - battleModel.cellPixel * .5, r * battleModel.cellPixel - battleModel.cellPixel), null, null
								, new Rectangle(c * battleModel.cellPixel + battleModel.cellPixel * .5, r * battleModel.cellPixel + battleModel.cellPixel * .5, battleModel.cellPixel >> 1, battleModel.cellPixel >> 1)
							);
						} else if (downBoolean == false && rightBoolean == false) {
							_bitmap.bitmapData.draw(instance
								, new Matrix(1, 0, 0, 1, c * battleModel.cellPixel - battleModel.cellPixel, r * battleModel.cellPixel - battleModel.cellPixel), null, null
								, new Rectangle(c * battleModel.cellPixel + battleModel.cellPixel * .5, r * battleModel.cellPixel + battleModel.cellPixel * .5, battleModel.cellPixel >> 1, battleModel.cellPixel >> 1)
							);
						}
					}
				}
			}
		}

		override protected function doDispose():void {
			while (_bmps.length) {
				var bmp:Bitmap = _bmps.shift();
				bmp.bitmapData.dispose();
			}
			_camera.removeEventListener(Event.CHANGE, _handleCameraChanged);
			super.doDispose();
		}
	}
}
