package com.gearbrother.mushroomWar.pojo;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;

@RpcBeanPartTransportable
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
		ArrayNode bornNode = (ArrayNode) jsonNode.get("born");
		born = new int[bornNode.size()];
		for (int i = 0; i < bornNode.size(); i++) {
			born[i] = bornNode.get(i).asInt();
		}
		ArrayNode forwardNode = (ArrayNode) jsonNode.get("forward");
		forward = new int[forwardNode.size()];
		for (int i = 0; i < forwardNode.size(); i++) {
			forward[i] = forwardNode.get(i).asInt();
		}
		ArrayNode borderNode = (ArrayNode) jsonNode.get("border");
		border = new int[borderNode.size()];
		for (int i = 0; i < borderNode.size(); i++) {
			border[i] = borderNode.get(i).asInt();
		}
	}
}
