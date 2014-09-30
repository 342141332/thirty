package com.gearbrother.mushroomWar.pojo;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;
import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BattleItemSoilderProtocol;

@RpcBeanPartTransportable
public class TaskAttack extends TaskInterval {
	static Logger logger = LoggerFactory.getLogger(TaskAttack.class);

	public BattleItemSoilder behavior;

<<<<<<< HEAD
	public BattleItem target;
	@RpcBeanProperty(desc = "")
	public String getTargetId() {
		return target.instanceId;
	}
=======
	public BattleItem searchedTarget;
>>>>>>> branch 'master' of https://github.com/342141332/thirty.git
	
	public BattleItemBuilding field;

<<<<<<< HEAD
	public TaskAttack(Battle battle, long executeTime, long interval
			, BattleItemSoilder behavior, BattleItem target, BattleItemBuilding field) {
=======
	public TaskAttack(Battle battle, long executeTime, long interval, BattleItemSoilder behavior, BattleItem target, BattleItemBuilding field) {
>>>>>>> branch 'master' of https://github.com/342141332/thirty.git
		super(battle, executeTime, interval);

		this.behavior = behavior;
<<<<<<< HEAD
		this.target = target;
=======
		this.searchedTarget = target;
>>>>>>> branch 'master' of https://github.com/342141332/thirty.git
		this.field = field;
	}

	@Override
	public void execute(long now) {
		logger.debug("{} attack {}", behavior.instanceId, behavior.instanceId);
<<<<<<< HEAD
=======
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
>>>>>>> branch 'master' of https://github.com/342141332/thirty.git
		BattleItemSoilderProtocol soilderProto = new BattleItemSoilderProtocol();
		soilderProto.setInstanceId(behavior.instanceId);
		soilderProto.setTask(this);
		battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, soilderProto, "soilderProto.setTask(this);"));
		
		//change hp
		target.hp = Math.max(0, target.hp - behavior.attackDamage);
		if (target.focusTarget == null)
			target.focusTarget = behavior;
		//update
		if (target.hp > 0) {
			BattleItemSoilderProtocol currentTargetProto = new BattleItemSoilderProtocol();
			currentTargetProto.setInstanceId(target.instanceId);
			currentTargetProto.setHp(target.hp);
			battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, currentTargetProto, "target.hp > 0"));
			setExecuteTime(now + interval);
		} else {
			if (target instanceof BattleItemSoilder) {
				if (target.getTask() != null) {
					target.getTask().halt();
					target.setTask(null);
				}
				if (field.settledTroops.remove(target)) {
					battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_REMOVE, target));
				}
				if (field.defense == null)
					new TaskDefense(battle, now + 100, field);
			} else if (target instanceof BattleItemBuilding) {
				BattleItemBuilding building = (BattleItemBuilding) target;
				building.owner = behavior.owner;
				battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, target));
			}
			behavior.setTask(null);
		}
	}
}
