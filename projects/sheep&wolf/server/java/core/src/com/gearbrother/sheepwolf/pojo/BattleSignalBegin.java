package com.gearbrother.sheepwolf.pojo;

import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanProperty;

@RpcBeanPartTransportable
public class BattleSignalBegin extends RpcBean {
	@RpcBeanProperty(desc = "战斗")
	public Battle battle;
}
