package com.gearbrother.mushroomWar.pojo;

import java.util.HashMap;

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
			if (isCollisionable) {
				for (double r = Math.floor(y); r < Math.ceil(y); r++) {
					for (double c = Math.floor(x); c < Math.ceil(x); c++) {
						_battle.setCollision(r, c, null);
					}
				}
			}
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
			if (isCollisionable) {
				for (double r = Math.floor(y); r < Math.ceil(y); r++) {
					for (double c = Math.floor(x); c < Math.ceil(x); c++) {
						_battle.setCollision(r, c, this);
					}
				}
			}
		}
	}

	@RpcBeanProperty(desc = "")
	public double x;

	@RpcBeanProperty(desc = "")
	public double y;

	@RpcBeanProperty(desc = "所在动画层")
	public String layer;

	@RpcBeanProperty(desc = "人物动画")
	public String cartoon;

	@RpcBeanProperty(desc = "是否会阻挡")
	public boolean isCollisionable;

	@RpcBeanProperty(desc = "羊阻挡")
	public boolean isSheepPassable;

	@RpcBeanProperty(desc = "狼阻挡")
	public boolean isWolfPassable;

	@RpcBeanProperty(desc = "当前血量")
	public int hp;

	@RpcBeanProperty(desc = "满级血量")
	public int maxHp;

	@RpcBeanProperty(desc = "等级")
	public int level;

	@RpcBeanProperty(desc = "当前行为")
	public Object currentAction;

	public TaskTroopMove move;

	public BattleRoomSeat owner;

	@RpcBeanProperty(desc = "")
	public String getOwnerId() {
		return owner != null ? owner.user.uuid : null;
	}

	public Object controller;

	public BattleItem(JsonNode json) {
		this();

		instanceId = json.get("uuid").asText();
		x = json.get("x").asDouble();
		y = json.get("y").asDouble();
		cartoon = json.get("cartoon").asText();
		layer = json.get("layer").asText();
		isCollisionable = json.hasNonNull("isCollisionable") ? json.get(
				"isCollisionable").asBoolean() : false;
		isSheepPassable = json.hasNonNull("isSheepPassable") ? json.get(
				"isSheepPassable").asBoolean() : false;
		isWolfPassable = json.hasNonNull("isWolfPassable") ? json.get(
				"isWolfPassable").asBoolean() : false;
	}

	public BattleItem() {
	}
}
