package com.gearbrother.mushroomWar.pojo;

import java.util.HashMap;
import java.util.UUID;

import com.fasterxml.jackson.databind.JsonNode;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;

@RpcBeanPartTransportable
public class BattleItem extends RpcBean {
	@RpcBeanProperty(desc = "uuid")
	public String instanceId;

	protected Battle _battle;

	public Battle getBattle() {
		return _battle;
	}

	public void setBattle(Battle newValue) {
		if (_battle != null) {
			_battle.sortItems.get(getClass()).remove(instanceId);
			_battle.items.remove(instanceId);
			_battle = null;
		}
		_battle = newValue;
		if (_battle != null) {
			if (!_battle.sortItems.containsKey(getClass())) {
				_battle.sortItems.put(getClass(),
						new HashMap<String, BattleItem>());
			}
			_battle.sortItems.get(getClass()).put(instanceId, this);
			_battle.items.put(instanceId, this);
		}
	}

	@RpcBeanProperty(desc = "")
	public int x;

	@RpcBeanProperty(desc = "")
	public int y;
	
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
		if (this._task != null && value != null)
			throw new Error("f");
		this._task = value;
	}

	public BattleRoomSeat owner;

	@RpcBeanProperty(desc = "")
	public String getOwnerId() {
		return owner != null ? owner.user.uuid : null;
	}
	
	public BattleItemSoilder focusTarget;

	public Object controller;

	public BattleItem(JsonNode json) {
		this();

		instanceId = json.get("instanceId").asText();
		x = json.get("x").asInt();
		y = json.get("y").asInt();
		cartoon = json.get("cartoon").asText();
		layer = json.get("layer").asText();
	}

	public BattleItem() {
		instanceId = UUID.randomUUID().toString();
	}
}
