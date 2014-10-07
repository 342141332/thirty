package com.gearbrother.mushroomWar.pojo;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;
import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BattleItemProtocol;

@RpcBeanPartTransportable
public class TaskAttack extends RpcBean {
	static Logger logger = LoggerFactory.getLogger(TaskAttack.class);
	
	public BattleItem behavior;

	public BattleItem target;
	@RpcBeanProperty(desc = "")
	public String getTargetId() {
		return target.instanceId;
	}
	
	public TaskAttack(BattleItem behavior, BattleItem target) {
		this.behavior = behavior;
		this.target = target;
	}

	public void execute() {
		logger.debug("{} attack", behavior.instanceId);
		target = null;
		BattleItemProtocol soilderProto = new BattleItemProtocol();
		soilderProto.setInstanceId(behavior.instanceId);

		//change hp
		target.hp = Math.max(0, target.hp - behavior.attackDamage);
		//update
		BattleItemProtocol currentTargetProto = new BattleItemProtocol();
		currentTargetProto.setInstanceId(target.instanceId);
		if (target.hp > 0) {
			currentTargetProto.setHp(target.hp);
		} else {
			if (target.getTask() != null) {
				target.getTask().halt();
			}
			target.setBattle(null);
		}
	}
}
