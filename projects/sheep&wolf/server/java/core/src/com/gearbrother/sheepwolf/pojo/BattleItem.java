package com.gearbrother.sheepwolf.pojo;

import java.util.HashMap;

import com.fasterxml.jackson.databind.JsonNode;
import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanProperty;
import com.gearbrother.sheepwolf.rpc.error.RpcException;

@RpcBeanPartTransportable
public class BattleItem extends RpcBean {
	@RpcBeanProperty(desc = "uuid")
	public String uuid;

	protected Battle _battle;
	public Battle getBattle() {
		return _battle;
	}
	public void setBattle(Battle newValue) {
		if (_battle != null) {
			if (isCollisionable) {
				for (double r = Math.floor(y); r < Math.ceil(y + height); r++) {
					for (double c = Math.floor(x); c < Math.ceil(x + width); c++) {
						_battle.setCollision(r, c, null);
					}
				}
			}
			_battle.sortItems.get(getClass()).remove(uuid);
			_battle.items.remove(uuid);
			_battle = null;
		}
		_battle = newValue;
		if (_battle != null) {
			if (!_battle.sortItems.containsKey(getClass())) {
				_battle.sortItems.put(getClass(), new HashMap<String, BattleItem>());
			}
			_battle.sortItems.get(getClass()).put(uuid, this);
			_battle.items.put(uuid, this);
			if (isCollisionable) {
				for (double r = Math.floor(y); r < Math.ceil(y + height); r++) {
					for (double c = Math.floor(x); c < Math.ceil(x + width); c++) {
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
	
	@RpcBeanProperty(desc = "")
	public double width;
	
	@RpcBeanProperty(desc = "")
	public double height;
	
	@RpcBeanProperty(desc = "")
	public String layer;
	
	@RpcBeanProperty(desc = "")
	public String cartoon;
	
	@RpcBeanProperty(desc = "是否会阻挡")
	public boolean isCollisionable;
	
	@RpcBeanProperty(desc = "羊阻挡")
	public boolean isSheepPassable;
	
	@RpcBeanProperty(desc = "狼阻挡")
	public boolean isWolfPassable;
	
	@RpcBeanProperty(desc = "是否可摧毁")
	public boolean isDestoryable;
	
	@RpcBeanProperty(desc = "当前血量")
	public int hp;
	
	@RpcBeanProperty(desc = "满级血量")
	public int maxHp;
	
	@RpcBeanProperty(desc = "")
	public long validTime1;
	
	@RpcBeanProperty(desc = "")
	public long validTime2;
	
	@RpcBeanProperty(desc = "")
	public String touchAutoRemoteCall;

	@RpcBeanProperty(desc = "")
	public JsonNode touchAutoRemoteCallParams;
	
	@RpcBeanProperty(desc = "")
	public String touchManualRemoteCall;

	@RpcBeanProperty(desc = "")
	public JsonNode touchManualRemoteCallParams;
	
	@RpcBeanProperty(desc = "当前行为")
	public Object currentAction;

	public Object controller;

	public BattleItem(JsonNode json) {
		this();

		uuid = json.get("uuid").asText();
		x = json.get("x").asDouble();
		y = json.get("y").asDouble();
		width = json.get("width").asDouble();
		height = json.get("height").asDouble();
		cartoon = json.get("cartoon").asText();
		layer = json.get("layer").asText();
		isCollisionable = json.hasNonNull("isCollisionable") ? json.get("isCollisionable").asBoolean() : false;
		isSheepPassable = json.hasNonNull("isSheepPassable") ? json.get("isSheepPassable").asBoolean() : false;
		isWolfPassable = json.hasNonNull("isWolfPassable") ? json.get("isWolfPassable").asBoolean() : false;
		touchAutoRemoteCall = json.hasNonNull("touchAutoRemoteCall") ? json.get("touchAutoRemoteCall").asText() : null;
		touchAutoRemoteCallParams = json.get("touchAutoRemoteCallParams");
		touchManualRemoteCall = json.hasNonNull("touchManualRemoteCall") ? json.get("touchManualRemoteCall").asText() : null;
		touchManualRemoteCallParams = json.get("touchManualRemoteCallParams");
	}

	public BattleItem() {
	}

	public boolean intersect(BattleItem target, long currentTime) throws RpcException {
		 double[] xy = new double[2];
		 PointBean pt = target.getPosition(currentTime);
		 xy[0] = pt.x;
		 xy[1] = pt.y;
		return Bounds.intersects(x, y, width, height, xy[0], xy[1], target.width, target.height);
	}

	public PointBean getPosition(long currentTime) {
		if (currentAction instanceof BattleUserActionWalk)
			return ((BattleUserActionWalk) currentAction).getPoint(this, _battle, currentTime);
		else if (currentAction instanceof BattleUserActionSkillUsing)
			return ((BattleUserActionSkillUsing) currentAction).startPosition;
		return null;
	}
	
	public boolean isBlock(Object obj) {
		if (obj instanceof BattleItemUser) {
			BattleItemUser user = (BattleItemUser) obj;
			if (user.color == BattleColor.SHEEP) {
				return !isSheepPassable;
			} else if (user.color == BattleColor.WOLF) {
				return !isWolfPassable;
			}
		}
		return true;
	}
}
