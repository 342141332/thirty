package com.gearbrother.mushroomWar.pojo;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;

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
}
