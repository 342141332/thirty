package com.gearbrother.mushroomWar.pojo;

import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;

public class BattleRoomSeatCharacter extends RpcBean {
	@RpcBeanProperty(desc = "角色")
	public Character2 character;

	@RpcBeanProperty(desc = "拥有数量")
	public int num;

	public BattleRoomSeatCharacter(Character2 character, int num) {
		this.character = character;
		this.num = num;
	}
}
