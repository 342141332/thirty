package com.gearbrother.sheepwolf.pojo;

import java.awt.Point;

import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanProperty;

/**
 * @author feng.lee
 * @create on 2014-5-19
 */
@RpcBeanPartTransportable
public class BattleUserActionWalk extends RpcBean {
	static public BattleUserActionWalk buildStop(long startTime, PointBean pos, int faceTo, BattleItemUser user) {
		BattleUserActionWalk actionWalk = new BattleUserActionWalk(startTime, pos, faceTo, Direction.DIRECTION_DOWN, user.orginalSpeed, user.orginalSpeed, 0);
		actionWalk.endTime = startTime;
		return actionWalk;
	}
	
	@RpcBeanProperty(desc = "开始时间")
	public long startTime;

	@RpcBeanProperty(desc = "开始位置")
	public PointBean startPos;
	
	@RpcBeanProperty(desc = "脸方向")
	public int startFaceTo;
	
	@RpcBeanProperty(desc = "方向")
	public int moveTo;
	
	@RpcBeanProperty(desc = "移动速度")
	public double moveSpeed;
	
	@RpcBeanProperty(desc = "超时后的移动速度")
	public double changeSpeed;

	@RpcBeanProperty(desc = "超时时间")
	public long changeSpeedTime;
	
	@RpcBeanProperty(desc = "结束时间")
	public long endTime;

	public BattleUserActionWalk(long startTime, PointBean startPos, int startFaceTo, int moveTo, double moveSpeed, double changeSpeed, long changeSpeedTime) {
		super();

		this.startTime = startTime;
		this.startPos = startPos;
		this.startFaceTo = startFaceTo;
		this.moveTo = moveTo;
		this.moveSpeed = moveSpeed;
		this.changeSpeed = changeSpeed;
		this.changeSpeedTime = changeSpeedTime;
		this.endTime = Long.MAX_VALUE;
	}
	
	public PointBean update(BattleItem item, long currentTime) {
		PointBean pt = getPoint(item, item.getBattle(), currentTime);
		startPos.x = pt.x;
		startPos.y = pt.y;
		this.startTime = currentTime;
		return pt;
	}

	public PointBean getPoint(Object item, Battle battle, long currentTime) {
		double xAdd = .0;
		double yAdd = .0;
		if (moveTo == Direction.DIRECTION_UP)
			yAdd = -1.0;
		else if (moveTo == Direction.DIRECTION_DOWN)
			yAdd = 1.0;
		else if (moveTo == Direction.DIRECTION_LEFT)
			xAdd = -1.0;
		else if (moveTo == Direction.DIRECTION_RIGHT)
			xAdd = 1.0;
		currentTime = Math.min(currentTime, endTime);
		double passedPixelDistance = changeSpeed * Math.max(0, Math.min(changeSpeedTime, currentTime) - startTime) / 1000
				+ moveSpeed * Math.max(0, Math.min(currentTime - startTime, currentTime - changeSpeedTime)) / 1000;
		PointBean beginPos = startPos.clone();
		while (passedPixelDistance > .00001) {
			PointBean toPos = new PointBean(beginPos.x + xAdd * passedPixelDistance, beginPos.y + yAdd * passedPixelDistance);
			PointBean collisionCellPt = _checkCollision(item, battle, new PointBean(beginPos.x, beginPos.y), new PointBean(toPos.x, toPos.y));
			if (collisionCellPt != null) {
				PointBean collisionPixelPt = new PointBean(collisionCellPt.x, collisionCellPt.y);
				passedPixelDistance -= Point.distance(beginPos.x, beginPos.y, collisionPixelPt.x, collisionPixelPt.y);
				beginPos = collisionPixelPt;
				BattleItem neighbourCell;
				double passedNeighbourDistance;
				if (moveTo == Direction.DIRECTION_UP || moveTo == Direction.DIRECTION_DOWN) {
					int roundX = (int) Math.round(collisionCellPt.x);
					neighbourCell = battle.getCollision((int) (collisionCellPt.y + yAdd * 1), roundX);
					if (neighbourCell != null && neighbourCell.isBlock(item)) {
						break;
					} else {
						passedNeighbourDistance = Math.min(passedPixelDistance, Point.distance(beginPos.x, beginPos.y, roundX, beginPos.y));
						beginPos.x += (roundX > collisionCellPt.x ? 1 : -1) * passedNeighbourDistance;
						passedPixelDistance -= passedNeighbourDistance;
					}
				} else if (moveTo == Direction.DIRECTION_LEFT || moveTo == Direction.DIRECTION_RIGHT) {
					int roundY = (int) Math.round(collisionCellPt.y);
					neighbourCell = battle.getCollision(roundY, (int) (collisionCellPt.x + xAdd * 1));
					if (neighbourCell != null && neighbourCell.isBlock(item)) {
						break;
					} else {
						passedNeighbourDistance = Math.min(passedPixelDistance, Point.distance(beginPos.x, beginPos.y, beginPos.x, roundY));
						beginPos.y += (roundY > collisionCellPt.y ? 1 : -1) * passedNeighbourDistance;
						passedPixelDistance -= passedNeighbourDistance;
					}
				}
			} else {
				passedPixelDistance -= Point.distance(beginPos.x, beginPos.y, toPos.x, toPos.y);
				beginPos.x = toPos.x;
				beginPos.y = toPos.y;
			}
		}
		beginPos.x = Math.max(0, Math.min(beginPos.x, battle.col - 1));
		beginPos.y = Math.max(0, Math.min(beginPos.y, battle.row - 1));
		return beginPos;
	}
	
	private PointBean _checkCollision(Object item, Battle battle, PointBean sourcePos, PointBean targetPos) {
		double xOffset = targetPos.x - sourcePos.x;
		double yOffset = targetPos.y - sourcePos.y;
		int y;
		int x;
		BattleItem d;
		if (xOffset > 0) {
			for (x = (int) Math.floor(sourcePos.x); x <= Math.ceil(targetPos.x); x++) {
				for (y = (int) Math.floor(sourcePos.y); y <= Math.ceil(sourcePos.y); y++) {
					d = battle.getCollision(y, x);
					if (d != null && d.isBlock(item)) {
						return new PointBean(x - 1, sourcePos.y);
					}
				}
			}
			return null;
		} else if (xOffset < 0) {
			for (x = (int) Math.ceil(sourcePos.x); x >= Math.floor(targetPos.x); x--) {
				for (y = (int) Math.floor(sourcePos.y); y <= Math.ceil(sourcePos.y); y++) {
					d = battle.getCollision(y, x);
					if (d != null && d.isBlock(item)) {
						return new PointBean(x + 1, sourcePos.y);
					}
				}
			}
			return null;
		} else if (yOffset > 0) {
			for (y = (int) Math.floor(sourcePos.y); y <= Math.ceil(targetPos.y); y++) {
				for (x = (int) Math.floor(sourcePos.x); x <= Math.ceil(targetPos.x); x++) {
					d = battle.getCollision(y, x);
					if (d != null && d.isBlock(item)) {
						return new PointBean(sourcePos.x, y - 1);
					}
				}
			}
			return null;
		} else if (yOffset < 0) {
			for (y = (int) Math.ceil(sourcePos.y); y >= Math.floor(targetPos.y); y--) {
				for (x = (int) Math.floor(sourcePos.x); x <= Math.ceil(targetPos.x); x++) {
					d = battle.getCollision(y, x);
					if (d != null && d.isBlock(item)) {
						return new PointBean(sourcePos.x, y + 1);
					}
				}
			}
			return null;
		} else {
			return null;
		}
	}
}
