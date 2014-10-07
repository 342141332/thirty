package com.gearbrother.mushroomWar.pojo;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.gearbrother.mushroomWar.pojo.BattleItemBuilding.BattleField;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;
import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BattleItemSoilderProtocol;
import com.gearbrother.mushroomWar.util.GMathUtil;

@RpcBeanPartTransportable
public class TaskAttack extends TaskInterval {
	static Logger logger = LoggerFactory.getLogger(TaskAttack.class);
	
	public BattleItemSoilder behavior;

	public BattleItemSoilder target;
	@RpcBeanProperty(desc = "")
	public String getTargetId() {
		return target.instanceId;
	}
	
	public final static Map<String, BattleItemSoilder> deads = new HashMap<String, BattleItemSoilder>();
	
	public TaskAttack(Battle battle, long executeTime, long interval, BattleItemSoilder behavior) {
		super(battle, executeTime, interval);

		this.behavior = behavior;
	}

	@Override
	public void execute(long now) {
		if (TaskAttack.deads.containsKey(behavior.instanceId))
			throw new Error("f");
		logger.debug("{} attack", behavior.instanceId);
		BattleField inField = behavior.inField;
		List<BattleItemSoilder> targetGroup = new ArrayList<BattleItemSoilder>();
		List<BattleItemSoilder> myGroup = new ArrayList<BattleItemSoilder>();
		for (BattleItemSoilder soilder : inField.soilders) {
			if (soilder.owner == behavior.owner)
				myGroup.add(soilder);
			else
				targetGroup.add(soilder);
		}
		target = null;
		if (targetGroup.size() > 0) {
			target = (BattleItemSoilder) GMathUtil.random(targetGroup);
			BattleItemSoilderProtocol soilderProto = new BattleItemSoilderProtocol();
			soilderProto.setInstanceId(behavior.instanceId);
			soilderProto.setTask(this);
			battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, soilderProto, "soilderProto.setTask(this);"));

			//change hp
			target.hp = Math.max(0, target.hp - behavior.attackDamage);
			//update
			BattleItemSoilderProtocol currentTargetProto = new BattleItemSoilderProtocol();
			currentTargetProto.setInstanceId(target.instanceId);
			if (target.hp > 0) {
				currentTargetProto.setHp(target.hp);
				battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, currentTargetProto, "target.hp > 0"));
			} else {
				if (target.getTask() != null) {
					target.getTask().halt();
				}
				inField.soilders.remove(target);
				target.setBattle(null);
				battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_REMOVE, currentTargetProto, "target.hp > 0"));
				deads.put(target.instanceId, target);
			}
			setExecuteTime(now + interval);
		} else {
			if (inField.building.defense == null)
				inField.building.defense = new TaskDefense(battle, now + 100, behavior.inField.building);
			else if (!inField.building.defense.getIsInQueue())
				inField.building.defense.setExecuteTime(now + 100);
		}
	}
}
