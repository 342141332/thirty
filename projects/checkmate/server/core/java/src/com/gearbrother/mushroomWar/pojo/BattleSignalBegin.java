package com.gearbrother.mushroomWar.pojo;

import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;

@RpcBeanPartTransportable
public class BattleSignalBegin extends RpcBean {
	@RpcBeanProperty(desc = "战斗")
	public Battle battle;

	public BattleSignalBegin(Battle battle) {
		this.battle = battle;
	}
}
