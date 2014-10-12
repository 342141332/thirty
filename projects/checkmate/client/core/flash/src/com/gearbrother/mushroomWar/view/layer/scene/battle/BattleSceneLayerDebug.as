package com.gearbrother.mushroomWar.view.layer.scene.battle {
	import com.gearbrother.glash.display.flixel.GPaperLayer;
	import com.gearbrother.glash.util.camera.Camera;
	import com.gearbrother.mushroomWar.model.BattleModel;
	import com.gearbrother.mushroomWar.model.IBattleItemModel;
	import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BattleProtocol;
	
	import flash.display.Shape;


	/**
	 *
	 * @author 	Neo.Zhang
	 * @create 	2014-8-22 下午6:41:39
	 *
	 */
	public class BattleSceneLayerDebug extends GPaperLayer {
		private var _shape:Shape;
		
		public function BattleSceneLayerDebug(model:BattleModel, camera:Camera) {
			super(camera);
			
			_shape = new Shape();
			_shape.cacheAsBitmap = true;
			addChild(_shape);
			bindData = model;
			mouseEnabled = mouseChildren = false;
			cacheAsBitmap = true;
		}
		
		override public function handleModelChanged(events:Object=null):void {
			var model:BattleModel = bindData;
			if (!events || events.hasOwnProperty(BattleProtocol.ITEMS)) {
				_shape.graphics.clear();
				_shape.graphics.beginFill(0x0000ff, .7);
				_shape.graphics.lineStyle(1, 0x000000, .3);
				for (var r:int = 1; r < model.row; r++) {
					_shape.graphics.moveTo(0, r * model.cellPixel);
					_shape.graphics.lineTo(model.col * model.cellPixel, r * model.cellPixel);
				}
				for (var c:int = 1; c < model.col; c++) {
					_shape.graphics.moveTo(c * model.cellPixel, 0);
					_shape.graphics.lineTo(c * model.cellPixel, model.row * model.cellPixel);					
				}
				for (var uuid:String in model.items) {
					var item:IBattleItemModel = model.items[uuid];
					_shape.graphics.drawRect(item.x - 10, item.y - 10, 20, 20);
				}
				_shape.graphics.endFill();
			}
		}
	}
}
