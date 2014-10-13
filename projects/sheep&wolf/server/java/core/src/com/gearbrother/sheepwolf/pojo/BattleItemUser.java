package com.gearbrother.sheepwolf.pojo;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanProperty;

/**
 * @author feng.lee
 * @create on 2014-3-3
 */
@RpcBeanPartTransportable(isPartTransport = true)
public class BattleItemUser extends BattleItem {
	@RpcBeanProperty(desc = "拼图")
	public BattleItem pickUpedPuzzle;

	@RpcBeanProperty(desc = "移动速度")
	public double orginalSpeed;

	@RpcBeanProperty(desc = "临时速度")
	public double changedSpeed;

	@RpcBeanProperty(desc = "临时速度过期时间")
	public long changedSpeedExpiredPeriodTime;

	@RpcBeanProperty(desc = "攻击力")
	public int originalAbilityDamage;

	@RpcBeanProperty(desc = "临时攻击力")
	public int changedAbilityDamage;

	@RpcBeanProperty(desc = "临时攻击力失效时间")
	public long changedAbilityDamageExpiredPeriodTime;
	
	@RpcBeanProperty(desc = "")
	public int lifes;
	
	// @RpcBeanProperty(desc = "无敌，血量锁定")
	// public boolean lockHp;
	//
	// @RpcBeanProperty(desc = "隐形")
	// public boolean invisible;
	//
	// @RpcBeanProperty(desc = "当前速度效果, -1: 减速, 0: 正常, 1: 加速")
	// public int speedUp;
	//
	// @RpcBeanProperty(desc = "眩晕")
	// public boolean isSwim;

	@RpcBeanProperty(desc = "buff")
	public List<BattleBuff> buffs;

	@RpcBeanProperty(desc = "阵营")
	public int color;

	@RpcBeanProperty(desc = "当前方向")
	public int direction;

	@RpcBeanProperty(desc = "")
	public int money;
	
	@RpcBeanProperty(desc = "")
	public int level;

	@RpcBeanProperty(desc = "")
	public List<Skill> skills;
	
	@RpcBeanProperty(desc = "")
	public String name;

	@RpcBeanProperty(desc = "")
	public boolean isCaptured;

	public BattleRoomSeat seat;

	@Override
	public void setBattle(Battle newValue) {
		if (_battle != null) {
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
		}
	}
	
	public BattleItemUser(BattleRoomSeat seat) {
		super();

		this.seat = seat;
		this.uuid = seat.avatar.user.uuid;
		this.name = seat.avatar.user.name;
		this.width = this.height = 1D;
		this.cartoon = seat.avatar.cartoon;
		this.layer = "over";
		this.isDestoryable = true;
		this.buffs = new ArrayList<BattleBuff>();
		this.level = seat.avatar.getLevel().id;
		this.orginalSpeed = seat.avatar.getLevel().move;
		this.hp = this.maxHp = seat.avatar.getLevel().hp;
		this.originalAbilityDamage = 10;
		this.skills = new ArrayList<Skill>();
		for (Skill skill : seat.avatar.skills) {
			skills.add(skill.clone());
		}
	}
	
	public void addSkill(Skill newValue) {
		int at = skills.indexOf(newValue);
		if (at > -1) {
			skills.get(at).num++;
		} else {
			skills.add(newValue.clone());
		}
	}
	public void removeSkill(Skill newValue) {
		int at = skills.indexOf(newValue);
		if (at > -1) {
			newValue = skills.get(at);
			newValue.num--;
			if (newValue.num < 1)
				skills.remove(at);
		}
	}
}
