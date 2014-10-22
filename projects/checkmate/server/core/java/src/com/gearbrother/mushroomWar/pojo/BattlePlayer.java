package com.gearbrother.mushroomWar.pojo;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;

@RpcBeanPartTransportable(isPartTransport = true)
public class BattlePlayer extends RpcBean {
	final public Battle battle;

	@RpcBeanProperty(desc = "")
	public String instanceId;

	public BattleForce force;
	
	@RpcBeanProperty(desc = "")
	public String getForceId() {
		return force.id;
	}

	@RpcBeanProperty(desc = "准备好了")
	public boolean isReady;

	@RpcBeanProperty(desc = "")
	public String name;

	@RpcBeanProperty(desc = "选择的英雄")
	public Map<String, CharacterModel> choosedSoilders;

	@RpcBeanProperty(desc = "选择的英雄")
	public List<CharacterModel> choosedHeroes;

	@RpcBeanProperty(desc = "是否是房主")
	public boolean isHost;

	@RpcBeanProperty(desc = "联盟颜色")
	public int color;

	public int hp;

	public int maxHp;

	@RpcBeanProperty(desc = "等级")
	public int level;

	@RpcBeanProperty(desc = "")
	public int coin;

	public User user;

	public BattlePlayer(Battle battle) {
		super();

		this.instanceId = UUID.randomUUID().toString();
		this.battle = battle;
		this.choosedSoilders = new HashMap<String, CharacterModel>();
		for (Iterator<String> iterator = GameConf.instance.soilders.keySet().iterator(); iterator.hasNext();) {
			String avatarId = (String) iterator.next();
			this.choosedSoilders.put(avatarId, GameConf.instance.soilders.get(avatarId).clone());
		}
		this.choosedHeroes = new ArrayList<CharacterModel>();
		maxHp = hp = 30;
		level = 1;
		coin = 30;
	}

	public BattlePlayer(Battle battle, User user) {
		this(battle);

		this.instanceId = user.uuid;
		this.name = user.name;
		this.user = user;
	}
}
