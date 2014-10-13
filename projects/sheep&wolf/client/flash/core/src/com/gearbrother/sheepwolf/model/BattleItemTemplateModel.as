package com.gearbrother.sheepwolf.model {
	import com.gearbrother.sheepwolf.rpc.protocol.bussiness.BattleItemTemplateProtocol;


	/**
	 *
	 * @author 	Neo.Zhang
	 * @create 	2014-8-20 下午7:32:35
	 *
	 */
	public class BattleItemTemplateModel extends BattleItemTemplateProtocol {
		public function BattleItemTemplateModel(prototype:Object = null) {
			super(prototype);
		}

		public function decode(obj:Object):BattleItemTemplateModel {
			for (var k:String in obj) {
				this[k] = obj[k];
			}
			return this;
		}
		
		public function encode():Object {
			return {
				"layer": layer
				, "width": width
				, "height": height
				, "cartoon": cartoon
				, "isCollisionable": isCollisionable
				, "touchLocalCall": touchLocalCall
				, "touchLocalCallParams": touchLocalCallParams
				, "touchAutoRemoteCall": touchAutoRemoteCall
				, "touchAutoRemoteCallParams": touchAutoRemoteCallParams
				, "touchManualRemoteCall": touchManualRemoteCall
				, "touchManualRemoteCallParams": touchManualRemoteCallParams
				, "isSheepPassable": isSheepPassable
				, "isWolfPassable": isWolfPassable
			};
		}
	}
}
