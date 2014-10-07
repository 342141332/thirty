package com.gearbrother.mushroomWar.pojo;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import com.fasterxml.jackson.databind.JsonNode;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;

@RpcBeanPartTransportable(isPartTransport = true)
public class BattleItemBuilding extends BattleItem {
	public boolean host;

	public String character;

	@RpcBeanProperty(desc = "")
	public Avatar settledHero;

	public TaskProduce produce;

	public TaskDefense defense;

	public Set<BattleItemSoilder> restingSoilders;

	public List<BattleField> fields;

	public BattleItemBuilding() {
		super();

		this.maxHp = this.hp = 10;
		this.character = "static/kingdomrush/7207.swf";
		this.restingSoilders = new HashSet<BattleItemSoilder>();
		this.fields = new ArrayList<BattleItemBuilding.BattleField>();
	}

	public BattleItemBuilding(JsonNode json) {
		super(json);

		this.maxHp = this.hp = 10;
		this.character = "static/kingdomrush/7207.swf";
		this.host = json.has("host") ? json.get("host").booleanValue() : false;
		this.restingSoilders = new HashSet<BattleItemSoilder>();
		this.fields = new ArrayList<BattleItemBuilding.BattleField>();
	}

	static class BattleField {
		public int x;

		public int y;

		public BattleItemBuilding building;

		public List<BattleItemSoilder> soilders;
		
		public BattleField(int x, int y, BattleItemBuilding building) {
			this.x = x;
			this.y = y;
			this.building = building;
			this.soilders = new ArrayList<BattleItemSoilder>();
		}
	}
}
