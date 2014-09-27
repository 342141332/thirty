package com.gearbrother.mushroomWar.pojo;

import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;

@RpcBeanPartTransportable
public class TaskAttack extends TaskInterval {
	public BattleItemSoilder soilder;

	public BattleItem target;
	
	public BattleItem currentTarget;

	public TaskAttack(long lastIntervalTime, long interval, BattleItemSoilder soilder, BattleItem target) {
		super(lastIntervalTime, interval);

		this.soilder = soilder;
		this.target = target;
		if (this.target instanceof BattleItemSoilder) {
			this.currentTarget = this.target;
		} else if (this.target instanceof BattleItemBuilding) {
			this.currentTarget = null;
		} else {
			throw new Error("");
		}
	}

	@Override
	protected long doInterval(long lastIntervalTime, long now) {
		soilder.attackTime = lastIntervalTime;
		soilder.currentAction = this;
		//search target
		if (currentTarget == null) {
			if (target instanceof BattleItemBuilding) {
				BattleItemBuilding targetBuilding = (BattleItemBuilding) currentTarget;
				currentTarget = targetBuilding.troops.size() > 0 ? targetBuilding.troops.first() : targetBuilding;
			} else {
				throw new Error("");
			}
		}
		currentTarget.hp = Math.max(0, currentTarget.hp - 1);
		if (currentTarget.hp > 0) {
			if (currentTarget instanceof BattleItemSoilder && ((BattleItemSoilder) currentTarget).currentAction == null) {
				TaskAttack attack = new TaskAttack(lastIntervalTime, 1100, (BattleItemSoilder) currentTarget, soilder);
				currentTarget.currentAction = attack;
				attack.updateExecuteTime(lastIntervalTime + attack.interval, battleRoom);
			}
		} else {
			if (currentTarget instanceof BattleItemSoilder) {
				battleRoom.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_REMOVE, currentTarget));
				((BattleItemSoilder) currentTarget).building.troops.remove(currentTarget);
			} else if (currentTarget instanceof BattleItemBuilding) {
				((BattleItemBuilding) currentTarget).owner = soilder.owner;
				battleRoom.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, currentTarget));
			}
			currentTarget = null;
		}
		battleRoom.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, currentTarget));
		return now;
	}
}
