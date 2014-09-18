package com.gearbrother.sheepwolf.model {
	import com.gearbrother.sheepwolf.rpc.protocol.bussiness.BattleItemProtocol;
	import com.gearbrother.sheepwolf.rpc.protocol.bussiness.BoundsProtocol;
	import com.gearbrother.sheepwolf.view.layer.scene.battle.BattleItemUserSceneView;
	import com.gearbrother.sheepwolf.view.util.RectUtil;
	
	import org.as3commons.lang.ObjectUtils;


	/**
	 *
	 * @author 	Neo.Zhang
	 * @create 	2014-8-20 下午7:01:59
	 *
	 */
	public class BattleItemModel extends BattleItemProtocol implements IBattleItemModel {
		private var _battle:BattleModel;
		public function get battle():BattleModel {
			return _battle;
		}
		public function set battle(newValue:BattleModel):void {
			if (_battle) {
				for (var r:int = y; r < y + height; r++) {
					for (var c:int = x; c < x + width; c++) {
						_battle.setCollision(r, c, null);
					}
				}
				delete _battle.items[uuid];
			}
			this._battle = newValue;
			if (_battle) {
				if (isCollisionable) {
					for (r = y; r < y + height; r++) {
						for (c = x; c < x + width; c++) {
							_battle.setCollision(r, c, this);
						}
					}
				}
				_battle.items[uuid] = this;
			}
		}
		
		public function BattleItemModel(prototype:Object = null) {
			super(prototype);
		}

		public function intersect(item:IBattleItemModel):Boolean {
			return RectUtil.intersects(this.x, this.y, this.width, this.height
				, item.x, item.y, item.width, item.height);
		}
		
		public function isBlock(item:IBattleItemModel):Boolean {
			if (item is BattleItemUserModel) {
				var user:BattleItemUserModel = item as BattleItemUserModel;
				if (user.color == BattleColorModel.SHEEP)
					return !isSheepPassable;
				else if (user.color == BattleColorModel.WOLF)
					return !isWolfPassable;
			}
			return true;
		}

		public function encode():Object {
			var obj:Object = {};
			obj.uuid = uuid;
			obj.x = x;
			obj.y = y;
			obj.width = width;
			obj.height = height;
			obj.layer = layer;
			obj.cartoon = cartoon;
			if (isDestoryable) {
				obj.isDestoryable = true;
				obj.maxHp = maxHp;
			}
			if (isCollisionable) {
				obj.isCollisionable = true;
				if (isSheepPassable)
					obj.isSheepPassable = isSheepPassable;
				if (isWolfPassable)
					obj.isWolfPassable = isWolfPassable;
			}
			if (touchAutoRemoteCall)
				obj.touchAutoRemoteCall = touchAutoRemoteCall;
			if (touchAutoRemoteCallParams)
				obj.touchAutoRemoteCallParams = touchAutoRemoteCallParams;
			if (touchManualRemoteCall)
				obj.touchManualRemoteCall = touchManualRemoteCall;
			if (touchManualRemoteCallParams)
				obj.touchManualRemoteCallParams = touchManualRemoteCallParams;
			return obj;
		}

		public function decode(obj:Object):BattleItemModel {
			for (var k:String in obj) {
				this[k] = obj[k];
			}
			return this;
		}
	}
}
