package com.gearbrother.sheepwolf.pojo;

import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanProperty;
import com.gearbrother.sheepwolf.rpc.protocol.bussiness.BattleProtocol;

@RpcBeanPartTransportable
public class BattleSignalUpdate extends BattleSignal {
	public BattleSignalUpdate(BattleProtocol battleProto) {
		this.battle = battleProto;
	}

	@RpcBeanProperty(desc = "")
	public Object battle;
}
