package com.gearbrother.sheepwolf.model {
	import com.gearbrother.sheepwolf.rpc.protocol.bussiness.BattleProtocol;


	/**
	 * @author lifeng
	 * @create on 2014-1-7
	 */
	public class BattleModel extends BattleProtocol {
		private var _loginedUser:BattleItemUserModel;
		public function get loginedBattleUser():BattleItemUserModel {
			return _loginedUser;
		}
		public function set loginedBattleUser(newValue:BattleItemUserModel):void {
			_loginedUser = newValue;
		}

		public var _collisions:Object;
		public function getCollision(row:int, col:int):IBattleItemModel {
			if (this._collisions.hasOwnProperty(row))
				return this._collisions[row][col];
			else
				return null;
		}
		public function setCollision(row:int, col:int, newValue:IBattleItemModel):void {
			_collisions[row] ||= {};
			this._collisions[row][col] = newValue;
		}
		
		public var templates:Array;

		public var users:Object;

		public function BattleModel(prototype:Object = null) {
			super(prototype);
			
			_collisions = {};
			users = {};
			for each (var item:IBattleItemModel in items) {
				item.battle = this;
				if (item is BattleItemUserModel) {
					var userModel:BattleItemUserModel = item as BattleItemUserModel;
					users[userModel.uuid] = userModel;
				}
			}
			sheepSleepAt = 0;
			wolfSleepAt = 1000;
			expiredPeriod = 5 * 60 * 1000;
		}

		public function decode(prototype:Object):void {
			if (prototype.hasOwnProperty("template")) {
				this.templates = [];
				for (var id:String in prototype.template) {
					this.templates.push(new BattleItemTemplateModel().decode(prototype.template[id]));
				}
			}
			if (prototype.hasOwnProperty("sheepBornBounds")) {
				sheepBornBounds = new BoundsModel().decode(prototype.sheepBornBounds);
			}
			if (prototype.hasOwnProperty("caughtBounds")) {
				caughtBounds = new BoundsModel().decode(prototype.caughtBounds);
			}
			if (prototype.hasOwnProperty("wolfBornBounds")) {
				wolfBornBounds = new BoundsModel().decode(prototype.wolfBornBounds);
			}
			row = prototype.row;
			col = prototype.col;
			this.cellPixel = prototype.cellPixel;
			items = {};
			for each (var itemObj:Object in prototype.items) {
				var item:BattleItemModel = new BattleItemModel().decode(itemObj);
				item.battle = this;
			}
			puzzleTotal = prototype.puzzleTotal;
		}

		public function encode():String {
			var templateObjs:Array = [];
			for (var id:String in this.templates) {
				templateObjs.push((templates[id] as BattleItemTemplateModel).encode());
			}
			var itemsObj:Array = [];
			for each (var itemModel:IBattleItemModel in this.items) {
				itemsObj.push(itemModel.encode());
			}
			return JSON.stringify(
				{
					"template": templateObjs
					, "sheepSleepAt": sheepSleepAt
					, "wolfSleepAt": wolfSleepAt
					, "sheepBornBounds": {"x": sheepBornBounds.x, "y": sheepBornBounds.y, "width": sheepBornBounds.width, "height": sheepBornBounds.height}
					, "caughtBounds": {"x": caughtBounds.x, "y": caughtBounds.y, "width": caughtBounds.width, "height": caughtBounds.height}
					, "wolfBornBounds": {"x": wolfBornBounds.x, "y": wolfBornBounds.y, "width": wolfBornBounds.width, "height": wolfBornBounds.height}
					, "row": row
					, "col": col
					, "cellPixel": cellPixel
					, "items": itemsObj
					, "expiredPeriod": expiredPeriod
					, "puzzleTotal": puzzleTotal
				}, null, "\t");
		}
	}
}
