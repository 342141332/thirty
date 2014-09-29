package com.gearbrother.mushroomWar.pojo;

import java.util.HashSet;
import java.util.Set;

import com.fasterxml.jackson.databind.JsonNode;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;

@RpcBeanPartTransportable(isPartTransport = true)
public class BattleItemBuilding extends BattleItem {
	public TaskProduce produce;

	public TaskDefense defense;

	public boolean host;

	public Set<BattleItemSoilder> settledTroops;

	@RpcBeanProperty(desc = "")
	public Avatar settledHero;
	
	public String character;

	public BattleItemBuilding() {
		super();

		settledTroops = new HashSet<BattleItemSoilder>();
		this.maxHp = this.hp = 10;
		this.character = "static/kingdomrush/7207.swf";
	}

	public BattleItemBuilding(JsonNode json) {
		super(json);

		settledTroops = new HashSet<BattleItemSoilder>();
		this.host = json.has("host") ? json.get("host").booleanValue() : false;
		this.maxHp = this.hp = 10;
		this.character = "static/kingdomrush/7207.swf";
	}
}
