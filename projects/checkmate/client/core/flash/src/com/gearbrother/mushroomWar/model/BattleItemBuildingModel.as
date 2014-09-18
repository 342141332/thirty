package com.gearbrother.mushroomWar.model {
	import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BattleItemBuildingProtocol;


	/**
	 *
	 * @author 	Neo.Zhang
	 * @create 	2014-9-2 下午3:52:52
	 *
	 */
	public class BattleItemBuildingModel extends BattleItemBuildingProtocol implements IBattleItemModel {
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
				delete _battle.items[instanceId];
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
				_battle.items[instanceId] = this;
			}
		}
		
		public function BattleItemBuildingModel(prototype:Object = null) {
			super(prototype);
		}

		public function encode():Object {
			return null;
		}
	}
}
