package com.gearbrother.mushroomWar.pojo;

import java.util.Comparator;
import java.util.HashMap;
import java.util.Map;
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

	static public final int STATE_NONE = 0;
	
	static public final int STATE_PREPARING = 1;
	
	static public final int STATE_PLAYING = 2;
	
	@RpcBeanProperty(desc = "身份唯一ID")
	public String instanceUuid;

	@RpcBeanProperty(desc = "地图配置ID")
	public String confId;

	@RpcBeanProperty(desc = "row")
	public int height;

	@RpcBeanProperty(desc = "col")
	public int width;

	@RpcBeanProperty(desc = "")
	public int cellPixel;

	public BattleItem[][] collisions;

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
	
	public int state;

	public TreeSet<Task> taskQueue;

	public SessionObserver observer;

	private JsonNode json;

	public Battle() {
		this.sortItems = new HashMap<Class<?>, Map<String, BattleItem>>();
		this.items = new HashMap<String, BattleItem>();
	}

	public Battle(JsonNode json) {
		this();

		this.json = json;
		this.width = json.get("width").asInt();
		this.height = json.get("height").asInt();
		this.cellPixel = json.get("cellPixel").asInt();
		this.collisions = new BattleItem[height][width];
		for (int r = 0; r < height; r++) {
			this.collisions[r] = new BattleItem[width];
		}
		this.taskQueue = new TreeSet<Task>(new Comparator<Task>() {

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
		});
		JsonNode itemsNode = json.get("items");
		for (int i = 0; i < itemsNode.size(); i++) {
			BattleItem battleItemBuilding = new BattleItem(itemsNode.get(i));
			battleItemBuilding.setBattle(this);
		}
	}

	public void execute(long now) {
		while (taskQueue.size() > 0) {
			Task task = taskQueue.first();
			if (now >= task.getExecuteTime()) {
				Task polledFirst = taskQueue.pollFirst();
				if (polledFirst != task)
					throw new Error("polledFirst != task");
				task.setIsInQueue(false);
				task.execute(now);
			} else {
				break;
			}
		}
	}

	public Battle clone() {
		return new Battle(json);
	}
}
