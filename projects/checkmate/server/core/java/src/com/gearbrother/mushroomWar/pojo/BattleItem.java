package com.gearbrother.mushroomWar.pojo;

import java.util.UUID;

import com.fasterxml.jackson.databind.JsonNode;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;

@RpcBeanPartTransportable(isPartTransport = true)
public class BattleItem extends RpcBean {
	@RpcBeanProperty(desc = "uuid")
	public String instanceId;

	@RpcBeanProperty(desc = "宽度")
	final public int width;
	
	@RpcBeanProperty(desc = "高度")
	final public int height;
	
	@RpcBeanProperty(desc = "是否会碰撞")
	final public boolean isCollisionable;

	@RpcBeanProperty(desc = "")
	public int left;

	@RpcBeanProperty(desc = "")
	public int top;

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

	public Task getTask() {
		return _task;
	}

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

	@RpcBeanProperty(desc = "攻击范围")
	public int[][] attackRects;

	@RpcBeanProperty(desc = "")
	public int[] forward;

	public CharacterModel character;

	public BattleItem(JsonNode json) {
		this(json.has("collisionable") ? json.get("collisionable").asBoolean() : true
				, json.has("width") ? json.get("width").asInt() : 1
				, json.has("height") ? json.get("height").asInt() : 1);

		instanceId = json.get("instanceId").asText();
		cartoon = json.get("cartoon").asText();
		layer = json.get("layer").asText();
		coin = json.get("coin").asInt();
		left = json.get("left").asInt();
		top = json.get("top").asInt();
	}

	public BattleItem(boolean collisionable, int width, int height) {
		instanceId = UUID.randomUUID().toString();
		this.isCollisionable = collisionable;
		this.width = width;
		this.height = height;
	}
}
