package com.gearbrother.sheepwolf.pojo;

import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanProperty;

/**
 * @author feng.lee
 * @create on 2014-6-16
 */
@RpcBeanPartTransportable
public class BattleBuff extends RpcBean {
	static public final String INVISIBLE = "invisible";
	
	@RpcBeanProperty(desc = "key")
	public String key;
	
	@RpcBeanProperty(desc = "过期时间")
	public long expiredPeriod;
	
	public BattleBuff(String key, long outTime) {
		this.key = key;
		this.expiredPeriod = outTime;
	}
}
