package com.gearbrother.mushroomWar.pojo;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeSet;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ArrayNode;
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

	@RpcBeanProperty(desc = "游戏持续毫秒")
	public long expiredPeriodMinutes;
	
	@RpcBeanProperty(desc = "势力")
	public BattleForce[] forces;

	@RpcBeanProperty(desc = "col")
	public int col;

	@RpcBeanProperty(desc = "row")
	public int row;

	@RpcBeanProperty(desc = "")
	public int cellPixel;
	
	public BattleItem[][] collisions;
	public List<BattleItem> getCollision(int[] collisionRect) {
		List<BattleItem> res = new ArrayList<BattleItem>();
		for (int left = collisionRect[0]; left < collisionRect[2]; left++) {
			for (int top = collisionRect[1]; top < collisionRect[3]; top++) {
				if (collisions[left][top] != null)
					res.add(collisions[left][top]);
			}
		}
		return res;
	}

	Map<Class<?>, Map<String, BattleItem>> sortItems;

	public Map<String, BattleItem> getItems(Class<?> clazz) {
		return sortItems.get(clazz);
	}

	@RpcBeanProperty(desc = "地图上非碰撞逻辑物体")
	public Map<String, BattleItem> items;
	public void addItem(BattleItem item) {
		items.put(item.instanceId, item);
		if (!sortItems.containsKey(item.getClass()))
			sortItems.put(item.getClass(), new HashMap<String, BattleItem>());
		sortItems.get(item.getClass()).put(item.instanceId, item);
		for (int left = item.left; left < item.left + item.collisionRect[0]; left++) {
			for (int top = item.top; top < item.top + item.collisionRect[1]; top++) {
				if (collisions[left][top] != null)
					throw new Error("collision is already used");
				collisions[left][top] = item;
			}
		}
	}
	public void removeItem(BattleItem item) {
		items.remove(item.instanceId);
		sortItems.get(item.getClass()).remove(item.instanceId);
		for (int left = 0; left < item.collisionRect[1]; left++) {
			for (int top = 0; top < item.collisionRect[0]; top++) {
				collisions[item.left + left][item.top + top] = null;
			}
		}
	}
	public boolean moveItem(BattleItem item, int newLeft, int newTop) {
		for (int oldLeft = item.left; oldLeft < item.left + item.collisionRect[0]; oldLeft++) {
			for (int oldTop = item.top; oldTop < item.top + item.collisionRect[1]; oldTop++) {
				if (collisions[oldLeft][oldTop] == item) {
				} else {
					throw new Error();
				}
			}
		}
		for (int left = newLeft; left < newLeft + item.collisionRect[0]; left++) {
			for (int top = newTop; top < newTop + item.collisionRect[1]; top++) {
				if (collisions[left][top] != null) {
					return false;
				}
			}
		}
		for (int oldLeft = item.left; oldLeft < item.left + item.collisionRect[0]; oldLeft++) {
			for (int oldTop = item.top; oldTop < item.top + item.collisionRect[1]; oldTop++) {
				if (collisions[oldLeft][oldTop] == item) {
					collisions[oldLeft][oldTop] = null;
				}
			}
		}
		for (int left = newLeft; left < newLeft + item.collisionRect[0]; left++) {
			for (int top = newTop; top < newTop + item.collisionRect[1]; top++) {
				if (collisions[left][top] == null) {
					collisions[left][top] = item;
				}
			}
		}
		item.left = newLeft;
		item.top = newTop;
		return true;
	}

	@RpcBeanProperty(desc = "游戏开始GMT时间")
	public long startTime;

	public int state;

	public TreeSet<Task> tasks;

	public SessionObserver observer;

	private JsonNode json;

	public Battle() {
		this.sortItems = new HashMap<Class<?>, Map<String, BattleItem>>();
		this.items = new HashMap<String, BattleItem>();
	}

	public Battle(JsonNode json) {
		this();

		this.json = json;
		ArrayNode forcesNode = (ArrayNode) json.get("force");
		this.forces = new BattleForce[forcesNode.size()];
		for (int i = 0; i < forcesNode.size(); i++) {
			this.forces[i] = new BattleForce(forcesNode.get(i));
		}
		this.cellPixel = json.get("cellPixel").asInt();
		this.col = json.get("col").asInt();
		this.row = json.get("row").asInt();
		this.collisions = new BattleItem[col][row];
		for (int c = 0; c < collisions.length; c++) {
			this.collisions[c] = new BattleItem[row];
		}
		JsonNode itemsNode = json.get("items");
		for (int i = 0; i < itemsNode.size(); i++) {
			addItem(new BattleItem(itemsNode.get(i)));
		}
		this.tasks = new TreeSet<Task>(new Comparator<Task>() {

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
	}

	public void execute(long now) {
		while (tasks.size() > 0) {
			Task task = tasks.first();
			if (now >= task.getExecuteTime()) {
				Task polledFirst = tasks.pollFirst();
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
