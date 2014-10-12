package com.gearbrother.mushroomWar.pojo;

import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;

@RpcBeanPartTransportable
public class BattleRoomSeatCharacter extends RpcBean {
	@RpcBeanProperty(desc = "角色")
	public CharacterModel character;

	@RpcBeanProperty(desc = "拥有数量")
	public int num;

	public BattleRoomSeatCharacter(CharacterModel character, int num) {
		this.character = character;
		this.num = num;
	}
}
