package com.gearbrother.mushroomWar.pojo;

import com.fasterxml.jackson.databind.JsonNode;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;

/**
 * @author feng.lee
 * @create on 2014-3-6
 */
@RpcBeanPartTransportable
public class CharacterLevel extends RpcBean {
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

	public CharacterLevel() {
	}
	
	public CharacterLevel(JsonNode node) {
		exp = node.get("exp").asInt();
		hp = node.get("hp").asInt();
		move = node.get("move").asDouble();
	}
}
