package com.gearbrother.mushroomWar.pojo;

import com.fasterxml.jackson.databind.JsonNode;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;

public class BattleForce extends RpcBean {
	@RpcBeanProperty(desc = "支持玩家数量")
	public int maxPlayer;

	@RpcBeanProperty(desc = "出生范围")
	public int[] born;

	@RpcBeanProperty(desc = "攻击方向")
	public int[] forward;

	@RpcBeanProperty(desc = "边界")
	public int[] border;

	public BattleForce(JsonNode jsonNode) {
		this.maxPlayer = jsonNode.get("maxPlayer").asInt();
	}
}
