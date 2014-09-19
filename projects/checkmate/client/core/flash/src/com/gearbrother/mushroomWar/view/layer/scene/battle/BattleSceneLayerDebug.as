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
				for (var uuid:String in model.items) {
					var item:IBattleItemModel = model.items[uuid];
					_shape.graphics.drawRect(item.x - 10, item.y - 10, 20, 20);
				}
				_shape.graphics.endFill();
			}
		}
	}
}
