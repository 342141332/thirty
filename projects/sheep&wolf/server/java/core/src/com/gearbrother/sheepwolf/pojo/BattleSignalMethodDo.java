package com.gearbrother.sheepwolf.pojo;

import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanProperty;

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
