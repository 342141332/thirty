package com.gearbrother.mushroomWar.pojo;

import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;

@RpcBeanPartTransportable
public class BattleRoomPropertyEvent extends RpcBean {
	@RpcBeanProperty(desc = "准备玩家")
	public BattleRoomSeat readyUser;
}
