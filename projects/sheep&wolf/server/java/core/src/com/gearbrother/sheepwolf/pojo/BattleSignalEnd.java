package com.gearbrother.sheepwolf.pojo;

import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanProperty;

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
