package com.gearbrother.mushroomWar.pojo;

import java.util.HashMap;
import java.util.Map;

import com.fasterxml.jackson.databind.JsonNode;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;

@RpcBeanPartTransportable(isPartTransport = true)
public class BattleItemBuilding extends BattleItem {
	public TaskTroopDispatch dispatch;

	public TaskProduce produce;
	
	public TaskSkill skillTask;
	
	public boolean host;
	
	@RpcBeanProperty(desc = "")
	public long fightTime;

	@RpcBeanProperty(desc = "")
	public Map<String, Integer> troops;
	
	@RpcBeanProperty(desc = "")
	public Avatar settledHero;

	public BattleItemBuilding() {
		super();

		troops = new HashMap<String, Integer>();
	}

	public BattleItemBuilding(JsonNode json) {
		super(json);

		troops = new HashMap<String, Integer>();
		this.host = json.has("host") ? json.get("host").booleanValue() : false;
	}
}
