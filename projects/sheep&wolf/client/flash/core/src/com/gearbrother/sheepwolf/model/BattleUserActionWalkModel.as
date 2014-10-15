package com.gearbrother.sheepwolf.model {
	import com.gearbrother.sheepwolf.rpc.protocol.bussiness.BattleUserActionWalkProtocol;
	
	import flash.geom.Point;

	public class BattleUserActionWalkModel extends BattleUserActionWalkProtocol {
		static public const DIRECTION_UP:int = 1;
		
		static public const DIRECTION_RIGHT:int = 2;
		
		static public const DIRECTION_DOWN:int = 3;
		
		static public const DIRECTION_LEFT:int = 4;

		function BattleUserActionWalkModel(prototype:Object = null) {
			super(prototype);
		}

		public function getPoint(user:BattleItemUserModel, battle:BattleModel, currentTime:Number):Point {
			var xAdd:Number = .0;
			var yAdd:Number = .0;
			if (moveTo == DIRECTION_UP)
				yAdd = -1.0;
			else if (moveTo == DIRECTION_DOWN)
				yAdd = 1.0;
			else if (moveTo == DIRECTION_LEFT)
				xAdd = -1.0;
			else if (moveTo == DIRECTION_RIGHT)
				xAdd = 1.0;
			else
				throw new Error("unknown moveTo");
			currentTime = Math.min(currentTime, endTime);
			var passedPixelDistance:Number = changeSpeed * Math.max(0, Math.min(changeSpeedTime, currentTime) - startTime) / 1000
				+ moveSpeed * Math.max(0, Math.min(currentTime - startTime, currentTime - changeSpeedTime)) / 1000;
			var beginPos:Point = new Point(startPos.x, startPos.y);
			while (passedPixelDistance > .00001) {
				var toPos:Point = new Point(beginPos.x + xAdd * passedPixelDistance, beginPos.y + yAdd * passedPixelDistance);
				var collisionCellPt:Point = _checkCollision(user, battle, new Point(beginPos.x, beginPos.y), new Point(toPos.x, toPos.y));
				if (collisionCellPt) {
					var collisionPixelPt:Point = new Point(collisionCellPt.x, collisionCellPt.y);
					passedPixelDistance -= Point.distance(beginPos, collisionPixelPt);
					//check whether neighbour can pass through 
					beginPos = collisionPixelPt;
					var neighbourCell:IBattleItemModel;
					var passedNeighbourDistance:Number;
					if (moveTo == DIRECTION_UP || moveTo == DIRECTION_DOWN) {
						var roundX:Number = Math.round(collisionCellPt.x);
						neighbourCell = battle.getCollision(int(collisionCellPt.y) + yAdd * 1, int(roundX));
						if (neighbourCell && neighbourCell.isBlock(user)) {
							break;
						} else {
							passedNeighbourDistance = Math.min(passedPixelDistance, Point.distance(beginPos, new Point(roundX, beginPos.y)));
							beginPos.x += (roundX > collisionCellPt.x ? 1 : -1) * passedNeighbourDistance;
							passedPixelDistance -= passedNeighbourDistance;
						}
					} else if (moveTo == DIRECTION_LEFT || moveTo == DIRECTION_RIGHT) {
						var roundY:Number = Math.round(collisionCellPt.y);
						neighbourCell = battle.getCollision(int(roundY), int(collisionCellPt.x) + xAdd * 1);
						if (neighbourCell && neighbourCell.isBlock(user)) {
							break;
						} else {
							passedNeighbourDistance = Math.min(passedPixelDistance, Point.distance(beginPos, new Point(beginPos.x, roundY)));
							beginPos.y += (roundY > collisionCellPt.y ? 1 : -1) * passedNeighbourDistance;
							passedPixelDistance -= passedNeighbourDistance;
						}
					}
				} else {
					passedPixelDistance -= Point.distance(beginPos, toPos);
					beginPos.x = toPos.x;
					beginPos.y = toPos.y;
				}
			}
			beginPos.x = Math.max(0, Math.min(beginPos.x, battle.col - 1));
			beginPos.y = Math.max(0, Math.min(beginPos.y, battle.row - 1));
			return beginPos;
		}
		
		private function _checkCollision(user:BattleItemUserModel, battle:BattleModel, sourcePos:Point, targetPos:Point):Point {
			var xOffset:Number = targetPos.x - sourcePos.x;
			var yOffset:Number = targetPos.y - sourcePos.y;
			var y:int;
			var x:int;
			var d:BattleItemModel;
			if (xOffset > 0) {
				for (x = Math.floor(sourcePos.x); x <= Math.ceil(targetPos.x); x++) {
					for (y = Math.floor(sourcePos.y); y <= Math.ceil(sourcePos.y); y++) {
						d = battle.getCollision(y, x) as BattleItemModel;
						if (d && d.isBlock(user)) {
							return new Point(x - 1, sourcePos.y);
						}
					}
				}
				return null;
			} else if (xOffset < 0) {
				for (x = Math.ceil(sourcePos.x); x >= Math.floor(targetPos.x); x--) {
					for (y = Math.floor(sourcePos.y); y <= Math.ceil(sourcePos.y); y++) {
						d = battle.getCollision(y, x) as BattleItemModel;
						if (d && d.isBlock(user)) {
							return new Point(x + 1, sourcePos.y);
						}
					}
				}
				return null;
			} else if (yOffset > 0) {
				for (y = Math.floor(sourcePos.y); y <= Math.ceil(targetPos.y); y++) {
					for (x = Math.floor(sourcePos.x); x <= Math.ceil(targetPos.x); x++) {
						d = battle.getCollision(y, x) as BattleItemModel;
						if (d && d.isBlock(user)) {
							return new Point(sourcePos.x, y - 1);
						}
					}
				}
				return null;
			} else if (yOffset < 0) {
				for (y = Math.ceil(sourcePos.y); y >= Math.floor(targetPos.y); y--) {
					for (x = Math.floor(sourcePos.x); x <= Math.ceil(targetPos.x); x++) {
						d = battle.getCollision(y, x) as BattleItemModel;
						if (d && d.isBlock(user)) {
							return new Point(sourcePos.x, y + 1);
						}
					}
				}
				return null;
			} else {
				return null;
			}
		}
	}
}
