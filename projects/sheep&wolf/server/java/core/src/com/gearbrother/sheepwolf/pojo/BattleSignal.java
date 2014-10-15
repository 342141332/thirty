package com.gearbrother.sheepwolf.pojo;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanProperty;

/**
 * @author feng.lee
 * @create on 2013-12-31
 */
public class BattleSignal extends RpcBean {
	@RpcBeanProperty(desc = "开始时间")
	@JsonProperty
	public long time;

	public BattleSignal() {
	}
}
