package com.gearbrother.mushroomWar.pojo;

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

	public boolean isHomeBuilding;

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

	@RpcBeanProperty(desc = "")
	public String def;

	@RpcBeanProperty(desc = "等级")
	public int level;

	@RpcBeanProperty(desc = "攻击范围数组")
	public int[][] attackRects;

	@RpcBeanProperty(desc = "攻击力上下限")
	public int[] attackDamage;
	
	@RpcBeanProperty(desc = "攻击间隔")
	public long interval;

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

	@RpcBeanProperty(desc = "")
	public int getForward() {
		return force.forward;
	}

	public BattlePlayer player;

	public BattleForce force;

	public BattleItem(CharacterModel character) {
		this.width = character.width;
		this.height = character.height;
		this.cartoon = character.cartoon;
		this.def = character.nation == 0 ? "Soldier" : "Generial";
		this.layer = "over";
		this.hp = this.maxHp = character.getLevel().hp;
		this.attackRects = character.getLevel().attackRects;
		this.attackDamage = character.getLevel().attackDamage;
		this.interval = character.getLevel().interval;
	}

	public BattleItem(JsonNode json) {
		this.width = json.has("width") ? json.get("width").asInt() : 1;
		this.height = json.has("height") ? json.get("height").asInt() : 1;
		this.cartoon = json.get("cartoon").asText();
		this.def = json.get("def").asText();
		this.layer = json.get("layer").asText();
		this.left = json.get("left").asInt();
		this.top = json.get("top").asInt();
		this.hp = this.maxHp = json.get("hp").asInt();
		this.isHomeBuilding = json.get("isHome").asBoolean();
	}

	public boolean isCollision(BattleItem b) {
		if (isHomeBuilding) {
			return b.player != player;
		} else {
			return true;
		}
	}

	public boolean isCollision(CharacterModel character2) {
		return isHomeBuilding ? false : true;
	}
}
