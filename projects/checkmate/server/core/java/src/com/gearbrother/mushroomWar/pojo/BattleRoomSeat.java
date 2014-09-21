package com.gearbrother.mushroomWar.pojo;

import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;

@RpcBeanPartTransportable(isPartTransport = true)
public class BattleRoomSeat extends RpcBean {
	final public BattleRoom room;
	
	@RpcBeanProperty(desc = "座位索引")
	public int index;

	@RpcBeanProperty(desc = "准备好了")
	public boolean isReady;

	@RpcBeanProperty(desc = "")
	public String name;

	public User user;

	@RpcBeanProperty(desc = "选择的英雄")
	public Avatar[] choosedHeroes;

	@RpcBeanProperty(desc = "是否是房主")
	public boolean isHost;

	public BattleRoomSeat(BattleRoom room, int index) {
		super();

		this.room = room;
		this.index = index;
		this.choosedHeroes = new Avatar[3];
	}

	public BattleRoomSeat(BattleRoom room, int index, User user) {
		this(room, index);

		this.user = user;
		name = user.name;
	}
}
