package com.gearbrother.sheepwolf.model {
	import com.gearbrother.sheepwolf.rpc.protocol.bussiness.BattleUserActionSkillUsingProtocol;
	import com.gearbrother.sheepwolf.rpc.protocol.bussiness.BattleUserActionWalkProtocol;
	import com.gearbrother.sheepwolf.rpc.protocol.bussiness.BattleItemUserProtocol;
	import com.gearbrother.sheepwolf.rpc.protocol.bussiness.PointBeanProtocol;
	import com.gearbrother.sheepwolf.view.util.RectUtil;
	
	import flash.geom.Point;


	/**
	 * @author lifeng
	 * @create on 2014-3-5
	 */
	public class BattleItemUserModel extends BattleItemUserProtocol implements IBattleItemModel {
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
		
		public function BattleItemUserModel(prototype:Object = null) {
			super(prototype);
		}

		public function getPosition(battle:BattleModel):Point {
			if (currentAction is BattleUserActionWalkModel) {
				return (currentAction as BattleUserActionWalkModel).getPoint(this, battle, GameModel.instance.application.serverTime);
			} else if (currentAction is BattleUserActionSkillUsingModel) {
				return new Point((currentAction as BattleUserActionSkillUsingModel).startPosition.x, (currentAction as BattleUserActionSkillUsingProtocol).startPosition.y);
			} else {
				throw new Error("unknown action");
			}
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
			return {};
		}
	}
}
