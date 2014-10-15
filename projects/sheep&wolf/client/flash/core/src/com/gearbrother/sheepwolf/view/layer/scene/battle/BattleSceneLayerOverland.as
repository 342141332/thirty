package com.gearbrother.sheepwolf.view.layer.scene.battle {
	import com.gearbrother.glash.display.flixel.GPaperLayer;
	import com.gearbrother.glash.display.flixel.sort.SortYManager;
	import com.gearbrother.glash.util.camera.Camera;
	import com.gearbrother.sheepwolf.model.BattleModel;
	import com.gearbrother.sheepwolf.model.BattleItemUserModel;
	import com.gearbrother.sheepwolf.model.IBattleItemModel;
	import com.gearbrother.sheepwolf.model.IBattleItemThrowable;
	import com.gearbrother.sheepwolf.model.PointBeanModel;
	import com.gearbrother.sheepwolf.rpc.protocol.bussiness.BattleProtocol;
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
		
		public var loginedUserView:BattleItemUserSceneView;
		
		public var itemViews:Object;

		public function BattleSceneLayerOverland(id:String, battleModel:BattleModel, camera:Camera) {
			super(camera);

			this.id = id;
			this.sortManager = new SortYManager(this);
			this.itemViews = {};
			bindData = battleModel;
		}

		override public function handleModelChanged(events:Object=null):void {
			if (!events || events.hasOwnProperty(BattleProtocol.ITEMS)) {
				var model:BattleModel = bindData;
				var keys:Array = ObjectUtils.getKeys(itemViews);
				while (keys.length) {
					var key:String = keys.shift();
					removeChild(itemViews[key]);
				}
				itemViews = {};
				for (var itemUuid:String in model.items) {
					var itemModel:* = model.items[itemUuid];
					var itemView:DisplayObject = addItem(itemModel);
					if (itemView && model.loginedBattleUser == itemModel) {
						loginedUserView = itemView as BattleItemUserSceneView;
						camera.focus = loginedUserView;
					}
				}
			}
		}

		public function addItem(item:IBattleItemModel, throwFrom:PointBeanModel = null):DisplayObject {
			if (item.layer != id)
				return null;

			var battleModel:BattleModel = bindData;
			var itemView:BattleItemSceneView;
			if (item is BattleItemUserModel) {
				itemView = new BattleItemUserSceneView(item as BattleItemUserModel);
			} else {
				itemView = new BattleItemSceneView(item);
			}
			var throwToX:int = itemView.x = item.x * battleModel.cellPixel;
			var throwToY:int = itemView.y = item.y * battleModel.cellPixel;
			itemViews[item.uuid] = addChild(itemView);
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

		public function removeItem(item:IBattleItemModel):void {
			var view:BattleItemSceneView = itemViews[item.uuid];
			removeChild(view);
			delete itemViews[item.uuid];
		}
	}
}
