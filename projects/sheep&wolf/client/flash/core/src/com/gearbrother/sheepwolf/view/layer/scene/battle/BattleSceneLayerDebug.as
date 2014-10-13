package com.gearbrother.sheepwolf.view.layer.scene.battle {
	import com.gearbrother.glash.display.flixel.GPaperLayer;
	import com.gearbrother.glash.util.camera.Camera;
	import com.gearbrother.sheepwolf.model.BattleModel;
	import com.gearbrother.sheepwolf.model.IBattleItemModel;
	import com.gearbrother.sheepwolf.rpc.protocol.bussiness.BattleProtocol;
	
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
		}
		
		override public function handleModelChanged(events:Object=null):void {
			var model:BattleModel = bindData;
			if (!events || events.hasOwnProperty(BattleProtocol.ITEMS)) {
				_shape.graphics.clear();
				_shape.graphics.beginFill(0xff0000, .3);
				for (var row:String in model._collisions) {
					for (var col:String in model._collisions[row]) {
						item = model._collisions[row][col];
						if (item)
							_shape.graphics.drawRect(item.x * model.cellPixel, item.y * model.cellPixel, item.width * model.cellPixel, item.height * model.cellPixel);
					}
				}
				_shape.graphics.beginFill(0x0000ff, .2);
				for (var uuid:String in model.items) {
					var item:IBattleItemModel = model.items[uuid];
					if (!item.isCollisionable)
						_shape.graphics.drawRect(item.x * model.cellPixel, item.y * model.cellPixel, item.width * model.cellPixel, item.height * model.cellPixel);
				}
				_shape.graphics.endFill();
			}
		}
	}
}
