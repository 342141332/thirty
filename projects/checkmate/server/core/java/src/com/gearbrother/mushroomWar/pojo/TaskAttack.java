package com.gearbrother.mushroomWar.pojo;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BattleItemSoilderProtocol;

@RpcBeanPartTransportable
public class TaskAttack extends TaskInterval {
	static Logger logger = LoggerFactory.getLogger(TaskAttack.class);

	public BattleItemSoilder behavior;

	public BattleItemBuilding field;

	public BattleItem searchedTarget;

	public TaskAttack(Battle battle, long executeTime, long interval, BattleItemSoilder behavior, BattleItemBuilding field) {
		super(battle, executeTime, interval);

		this.behavior = behavior;
		this.field = field;
	}

	@Override
	public void execute(long now) {
		logger.debug("{} attack {}", behavior.instanceId, field.instanceId);
		behavior.task = this;
		//search target
		if (searchedTarget == null || searchedTarget.hp == 0) {
			searchedTarget = field;
			if (behavior.tryAttackTarget != null && behavior.tryAttackTarget.hp > 0) {
				searchedTarget = behavior.tryAttackTarget;
			} else {
				for (BattleItemSoilder troop : field.settledTroops) {
					if (troop.owner != behavior.owner) {
						searchedTarget = troop;
						break;
					}
				}
			}
		}
		//change hp
		searchedTarget.hp = Math.max(0, searchedTarget.hp - behavior.attackDamage);
		searchedTarget.tryAttackTarget = behavior;
		//update
		if (searchedTarget.hp > 0) {
			if (searchedTarget instanceof BattleItemSoilder && ((BattleItemSoilder) searchedTarget).task == null) {
				TaskAttack attack = new TaskAttack(battle, now + 700, 2700, (BattleItemSoilder) searchedTarget, field);
				searchedTarget.task = attack;
			}
			setExecuteTime(now + interval);
			BattleItemSoilderProtocol currentTargetProto = new BattleItemSoilderProtocol();
			currentTargetProto.setInstanceId(searchedTarget.instanceId);
			currentTargetProto.setHp(searchedTarget.hp);
			battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, currentTargetProto));
		} else {
			if (searchedTarget instanceof BattleItemSoilder) {
				field.settledTroops.remove(searchedTarget);
				if (searchedTarget.task != null) {
					searchedTarget.task.halt();
					searchedTarget.task = null;
				}
				battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_REMOVE, searchedTarget));
			} else if (searchedTarget instanceof BattleItemBuilding) {
				BattleItemBuilding building = (BattleItemBuilding) searchedTarget;
				building.owner = behavior.owner;
				building.settledTroops.add(behavior);
				battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, searchedTarget));
			}
			searchedTarget = null;
		}
		BattleItemSoilderProtocol soilderProto = new BattleItemSoilderProtocol();
		soilderProto.setInstanceId(behavior.instanceId);
		soilderProto.setTask(behavior.task);
		battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, soilderProto));
	}
}
