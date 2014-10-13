package com.gearbrother.sheepwolf.pojo;

import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanProperty;

/**
 * @author feng.lee
 * @create on 2013-8-22
 */
@RpcBeanPartTransportable
public class BattleSignalAttack extends BattleSignal {
	@RpcBeanProperty(desc = "")
	public String userUuid;
	
	@RpcBeanProperty(desc = "")
	public double col;
	
	@RpcBeanProperty(desc = "")
	public double row;
}
