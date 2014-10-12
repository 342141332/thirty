package com.gearbrother.mushroomWar.model {
	import com.gearbrother.glash.common.algorithm.GBinaryHeap;
	import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BattleProtocol;


	/**
	 * @author lifeng
	 * @create on 2014-1-7
	 */
	public class BattleModel extends BattleProtocol {
		private var _loginedUser:BattleRoomSeatModel;
		public function get loginedBattleUser():BattleRoomSeatModel {
			return _loginedUser;
		}
		public function set loginedBattleUser(newValue:BattleRoomSeatModel):void {
			_loginedUser = newValue;
		}

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
			col = prototype.width;
			row = prototype.height;
			cellPixel = prototype.cellPixel;
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
