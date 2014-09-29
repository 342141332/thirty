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
	public int height;

	@RpcBeanProperty(desc = "col")
	public int width;

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

	public SortedSet<Task> taskQueue;

	public SessionObserver observer;
	
	private JsonNode json;

	public Battle() {
		this.sortItems = new HashMap<Class<?>, Map<String,BattleItem>>();
		this.items = new HashMap<String, BattleItem>();
	}

	public Battle(JsonNode json) {
		this();

		this.json = json;
		this.width = json.get("width").asInt();
		this.height = json.get("height").asInt();
		this.taskQueue = new TreeSet<Task>(
				new Comparator<Task>() {
					
					@Override
					public int compare(Task o1, Task o2) {
						long offset = o1.getExecuteTime() - o2.getExecuteTime();
						if (offset > 0)
							return 1;
						else if (offset < 0)
							return -1;
						else
							return o1.instanceId.compareTo(o2.instanceId);
					}
				}
			);
		JsonNode itemsNode = json.get("items");
		for (int i = 0; i < itemsNode.size(); i++) {
			BattleItemBuilding battleItemBuilding = new BattleItemBuilding(itemsNode.get(i));
			battleItemBuilding.setBattle(this);
		}
	}

	public void execute(long now) {
		while (taskQueue.size() > 0) {
			Task head = taskQueue.first();
			if (now >= head.getExecuteTime()) {
				boolean res = taskQueue.remove(head);
				if (!res)
					throw new Error("remove fail");
				head.execute(now);
			} else {
				break;
			}
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
}
