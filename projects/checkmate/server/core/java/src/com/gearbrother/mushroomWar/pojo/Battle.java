package com.gearbrother.mushroomWar.pojo;

import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.SortedSet;
import java.util.TreeSet;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.fasterxml.jackson.databind.JsonNode;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;

/**
 * 
 * @author feng.lee
 * @create on 2013-8-12
 */
@RpcBeanPartTransportable(isPartTransport = true)
public class Battle extends RpcBean {
	static Logger logger = LoggerFactory.getLogger(Battle.class);
	
	@RpcBeanProperty(desc = "身份唯一ID")
	public String instanceUuid;

	@RpcBeanProperty(desc = "地图配置ID")
	public String confId;
	
	@RpcBeanProperty(desc = "row")
	public int row;

	@RpcBeanProperty(desc = "col")
	public int col;

	@RpcBeanProperty(desc = "")
	public int cellPixel;

	@RpcBeanProperty(desc = "")
	public Map<String, BattleRoomSeat> users;

	
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
	
	@RpcBeanProperty(desc = "游戏开始GMT时间")
	public long startTime;
	
	@RpcBeanProperty(desc = "游戏持续毫秒")
	public long expiredPeriod;

	public SortedSet<Task> tasks;
	
	public BattleRoom parent;
	
	private JsonNode json;

	public Battle() {
		this.users = new HashMap<String, BattleRoomSeat>();
		this.collisionItems = new HashMap<Double, Map<Double,BattleItem>>();
		this.sortItems = new HashMap<Class<?>, Map<String,BattleItem>>();
		this.items = new HashMap<String, BattleItem>();
		this.tasks = new TreeSet<Task>(
				new Comparator<Task>() {
					
					@Override
					public int compare(Task o1, Task o2) {
						return o1.getNextExecuteTime() > o2.getNextExecuteTime()
								? 1 : (o1.getNextExecuteTime() < o2.getNextExecuteTime() ? -1 : o1.instanceId.compareTo(o2.instanceId));
					}
				}
			);
	}

	public Battle(JsonNode json) {
		this();

		this.json = json;
		this.row = json.get("row").asInt();
		this.col = json.get("col").asInt();
		this.cellPixel = json.get("cellPixel").asInt();
		JsonNode itemsNode = json.get("items");
		for (int i = 0; i < itemsNode.size(); i++) {
			new BattleItemBuilding(itemsNode.get(i)).setBattle(this);
		}
	}

	public boolean isAllCaptured() {
		Object oneOwner = null;
		Map<String, BattleItem> buildings = sortItems.get(BattleItemBuilding.class);
		for (Iterator<String> iterator = buildings.keySet().iterator(); iterator.hasNext();) {
			String userUuid = (String) iterator.next();
			BattleItemBuilding building = (BattleItemBuilding) buildings.get(userUuid);
			if (oneOwner == null || oneOwner == building.owner)
				oneOwner = building.owner;
			else
				return false;
		}
		return true;
	}
	
	public Battle clone() {
		return new Battle(json);
	}

	public void execute(long now) {
		while (tasks.size() > 0) {
			Task head = tasks.first();
			if (now >= head.getNextExecuteTime()) {
				boolean res = tasks.remove(head);
				if (!res)
					throw new Error("remove fail");
//				Task second = queue.size() > 0 ? queue.first() : null;
//				long time = Math.max(now, second != null ? second.nextExecuteTime : 0);
				head.execute(now);
			} else {
				break;
			}
		}
	}
}
