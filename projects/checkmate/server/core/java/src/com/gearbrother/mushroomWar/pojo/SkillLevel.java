package com.gearbrother.mushroomWar.pojo;

import com.fasterxml.jackson.databind.JsonNode;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;

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

	@RpcBeanProperty(desc = "cooldown时间")
	public long cooldown;

	@RpcBeanProperty(desc = "使用需要等级")
	public int requireLevel;

	public String remoteMethod;

	public JsonNode remoteMethodParams;

	public SkillLevel() {
	}

	public SkillLevel(JsonNode node) {
		this.cooldown = node.get("cooldown").asLong();
		this.exp = node.get("exp").asInt();
		this.requireLevel = node.get("requireLevel").asInt();
		this.remoteMethod = node.get("remoteMethod").asText();
		this.remoteMethodParams = node.get("remoteMethodParams");
	}
}
