package com.gearbrother.sheepwolf.pojo;

import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanProperty;

@RpcBeanPartTransportable(isPartTransport = true)
public class BattleRoomSeat extends RpcBean {
	@RpcBeanProperty(desc = "准备好了")
	public boolean isReady;

	@RpcBeanProperty(desc = "角色")
	public Avatar avatar;

	@RpcBeanProperty(desc = "是否是房主")
	public boolean isHost;

	public BattleRoomSeat() {
		super();
	}
}
