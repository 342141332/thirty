package com.gearbrother.mushroomWar.model {
	import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BattleItemSoilderProtocol;


	/**
	 *
	 * @author 	Neo.Zhang
	 * @create 	2014-9-26 上午11:20:09
	 *
	 */
	public class BattleItemSoilderModel extends BattleItemSoilderProtocol implements IBattleItemModel {
		private var _battle:BattleModel;

		public function get battle():BattleModel {
			return _battle;
		}

		public function set battle(newValue:BattleModel):void {
			if (_battle) {
				delete _battle.items[instanceId];
			}
			this._battle = newValue;
			if (_battle) {
				_battle.items[instanceId] = this;
			}
		}

		public function BattleItemSoilderModel(prototype:Object = null) {
			super(prototype);
		}

		public function encode():Object {
			return null;
		}
	}
}
