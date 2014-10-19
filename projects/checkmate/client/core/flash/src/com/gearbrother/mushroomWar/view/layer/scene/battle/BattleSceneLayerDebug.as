package com.gearbrother.mushroomWar.view.layer.scene.battle {
	import com.gearbrother.glash.display.flixel.GPaperLayer;
	import com.gearbrother.glash.util.camera.Camera;
	import com.gearbrother.mushroomWar.model.BattleItemModel;
	import com.gearbrother.mushroomWar.model.BattleModel;
	import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BattleForceProtocol;
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
				//draw grid
				graphics.clear();
				graphics.beginFill(0x0000ff, .0);
				graphics.lineStyle(1, 0xffffff, .3);
				for (var r:int = 0; r <= model.row; r++) {
					graphics.moveTo(model.left, model.top + r * model.cellPixel);
					graphics.lineTo(model.left + model.col * model.cellPixel, model.top + r * model.cellPixel);
				}
				for (var c:int = 0; c <= model.col; c++) {
					graphics.moveTo(model.left + c * model.cellPixel, model.top);
					graphics.lineTo(model.left + c * model.cellPixel, model.top + model.row * model.cellPixel);					
				}
				
				//draw border
				var force:BattleForceProtocol = model.forces[0];
				graphics.beginFill(0x00ff00, .3);
				if (force.forward == 1) {
					graphics.drawRect(model.left, model.top, force.border * model.cellPixel, model.cellPixel * model.row);
				} else if (force.forward == -1) {
					graphics.drawRect(model.left + (model.col - force.border) * model.cellPixel, model.top, model.cellPixel * force.border, model.cellPixel * model.row);
				}
				graphics.endFill();
				force = model.forces[1];
				graphics.beginFill(0xff0000, .3);
				if (force.forward == 1) {
					graphics.drawRect(model.left, model.top, force.border * model.cellPixel, model.cellPixel * model.row);
				} else if (force.forward == -1) {
					graphics.drawRect(model.left + (model.col - force.border) * model.cellPixel, model.top, model.cellPixel * force.border, model.cellPixel * model.row);
				}
				graphics.endFill();
				
				//draw collision
				for (var uuid:String in model.items) {
					var item:BattleItemModel = model.items[uuid];
					graphics.drawRect(item.left, item.top, model.cellPixel, model.cellPixel);
				}
				graphics.endFill();
			}
		}
	}
}
