package com.gearbrother.mushroomWar.pojo;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BattleItemSoilderProtocol;

@RpcBeanPartTransportable
public class TaskAttack extends TaskInterval {
	static Logger logger = LoggerFactory.getLogger(TaskAttack.class);

	public BattleItemSoilder behavior;

	public BattleItem searchedTarget;
	
	public BattleItemBuilding field;

	public TaskAttack(Battle battle, long executeTime, long interval, BattleItemSoilder behavior, BattleItem target, BattleItemBuilding field) {
		super(battle, executeTime, interval);

		this.behavior = behavior;
		this.searchedTarget = target;
		this.field = field;
	}

	@Override
	public void execute(long now) {
		logger.debug("{} attack {}", behavior.instanceId, behavior.instanceId);
		behavior.task = this;
		//change hp
		searchedTarget.hp = Math.max(0, searchedTarget.hp - behavior.attackDamage);
		if (searchedTarget.focusTarget == null)
			searchedTarget.focusTarget = behavior;
		//update
		if (searchedTarget.hp > 0) {
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
				new TaskDefense(battle, now + 100, field);
			} else if (searchedTarget instanceof BattleItemBuilding) {
				BattleItemBuilding building = (BattleItemBuilding) searchedTarget;
				building.owner = behavior.owner;
				building.settledTroops.add(behavior);
				battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, searchedTarget));
			}
			behavior.task = null;
		}
		BattleItemSoilderProtocol soilderProto = new BattleItemSoilderProtocol();
		soilderProto.setInstanceId(behavior.instanceId);
		soilderProto.setTask(behavior.task);
		battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, soilderProto));
	}
}
