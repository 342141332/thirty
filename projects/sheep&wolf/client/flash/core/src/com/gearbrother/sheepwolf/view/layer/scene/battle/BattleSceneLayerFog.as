package com.gearbrother.sheepwolf.view.layer.scene.battle {
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.util.camera.Camera;
	import com.gearbrother.sheepwolf.model.ApplicationModel;
	import com.gearbrother.sheepwolf.model.BattleModel;
	import com.gearbrother.sheepwolf.model.BattleUserActionWalkModel;
	import com.gearbrother.sheepwolf.model.BattleItemUserModel;
	import com.gearbrother.sheepwolf.model.GameModel;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;


	/**
	 * @author lifeng
	 * @create on 2014-6-12
	 */
	public class BattleSceneLayerFog extends GNoScale {
		[Embed(source="../../../../../../../../static/asset/shade.png")]
		public var shadeClazz:Class;
		
		private var _model:BattleModel;

		private var _camera:Camera;
		
		public var maskBmd:BitmapData;
		
		public var maskShape:DisplayObject;
		
		public var bmd:BitmapData;

		public function BattleSceneLayerFog(battleModel:BattleModel, camera:Camera) {
			super(skin);
			
			_model = battleModel;
			_camera = camera;
		}
		
		override protected function doInit():void {
			maskBmd = (new shadeClazz() as Bitmap).bitmapData;
			var shape:Shape = new Shape;
			shape.graphics.beginBitmapFill(maskBmd);
			shape.graphics.drawRect(0, 0, maskBmd.width, maskBmd.height);
			shape.graphics.endFill();
			maskShape = shape;
			
			bmd = new BitmapData(_camera.bound.width, _camera.bound.height, true, 0xff000000);
			var fog:Bitmap = new Bitmap(bmd);
			addChild(fog);
			mouseEnabled = mouseChildren = false;
		}
		
		override public function tick(interval:int):void {
			var battleModel:BattleModel = bindData;
			bmd.fillRect(new Rectangle(0, 0, _camera.bound.width, _camera.bound.height), 0xff000000);
			for each (var user:BattleItemUserModel in _model.items) {
				if (user.isSheep) {
					var pt:Point = user.getPosition(_model);
					pt.x *= battleModel.cellPixel;
					pt.y *= battleModel.cellPixel;
					clear(pt);
				}
			}
			bmd.scroll(-_camera.screenRect.left, -_camera.screenRect.top);
		}
		
		public function clear(dest:Point):void {
			dest.x -= maskShape.width >> 1;
			dest.y -= maskShape.height >> 1;
			var matrix:Matrix = new Matrix(1, 0, 0, 1, dest.x, dest.y);
			bmd.draw(maskShape, matrix, null, BlendMode.ERASE);
			//			bmd.threshold(maskBmd, new Rectangle(0, 0, maskBmd.width, maskBmd.height), dest, "==", 0xFF000000, 0x00000000, 0xFFFFFFFF, true);
		}
		
		override protected function doDispose():void {
			if (bmd)
				bmd.dispose();
			
			super.doDispose();
		}
	}
}
