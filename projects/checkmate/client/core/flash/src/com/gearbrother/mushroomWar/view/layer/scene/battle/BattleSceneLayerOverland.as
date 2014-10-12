package com.gearbrother.mushroomWar.view.layer.scene.battle {
	import com.gearbrother.glash.display.flixel.GPaperLayer;
	import com.gearbrother.glash.display.flixel.sort.SortYManager;
	import com.gearbrother.glash.util.camera.Camera;
	import com.gearbrother.mushroomWar.model.BattleItemModel;
	import com.gearbrother.mushroomWar.model.BattleModel;
	import com.gearbrother.mushroomWar.model.PointBeanModel;
	import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BattleProtocol;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	
	import org.as3commons.lang.ObjectUtils;


	/**
	 * 
	 *
	 * @author lifeng
	 * @create on 2014-5-18
	 */
	public class BattleSceneLayerOverland extends GPaperLayer {
		public var id:String;
		
		public var itemViews:Object;

		public function BattleSceneLayerOverland(id:String, battleModel:BattleModel, camera:Camera) {
			super(camera);

			this.id = id;
			this.sortManager = new SortYManager(this);
			this.itemViews = {};
			bindData = battleModel;
		}

		override public function handleModelChanged(events:Object=null):void {
			var model:BattleModel = bindData;
			if (!events
				|| events.hasOwnProperty(BattleProtocol.ITEMS)) {
				var keys:Array = ObjectUtils.getKeys(itemViews);
				while (keys.length) {
					var key:String = keys.shift();
					removeChild(itemViews[key]);
				}
				itemViews = {};
				for (var itemUuid:String in model.items) {
					var itemModel:* = model.items[itemUuid];
					var itemView:DisplayObject = addItem(itemModel);
				}
			}
		}

		public function addItem(item:BattleItemModel):DisplayObject {
			if (item.layer != id)
				return null;

			var battleModel:BattleModel = bindData;
			var itemView:DisplayObject = new BattleItemSceneView(item);
			var throwToX:int = itemView.x = (item.left + .5) * battleModel.cellPixel;
			var throwToY:int = itemView.y = (item.top + .5) * battleModel.cellPixel;
			if (!itemViews.hasOwnProperty(item.instanceId)) {
				itemViews[item.instanceId] = addChild(itemView);
			} else {
				throw new Error("duplicate");
 			}
			return itemView;
		}

		public function removeItem(item:BattleItemModel, duration:Number = .0):BattleItemSceneView {
			var view:BattleItemSceneView = itemViews[item.instanceId];
			delete itemViews[item.instanceId];
			if (view) {
				if (duration == .0)
					removeChild(view);
				else
					TweenLite.to(view._avatar, duration, {"alpha": .0, "y": -70, "scaleX": .5, "onComplete": removeChild, "onCompleteParams": [view]});
			}
			return view;
		}
	}
}
