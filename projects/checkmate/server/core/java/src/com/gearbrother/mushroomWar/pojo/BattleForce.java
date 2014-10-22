package com.gearbrother.mushroomWar.pojo;

import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.databind.JsonNode;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;

@RpcBeanPartTransportable(isPartTransport = true)
public class BattleForce extends RpcBean {
	@RpcBeanProperty(desc = "")
	public String id;

	@RpcBeanProperty(desc = "支持玩家数量")
	public int maxPlayer;

	@RpcBeanProperty(desc = "攻击方向")
	public int forward;

	@RpcBeanProperty(desc = "边界")
	public int border;

	@RpcBeanProperty(desc = "")
	final public List<BattlePlayer> players;

	@RpcBeanProperty(desc = "城防")
	public int hp;

	@RpcBeanProperty(desc = "")
	public int maxHp;

	public BattleForce(JsonNode jsonNode) {
		this.maxPlayer = jsonNode.get("maxPlayer").asInt();
		this.forward = jsonNode.get("forward").asInt();
		this.border = jsonNode.get("border").asInt();
		this.players = new ArrayList<BattlePlayer>();
	}
}
