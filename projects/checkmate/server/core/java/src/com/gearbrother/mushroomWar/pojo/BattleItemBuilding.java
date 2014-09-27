package com.gearbrother.mushroomWar.pojo;

import java.util.Comparator;
import java.util.TreeSet;

import com.fasterxml.jackson.databind.JsonNode;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;

@RpcBeanPartTransportable(isPartTransport = true)
public class BattleItemBuilding extends BattleItem {
	public TaskDispatch dispatch;

	public TaskProduce produce;

	public TaskSkill skillTask;

	public boolean host;

	@RpcBeanProperty(desc = "")
	public TreeSet<BattleItemSoilder> troops;
	
	@RpcBeanProperty(desc = "")
	public Avatar settledHero;

	public BattleItemBuilding() {
		super();

		troops = new TreeSet<BattleItemSoilder>(
				new Comparator<BattleItemSoilder>() {
					
					@Override
					public int compare(BattleItemSoilder o1, BattleItemSoilder o2) {
						return Math.abs(o1.x - x) - Math.abs(o2.x - x);
					}
				}
			);
		this.maxHp = this.hp = 10;
	}

	public BattleItemBuilding(JsonNode json) {
		super(json);

		troops = new TreeSet<BattleItemSoilder>(
				new Comparator<BattleItemSoilder>() {
					
					@Override
					public int compare(BattleItemSoilder o1, BattleItemSoilder o2) {
						return Math.abs(o1.x - x) - Math.abs(o2.x - x);
					}
				}
			);
		this.host = json.has("host") ? json.get("host").booleanValue() : false;
		this.maxHp = this.hp = 10;
	}
}
