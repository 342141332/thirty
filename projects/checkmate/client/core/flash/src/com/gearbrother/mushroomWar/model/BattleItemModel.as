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
		public var battle:BattleModel;

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
