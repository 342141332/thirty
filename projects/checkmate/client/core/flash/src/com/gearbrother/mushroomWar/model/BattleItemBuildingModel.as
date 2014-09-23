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
				delete _battle.items[instanceId];
			}
			this._battle = newValue;
			if (_battle) {
				_battle.items[instanceId] = this;
			}
		}
		
		public function BattleItemBuildingModel(prototype:Object = null) {
			super(prototype);
		}

		public function encode():Object {
			return null;
		}
		
		public function decode(obj:Object):BattleItemBuildingModel {
			for (var k:String in obj) {
				if (this.hasOwnProperty(k))
					this[k] = obj[k];
			}
			return this;
		}
	}
}
