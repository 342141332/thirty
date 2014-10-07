package com.gearbrother.mushroomWar.pojo;

import com.gearbrother.mushroomWar.pojo.BattleItemBuilding.BattleField;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;

@RpcBeanPartTransportable(isPartTransport = true)
public class BattleItemSoilder extends BattleItem {
	public int attackDamage;
	
	public BattleField inField;

	public BattleItemSoilder() {
		super();
	}
}
