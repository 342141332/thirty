package com.gearbrother.mushroomWar.pojo;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import java.util.TreeSet;
import java.util.UUID;

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

	static public final int STATE_PREPARING = 1;

	static public final int STATE_PLAYING = 2;
	
	@RpcBeanProperty(desc = "身份唯一ID")
	public String instanceUuid;

	@RpcBeanProperty(desc = "名字")
	public String name;

	@RpcBeanProperty(desc = "地图配置ID")
	public String confId;

	@RpcBeanProperty(desc = "游戏持续毫秒")
	public long expiredPeriodMinutes;

	@RpcBeanProperty(desc = "势力")
	public Map<String, BattleForce> forces;
	
	@RpcBeanProperty(desc = "像素宽")
	public int width;
	
	@RpcBeanProperty(desc = "像素高")
	public int height;
	
	@RpcBeanProperty(desc = "背景")
	public String background;
	
	@RpcBeanProperty(desc = "矩阵x初始像素点")
	public int left;

	@RpcBeanProperty(desc = "矩阵y初始像素点")
	public int top;
	
	@RpcBeanProperty(desc = "col")
	public int col;

	@RpcBeanProperty(desc = "row")
	public int row;

	@RpcBeanProperty(desc = "")
	public int cellPixel;

	private Cell[] cells;

	public Collection<BattleItem> getCollision(int[] collisionRect) {
		Set<BattleItem> res = new HashSet<BattleItem>();
		int right = Math.min(col, collisionRect[2]);
		int bottom = Math.min(row, collisionRect[3]);
		for (int left = Math.max(0, collisionRect[0]); left < right; left++) {
			for (int top = Math.max(0, collisionRect[1]); top < bottom; top++) {
				Cell grid = cells[left + top * col];
				if (grid != null)
					res.addAll(grid.items);
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
		if (item.left < 0 || item.left >= col || item.top < 0 || item.top >= row)
			throw new Error("invalid position");

		items.put(item.instanceId, item);
		if (!sortItems.containsKey(item.getClass()))
			sortItems.put(item.getClass(), new HashMap<String, BattleItem>());
		sortItems.get(item.getClass()).put(item.instanceId, item);
		for (int left = item.left; left < item.left + item.width; left++) {
			for (int top = item.top; top < item.top + item.height; top++) {
				Cell grid = cells[left + top * col];
				if (grid != null) {
					for (BattleItem b : grid.items) {
						if (item.isCollision(b))
							throw new Error("collision is already used");
					}
					grid.items.add(item);
				} else {
					grid = cells[left + top * col] = new Cell();
					for (BattleItem b : grid.items) {
						if (item.isCollision(b))
							throw new Error("collision is already used");
					}
					grid.items.add(item);
				}
			}
		}
	}

	public void removeItem(BattleItem item) {
		items.remove(item.instanceId);
		sortItems.get(item.getClass()).remove(item.instanceId);
		for (int left = 0; left < item.width; left++) {
			for (int top = 0; top < item.height; top++) {
				Cell grid = cells[item.left + item.top * col];
				if (!grid.items.remove(item))
					throw new Error();
			}
		}
	}

	public boolean moveItem(BattleItem item, int newLeft, int newTop) {
		if (newLeft < 0 || newLeft + item.width > col || newTop < 0 || newTop + item.height > row)
			return false;

		for (int oldLeft = item.left; oldLeft < item.left + item.width; oldLeft++) {
			for (int oldTop = item.top; oldTop < item.top + item.height; oldTop++) {
				if (!cells[oldLeft + oldTop * col].items.contains(item)) {
					throw new Error();
				}
			}
		}
		for (int left = newLeft; left < newLeft + item.width; left++) {
			for (int top = newTop; top < newTop + item.height; top++) {
				if (cells[left + top * col] != null) {
					for (BattleItem b : cells[left + top * col].items) {
						if (item.isCollision(b))
							return false;
					}
				}
			}
		}
		for (int oldLeft = item.left; oldLeft < item.left + item.width; oldLeft++) {
			for (int oldTop = item.top; oldTop < item.top + item.height; oldTop++) {
				cells[oldLeft + oldTop * col].items.remove(item);
			}
		}
		for (int left = newLeft; left < newLeft + item.width; left++) {
			for (int top = newTop; top < newTop + item.height; top++) {
				Cell grid = cells[left + top * col];
				if (grid == null)
					grid = cells[left + top * col] = new Cell();
				grid.items.add(item);
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

	final public SessionObserver observer;

	private JsonNode json;

	public Battle(JsonNode json) {
		this.json = json;
		this.sortItems = new HashMap<Class<?>, Map<String, BattleItem>>();
		this.items = new HashMap<String, BattleItem>();
		this.state = STATE_PREPARING;
		JsonNode forcesNode = json.get("force");
		this.forces = new HashMap<String, BattleForce>();
		for (Iterator<Entry<String, JsonNode>> iterator = forcesNode.fields(); iterator.hasNext();) {
			Entry<String, JsonNode> entry = (Entry<String, JsonNode>) iterator.next();
			BattleForce force = new BattleForce(entry.getValue());
			force.id = entry.getKey();
			this.forces.put(force.id, force);
		}
		this.width = json.get("width").asInt();
		this.height = json.get("height").asInt();
		this.background = json.get("background").asText();
		this.left = json.get("left").asInt();
		this.top = json.get("top").asInt();
		this.cellPixel = json.get("cellPixel").asInt();
		this.col = json.get("col").asInt();
		this.row = json.get("row").asInt();
		this.cells = new Cell[col * row];
		JsonNode itemsNode = json.get("items");
		for (int i = 0; i < itemsNode.size(); i++) {
			JsonNode itemNode = itemsNode.get(i);
			BattleItem item = new BattleItem(itemNode);
			item.instanceId = UUID.randomUUID().toString();
			item.force = forces.get(itemNode.get("force").asText());
			addItem(item);
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
		observer = new SessionObserver();
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
class Cell {
	public List<BattleItem> items;

	public Cell() {
		items = new ArrayList<BattleItem>();
	}
}