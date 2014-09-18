package com.gearbrother.mushroomWar.view.layer.scene.battle {
	import com.gearbrother.glash.display.flixel.GPaperLayer;
	import com.gearbrother.glash.display.flixel.sort.SortYManager;
	import com.gearbrother.glash.util.camera.Camera;
	import com.gearbrother.mushroomWar.model.BattleModel;
	import com.gearbrother.mushroomWar.model.IBattleItemModel;
	import com.gearbrother.mushroomWar.model.IBattleItemThrowable;
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

		public function addItem(item:IBattleItemModel, throwFrom:PointBeanModel = null):DisplayObject {
			if (item.layer != id)
				return null;

			var battleModel:BattleModel = bindData;
			var itemView:DisplayObject = new BattleItemSceneView(item);
			var throwToX:int = itemView.x = item.x * battleModel.cellPixel;
			var throwToY:int = itemView.y = item.y * battleModel.cellPixel;
			if (!itemViews.hasOwnProperty(item.instanceId)) {
				itemViews[item.instanceId] = addChild(itemView);
			} else {
				throw new Error("duplicate");
 			}
			if (throwFrom && item is IBattleItemThrowable) {
				itemView.x = throwFrom.x;
				itemView.y = throwFrom.y;
				itemView.scaleX = itemView.scaleY = .1;
				var duration:Number = throwFrom.distance(throwToX, throwToY) / (item as IBattleItemThrowable).dropSpeed;
				TweenMax.to(itemView, .1, {"scaleX": 1, "scaleY": 1});
				TweenMax.to(itemView
					, duration
					, {
						"bezier":[{x: throwFrom.x + throwToX >> 1, y: (throwFrom.y + throwToY >> 1) + (throwToX - throwFrom.x) * .7}, {x: throwToX, y: throwToY}]
						, "rotation": duration / 0.2 * 360
						, "ease": Linear.easeNone
						, "onComplete": _handleOnLand
						, "onCompleteParams": [itemView]
					}
				);
			}
			return itemView;
		}
		
		private function _handleOnLand(itemView:BattleItemSceneView):void {
			TweenLite.to(itemView, .3, {"alpha": .0, "onComplete": removeChild, "onCompleteParams": [itemView]});
			var battleItemModel:IBattleItemModel = itemView.bindData;
			var shape:Shape = new Shape();
			shape.graphics.beginFill(0xff0000);
			shape.graphics.drawRect(0, 0, battleItemModel.width, battleItemModel.height);
			shape.graphics.endFill();
			shape.x = battleItemModel.x;
			shape.y = battleItemModel.y;
			shape.alpha = .0;
			addChild(shape);
			TweenLite.to(shape, .2, {"alpha": .3});
			TweenLite.to(shape, .2, {"alpha": .0, "delay": .2, "onComplete": removeChild, "onCompleteParams": [shape]});
		}

		public function removeItem(item:IBattleItemModel, duration:Number = .0):BattleItemSceneView {
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
