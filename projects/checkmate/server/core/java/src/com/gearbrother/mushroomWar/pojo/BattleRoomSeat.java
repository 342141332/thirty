package com.gearbrother.mushroomWar.pojo;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.UUID;

import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;

@RpcBeanPartTransportable(isPartTransport = true)
public class BattleRoomSeat extends RpcBean {
	final public BattleRoom room;

	@RpcBeanProperty(desc = "")
	public String instanceId;

	@RpcBeanProperty(desc = "座位索引")
	public int index;

	@RpcBeanProperty(desc = "准备好了")
	public boolean isReady;

	@RpcBeanProperty(desc = "")
	public String name;

	public User user;

	@RpcBeanProperty(desc = "选择的英雄")
	public Map<String, Character2> choosedSoilders;

	@RpcBeanProperty(desc = "选择的英雄")
	public Character2[] choosedHeroes;

	@RpcBeanProperty(desc = "是否是房主")
	public boolean isHost;

	public BattleRoomSeat(BattleRoom room, int index) {
		super();

		this.instanceId = UUID.randomUUID().toString();
		this.room = room;
		this.index = index;
		this.choosedSoilders = new HashMap<String, Character2>();
		for (Iterator<String> iterator = GameConf.instance.soilders.keySet().iterator(); iterator.hasNext();) {
			String avatarId = (String) iterator.next();
			this.choosedSoilders.put(avatarId, GameConf.instance.soilders.get(avatarId).clone());
		}
		this.choosedHeroes = new Character2[3];
	}

	public BattleRoomSeat(BattleRoom room, int index, User user) {
		this(room, index);

		this.instanceId = user.uuid;
		this.user = user;
		this.name = user.name;
	}
}
