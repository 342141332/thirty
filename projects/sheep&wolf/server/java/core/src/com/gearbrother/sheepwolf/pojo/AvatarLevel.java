package com.gearbrother.sheepwolf.pojo;

import com.fasterxml.jackson.databind.JsonNode;
import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanProperty;

/**
 * @author feng.lee
 * @create on 2014-3-6
 */
@RpcBeanPartTransportable
public class AvatarLevel extends RpcBean {
	@RpcBeanProperty(desc = "等级")
	public int id;

	@RpcBeanProperty(desc = "")
	public int exp;
	
	@RpcBeanProperty(desc = "")
	public int hp;
	
	@RpcBeanProperty(desc = "")
	public int armor;
	
	@RpcBeanProperty(desc = "")
	public double move;

	public AvatarLevel(JsonNode node) {
		exp = node.get("exp").asInt();
		hp = node.get("hp").asInt();
		move = node.get("move").asDouble();
	}
}
