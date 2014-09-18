package com.gearbrother.sheepwolf.pojo;

import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanProperty;

@RpcBeanPartTransportable
public class BattleSignalReady extends RpcBean {
	@RpcBeanProperty(desc = "准备玩家")
	public BattleItemUser readyUser;
}
