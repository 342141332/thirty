package com.gearbrother.mushroomWar.model {
	import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BattleItemProtocol;
	import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BoundsProtocol;
	import com.gearbrother.mushroomWar.view.util.RectUtil;

	import org.as3commons.lang.ObjectUtils;


	/**
	 *
	 * @author 	Neo.Zhang
	 * @create 	2014-8-20 下午7:01:59
	 *
	 */
	public class BattleItemModel extends BattleItemProtocol {
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

		public function BattleItemModel(prototype:Object = null) {
			super(prototype);
		}

		public function encode():Object {
			var obj:Object = {};
			obj.uuid = instanceId;
			obj.top = top;
			obj.left = left;
			obj.layer = layer;
			obj.cartoon = cartoon;
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
