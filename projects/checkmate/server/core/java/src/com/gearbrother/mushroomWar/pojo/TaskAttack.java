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

	public BattleItem target;
	@RpcBeanProperty(desc = "")
	public String getTargetId() {
		return target.instanceId;
	}
	
	public BattleItemBuilding field;

	public TaskAttack(Battle battle, long executeTime, long interval
			, BattleItemSoilder behavior, BattleItem target, BattleItemBuilding field) {
		super(battle, executeTime, interval);

		this.behavior = behavior;
		this.target = target;
		this.field = field;
	}

	@Override
	public void execute(long now) {
		logger.debug("{} attack {}", behavior.instanceId, behavior.instanceId);
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
