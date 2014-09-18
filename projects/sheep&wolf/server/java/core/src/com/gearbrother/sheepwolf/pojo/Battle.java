package com.gearbrother.sheepwolf.pojo;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;

import com.fasterxml.jackson.databind.JsonNode;
import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanProperty;

/**
 * 
 * @author feng.lee
 * @create on 2013-8-12
 */
@RpcBeanPartTransportable(isPartTransport = true)
public class Battle extends RpcBean {
	static public final int INIT_MONEY = 10;
	
	static public final int INIT_SHEEP_MONEY = (int) (10 * 0.7);
	
	static public final int INIT_WOLF_MONEY = (int) (10 * (1 / .7));
	
	@RpcBeanProperty(desc = "身份唯一ID")
	public String uuid;

	@RpcBeanProperty(desc = "地图配置ID")
	public String confId;

	public Map<String, BattleItemTemplate> templates;
	
	@RpcBeanProperty(desc = "row")
	public int row;

	@RpcBeanProperty(desc = "col")
	public int col;

	@RpcBeanProperty(desc = "")
	public int cellPixel;

	private Map<Double, Map<Double, BattleItem>> collisionItems;
	public void setCollision(double r, double c, BattleItem newValue) {
		if (!collisionItems.containsKey(r)) {
			collisionItems.put(r, new HashMap<Double, BattleItem>());
		}
		collisionItems.get(r).put(c, newValue);
	}
	public BattleItem getCollision(double r, double c) {
		if (collisionItems.containsKey(r))
			return collisionItems.get(r).get(c);
		else
			return null;
	}

	Map<Class<?>, Map<String, BattleItem>> sortItems;
	public Map<String, BattleItem> getItems(Class<?> clazz) {
		return sortItems.get(clazz);
	}

	@RpcBeanProperty(desc = "地图上非碰撞逻辑物体")
	public Map<String, BattleItem> items;

	@RpcBeanProperty(desc = "羊出生地矩阵")
	public Bounds sheepBornBounds;
	
	@RpcBeanProperty(desc = "抓取矩阵")
	public Bounds caughtBounds;

	@RpcBeanProperty(desc = "狼出生地矩阵")
	public Bounds wolfBornBounds;

	@RpcBeanProperty(desc = "游戏开始GMT时间")
	public long startTime;
	
	@RpcBeanProperty(desc = "游戏持续毫秒")
	public long expiredPeriod;

	@RpcBeanProperty(desc = "羊开始时间")
	public long sheepSleepAt;

	@RpcBeanProperty(desc = "狼开始时间")
	public long wolfSleepAt;
	
	@RpcBeanProperty(desc = "白天时间")
	public long dayTime;
	
	@RpcBeanProperty(desc = "晚上时间")
	public long nightTime;

	@RpcBeanProperty(desc = "需要拼合的拼图总数量")
	public int puzzleFinishedTotal;
	
	@RpcBeanProperty(desc = "需要拼合的拼图总数量")
	public int puzzleTotal;
	
	private JsonNode json;

	private Battle() {
	}

	public Battle(JsonNode json) {
		this();

		this.json = json;
		this.row = json.get("row").asInt();
		this.col = json.get("col").asInt();
		this.cellPixel = json.get("cellPixel").asInt();
		this.templates = new HashMap<String, BattleItemTemplate>();
		for (Iterator<Entry<String, JsonNode>> iterator = json.get("template").fields(); iterator.hasNext();) {
			Entry<String, JsonNode> node = (Entry<String, JsonNode>) iterator.next();
			this.templates.put(node.getKey(), new BattleItemTemplate(node.getValue()));
		}
		sheepSleepAt = json.get("sheepSleepAt").asLong();
		wolfSleepAt = json.get("wolfSleepAt").asLong();
		sheepBornBounds = new Bounds(json.get("sheepBornBounds"));
		wolfBornBounds = new Bounds(json.get("wolfBornBounds"));
		caughtBounds = new Bounds(json.get("caughtBounds"));
		this.collisionItems = new HashMap<Double, Map<Double,BattleItem>>();
		this.sortItems = new HashMap<Class<?>, Map<String,BattleItem>>();
		this.items = new HashMap<String, BattleItem>();
		JsonNode itemsNode = json.get("items");
		for (int i = 0; i < itemsNode.size(); i++) {
			new BattleItem(itemsNode.get(i)).setBattle(this);
		}
		this.dayTime = 20 * 1000;
		this.nightTime = 20 * 1000;
		this.expiredPeriod = json.get("expiredPeriod").asInt();
		this.puzzleTotal = json.get("puzzleTotal").asInt();
	}

	public boolean isAllCaptured() {
		boolean isAllCaptured = true;
		int livedColor = -1;
		Map<String, BattleItem> users = sortItems.get(BattleItemUser.class);
		for (Iterator<String> iterator = users.keySet().iterator(); iterator.hasNext();) {
			String userUuid = (String) iterator.next();
			BattleItemUser user = (BattleItemUser) users.get(userUuid);
			if (livedColor == -1) {
				livedColor = user.color;
			} else if (user.lifes == 0 && livedColor != user.color) {
				return false;
			}
		}
		return isAllCaptured;
	}
	
	public Battle clone() {
		return new Battle(json);
	}
}