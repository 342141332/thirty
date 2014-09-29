package com.gearbrother.mushroomWar.pojo;

import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;

@RpcBeanPartTransportable(isPartTransport = true)
public class BattleItemSoilder extends BattleItem {
	public int attackDamage;

	public BattleItemBuilding building;

	public BattleItemSoilder(BattleItemBuilding building) {
		super();

		this.building = building;
	}
}
