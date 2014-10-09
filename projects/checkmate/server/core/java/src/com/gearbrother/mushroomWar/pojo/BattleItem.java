package com.gearbrother.mushroomWar.pojo;

import java.util.HashMap;
import java.util.UUID;

import com.fasterxml.jackson.databind.JsonNode;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;

@RpcBeanPartTransportable(isPartTransport = true)
public class BattleItem extends RpcBean {
	@RpcBeanProperty(desc = "uuid")
	public String instanceId;

	protected Battle _battle;

	public Battle getBattle() {
		return _battle;
	}

	public void setBattle(Battle newValue) {
		if (_battle != null) {
			_battle.collisions[_y][_x] = null;
			_battle.sortItems.get(getClass()).remove(instanceId);
			_battle.items.remove(instanceId);
			_battle = null;
		}
		_battle = newValue;
		if (_battle != null) {
			_battle.collisions[_y][_x] = this;
			if (!_battle.sortItems.containsKey(getClass())) {
				_battle.sortItems.put(getClass(), new HashMap<String, BattleItem>());
			}
			_battle.sortItems.get(getClass()).put(instanceId, this);
			_battle.items.put(instanceId, this);
		}
	}

	private int _x;

	@RpcBeanProperty(desc = "")
	public int getX() {
		return _x;
	}

	private int _y;

	@RpcBeanProperty(desc = "") 
	public int getY() {
		return _y;
	}

	public void setXY(int x, int y) {
		if (_battle != null)
			_battle.collisions[_y][_x] = null;
		_x = x;
		_y = y;
		if (_battle != null) {
			if (_battle.collisions[_y][_x] != null)
				throw new Error("position has element");
			_battle.collisions[_y][_x] = this;
		}
	}
	
	public int[][] collision;
	

	@RpcBeanProperty(desc = "")
	public int hp;

	@RpcBeanProperty(desc = "")
	public int maxHp;

	@RpcBeanProperty(desc = "所在动画层")
	public String layer;

	@RpcBeanProperty(desc = "人物动画")
	public String cartoon;

	@RpcBeanProperty(desc = "等级")
	public int level;

	private Task _task;

	@RpcBeanProperty(desc = "当前行为")
	public Task getTask() {
		return _task;
	}

	@RpcBeanProperty(desc = "当前行为")
	public void setTask(Task value) {
		if (this._task != null && this._task.getIsInQueue())
			throw new Error("f");
		this._task = value;
	}

	@RpcBeanProperty(desc = "行为")
	public Object action;

	public BattleRoomSeat owner;

	@RpcBeanProperty(desc = "")
	public String getOwnerId() {
		return owner != null ? owner.user.uuid : null;
	}

	public Object controller;

	public int coin;

	public int attackDamage;

	public int moveRange;

	public BattleItem(JsonNode json) {
		this();

		instanceId = json.get("instanceId").asText();
		setXY(json.get("x").asInt(), json.get("y").asInt());
		cartoon = json.get("cartoon").asText();
		layer = json.get("layer").asText();
		coin = json.get("coin").asInt();
	}

	public BattleItem() {
		instanceId = UUID.randomUUID().toString();
		moveRange = 1;
	}
}
