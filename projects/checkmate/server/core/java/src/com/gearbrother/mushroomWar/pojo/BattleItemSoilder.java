package com.gearbrother.mushroomWar.pojo;

import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;

@RpcBeanPartTransportable
public class BattleItemSoilder extends BattleItem {
	@RpcBeanProperty(desc = "攻击时间")
	public long attackTime;

	public BattleItemBuilding building;
	
	public BattleItemSoilder(BattleItemBuilding building) {
		this.building = building;
	}
}
