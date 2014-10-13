package com.gearbrother.sheepwolf.view.layer.scene.battle {
	import com.gearbrother.glash.common.oper.ext.GAliasFile;
	import com.gearbrother.glash.common.oper.ext.GFile;
	import com.gearbrother.glash.display.propertyHandler.GPropertyBindDataHandler;
	import com.gearbrother.sheepwolf.model.BattleItemUserModel;
	import com.gearbrother.sheepwolf.rpc.protocol.bussiness.BattleItemUserProtocol;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;


	/**
	 *
	 * @author 	Neo.Zhang
	 * @create 	2014-8-5 下午3:33:09
	 *
	 */
	public class BattleSceneItemPuzzleSlotView extends BattleItemSceneView {
		private var _bindBattleHandler:GPropertyBindDataHandler;
		public function get bindUser():BattleItemUserModel {
			return _bindBattleHandler ? _bindBattleHandler.value : null;
		}
		public function set bindUser(newValue:BattleItemUserModel):void {
			_bindBattleHandler ||= new GPropertyBindDataHandler(handleModelChanged2, this);
			_bindBattleHandler.value = newValue;
		}
		
		public var sourceBmd:BitmapData;
		
		public var bmd:Bitmap;
		
		private var _lastFinishedPixel:Number;

		public function BattleSceneItemPuzzleSlotView(model:BattleItemPuzzleSlotModel) {
			super(model);

			if (model.battle.loginedBattleUser)
				this.bindUser = model.battle.loginedBattleUser;
			this.libs = [new GAliasFile("static/asset/item/tree_3.swf")];
			_lastFinishedPixel = -1;
//			this.graphics.beginFill(0xffffff, .3);
//			this.graphics.drawRect(-model.bounds.width >> 1, -model.bounds.height >> 1, model.bounds.width, model.bounds.height);
//			this.graphics.endFill();
		}
		
		override protected function _handleLibsSuccess(res:*):void {
			var file:GFile = libsHandler.cachedOper[libs[0]];
			if (file.isStateEnd()) {
				var model:BattleItemPuzzleSlotModel = bindData;
				var instance:DisplayObject = file.getInstance("Value");
				var scaleRate:Number = Math.min(instance.width / instance.height, model.bounds.width / model.bounds.height);
				var scale:Number;
				if (scaleRate > 1) {
					scale = model.bounds.width / instance.width;
				} else {
					scale = model.bounds.height / instance.height;
				}
				sourceBmd = new BitmapData(instance.width * scale, instance.height * scale, true, 0x00000000);
				var bounds:Rectangle = instance.getBounds(instance);
				var m:Matrix = instance.transform.matrix.clone();
				m.a = m.d = scale;
				m.tx = -bounds.left * scale;
				m.ty = -bounds.top * scale;
				sourceBmd.draw(instance, m);
				
				bmd = new Bitmap(new BitmapData(sourceBmd.width, sourceBmd.height, true, 0x00000000));
				bmd.x = -int(m.tx);
				bmd.y = -int(m.ty);
				addChild(bmd);
				revalidateBindData();
			}
		}
		
		public function handleModelChanged2(events:Object = null):void {
			if (!events || events.hasOwnProperty(BattleItemUserProtocol.PICK_UPED_PUZZLE)) {
				var puzzleSlot:BattleItemPuzzleSlotModel = bindData;
				if (bindUser && bindUser.pickUpedPuzzle) {
					coupleFilter.apply(this);
				} else {
					coupleFilter.unapply(this);
				}
			}
		}
		
		override public function handleModelChanged(events:Object=null):void {
			var model:BattleItemPuzzleSlotModel = bindData;
			if (!events || events.hasOwnProperty(BattleItemPuzzleSlotProtocol.FINISHED_PUZZLE_TOTAL)) {
				if (sourceBmd) {
					refreshTimer = 100;
				}
			}
		}
		
		override public function refresh(time:int):void {
			var model:BattleItemPuzzleSlotModel = bindData;
			var growPixel:int = sourceBmd.height * model.finishedPuzzleTotal / model.puzzleTotal;
			if (_lastFinishedPixel != growPixel) {
				bmd.bitmapData.copyPixels(sourceBmd, new Rectangle(0, 0, sourceBmd.width, sourceBmd.height), new Point());
				bmd.bitmapData.applyFilter(sourceBmd
					, new Rectangle(0, 0, sourceBmd.width, sourceBmd.height - _lastFinishedPixel)
					, new Point(0, 0)
					, new ColorMatrixFilter([0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0])
				);
				_lastFinishedPixel += 1; 
			} else {
				refreshTimer = 0;
			}
		}
	}
}
