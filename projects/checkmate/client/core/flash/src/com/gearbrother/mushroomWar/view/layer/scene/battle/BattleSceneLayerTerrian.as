package com.gearbrother.mushroomWar.view.layer.scene.battle {
	import com.gearbrother.glash.common.oper.GOper;
	import com.gearbrother.glash.common.oper.ext.GAliasFile;
	import com.gearbrother.glash.common.oper.ext.GFile;
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.flixel.GPaperLayer;
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
	public class BattleSceneLayerTerrian extends GPaperLayer {
		override protected function _handleLibsSuccess(res:*):void {
			var file:GFile = libsHandler.cachedOper[libs[0]];
			addChild(file.getInstance("Background"));
			cacheAsBitmap = true;
		}

		public function BattleSceneLayerTerrian(battleModel:BattleModel, camera:Camera) {
			super(camera);

			bindData = battleModel;
			libs = [new GAliasFile(battleModel.background)];
		}
	}
}
