package com.gearbrother.sheepwolf.pojo;

import com.fasterxml.jackson.databind.JsonNode;
import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanProperty;

/**
 * @author feng.lee
 * @create on 2013-11-25
 */
@RpcBeanPartTransportable
public class SkillLevel extends RpcBean {
	@RpcBeanProperty(desc = "等级")
	public int id;

	@RpcBeanProperty(desc = "经验")
	public int exp;

	@RpcBeanProperty(desc = "施法前摇")
	public long preUseCause;

	@RpcBeanProperty(desc = "cooldown时间")
	public long cooldown;

	@RpcBeanProperty(desc = "使用需要等级")
	public int requireLevel;

	public String remoteMethod;

	public JsonNode remoteMethodParams;

	public SkillLevel() {
	}

	public SkillLevel(JsonNode node) {
		this.preUseCause = node.get("preUseCause").asLong();
		this.cooldown = node.get("cooldown").asLong();
		this.exp = node.get("exp").asInt();
		this.requireLevel = node.get("requireLevel").asInt();
		this.remoteMethod = node.get("remoteMethod").asText();
		this.remoteMethodParams = node.get("remoteMethodParams");
	}
}
