package com.gearbrother.sheepwolf.pojo;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanProperty;

/**
 * @author feng.lee
 * @create on 2013-11-26
 */
@RpcBeanPartTransportable
public class Application extends RpcBean {
	@RpcBeanProperty(desc = "服务器同步给的游戏时间，以毫秒为单位")
	@JsonProperty
	public long syntime;
}
