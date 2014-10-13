package com.gearbrother.mushroomWar.pojo;

import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;

/**
 * @author feng.lee
 * @create on 2014-3-26
 */
@RpcBeanPartTransportable
public class BattleSignalMethodDo extends RpcBean {
	@RpcBeanProperty(desc = "方法名")
	public String method;

	@RpcBeanProperty(desc = "方法参数")
	public String argusJson;
}
