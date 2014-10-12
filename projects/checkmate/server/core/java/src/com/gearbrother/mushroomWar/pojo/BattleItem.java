package com.gearbrother.mushroomWar.pojo;

import java.util.UUID;

import com.fasterxml.jackson.databind.JsonNode;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;

@RpcBeanPartTransportable(isPartTransport = true)
public class BattleItem extends RpcBean {
	@RpcBeanProperty(desc = "uuid")
	public String instanceId;

	@RpcBeanProperty(desc = "碰撞体积相对左上角坐标")
	final public int[] collisionRect;

	@RpcBeanProperty(desc = "")
	public int left;

	@RpcBeanProperty(desc = "")
	public int top;

	public int width;

	public int height;

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

	@RpcBeanProperty(desc = "攻击范围")
	public int[][] attackRects;

	@RpcBeanProperty(desc = "")
	public int[] forward;

	public CharacterModel character;

	public BattleItem(JsonNode json) {
		this();

		instanceId = json.get("instanceId").asText();
		cartoon = json.get("cartoon").asText();
		layer = json.get("layer").asText();
		coin = json.get("coin").asInt();
		left = json.get("left").asInt();
		top = json.get("top").asInt();
	}

	public BattleItem() {
		instanceId = UUID.randomUUID().toString();
		collisionRect = new int[] { 1, 1 };
		width = height = 1;
		attackRects = new int[1][];
		attackRects[0] = new int[] { 0, -1, 1, 0 };
	}

	public void updateCollision(Battle battle) {
		for (int w = 0; w < collisionRect[0]; w++) {
			for (int h = 0; h < collisionRect[1]; h++) {
				battle.collisions[this.left + w][this.top + h] = this;
			}
		}
	}
}
