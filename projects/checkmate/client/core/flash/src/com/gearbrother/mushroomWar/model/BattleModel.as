package com.gearbrother.mushroomWar.model {
	import com.gearbrother.glash.common.algorithm.GBinaryHeap;
	import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BattleForceProtocol;
	import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BattleProtocol;


	/**
	 * @author lifeng
	 * @create on 2014-1-7
	 */
	public class BattleModel extends BattleProtocol {
		public var _collisions:Object;
		public function getCollision(row:int, col:int):BattleItemModel {
			if (this._collisions.hasOwnProperty(row))
				return this._collisions[row][col];
			else
				return null;
		}
		public function setCollision(row:int, col:int, newValue:BattleItemModel):void {
			_collisions[row] ||= {};
			this._collisions[row][col] = newValue;
		}
		
		public function get loginedPlayer():BattlePlayerModel {
			for each (var force:BattleForceProtocol in forces) {
				for each (var player:BattlePlayerModel in force.players) {
					if (player.instanceId == GameModel.instance.loginedUser.uuid)
						return player;
				}
			}
			return null;
		}
		
		
		
		public function BattleModel(prototype:Object = null) {
			super(prototype);
			
			_collisions = {};
			for each (var item:BattleItemModel in items) {
				item.battle = this;
			}
		}

		public function decode(prototype:Object):BattleModel {
			items = {};
			for each (var itemObj:Object in prototype.items) {
				var item:BattleItemModel = new BattleItemModel().decode(itemObj);
				item.battle = this;
			}
			width = prototype.width;
			height = prototype.height;
			background = prototype.background;
			left = prototype.left;
			top = prototype.top;
			col = prototype.col;
			row = prototype.row;
			cellPixel = prototype.cellPixel;
			forces = [];
			for each (var forceProto:Object in prototype.force) {
				var force:BattleForceProtocol = new BattleForceProtocol();
				force.border = forceProto.border;
				force.forward = forceProto.forward;
				force.maxPlayer = forceProto.maxPlayer;
				forces.push(force);
			}
			return this;
		}

		public function encode():String {
			var itemsObj:Array = [];
			for each (var itemModel:BattleItemModel in this.items) {
				itemsObj.push(itemModel.encode());
			}
			return JSON.stringify(
				{
					"items": itemsObj
				}, null, "\t");
		}
	}
}
