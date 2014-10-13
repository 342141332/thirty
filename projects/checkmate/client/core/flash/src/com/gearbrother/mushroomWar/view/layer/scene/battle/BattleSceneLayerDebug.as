package com.gearbrother.mushroomWar.view.layer.scene.battle {
	import com.gearbrother.glash.display.flixel.GPaperLayer;
	import com.gearbrother.glash.util.camera.Camera;
	import com.gearbrother.mushroomWar.model.BattleItemModel;
	import com.gearbrother.mushroomWar.model.BattleModel;
	import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BattleProtocol;
	
	import flash.display.Shape;


	/**
	 *
	 * @author 	Neo.Zhang
	 * @create 	2014-8-22 下午6:41:39
	 *
	 */
	public class BattleSceneLayerDebug extends GPaperLayer {
		
		public function BattleSceneLayerDebug(model:BattleModel, camera:Camera) {
			super(camera);
			
			bindData = model;
			mouseEnabled = mouseChildren = false;
			cacheAsBitmap = true;
		}
		
		override public function handleModelChanged(events:Object=null):void {
			var model:BattleModel = bindData;
			if (!events || events.hasOwnProperty(BattleProtocol.ITEMS)) {
				graphics.clear();
				graphics.beginFill(0x0000ff, .7);
				graphics.lineStyle(1, 0xffffff, .3);
				for (var r:int = 1; r < model.row; r++) {
					graphics.moveTo(0, r * model.cellPixel);
					graphics.lineTo(model.col * model.cellPixel, r * model.cellPixel);
				}
				for (var c:int = 1; c < model.col; c++) {
					graphics.moveTo(c * model.cellPixel, 0);
					graphics.lineTo(c * model.cellPixel, model.row * model.cellPixel);					
				}
				for (var uuid:String in model.items) {
					var item:BattleItemModel = model.items[uuid];
					graphics.drawRect(item.left, item.top, model.cellPixel, model.cellPixel);
				}
				graphics.endFill();
			}
		}
	}
}
