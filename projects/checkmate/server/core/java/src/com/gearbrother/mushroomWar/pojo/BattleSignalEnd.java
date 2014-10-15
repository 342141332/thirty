package com.gearbrother.mushroomWar.pojo;

import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;

/**
 * @author feng.lee
 * @create on 2014-6-18
 */
@RpcBeanPartTransportable
public class BattleSignalEnd extends RpcBean {
	@RpcBeanProperty(desc = "")
	public String message;
	
	public BattleSignalEnd(String message) {
		super();
		
		this.message = message;
	}
}
