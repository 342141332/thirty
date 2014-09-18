package com.gearbrother.mushroomWar.pojo;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import com.gearbrother.mushroomWar.model.ISession;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;
import com.gearbrother.mushroomWar.util.GMathUtil;

/**
 * @author feng.lee
 * @create on 2013-11-27
 */

@RpcBeanPartTransportable(isPartTransport = true)
public class BattleRoom extends BoardRoom {
	@RpcBeanProperty(desc = "唯一id")
	public String uuid;

	@RpcBeanProperty(desc = "房间名字")
	public String name;

	@RpcBeanProperty(desc = "战斗")
	public Battle battle;
	
	@RpcBeanProperty(desc = "")
	public BattleRoomSeat[] seats;
	
	@RpcBeanProperty(desc = "")
	public int blueMax;
	
	@RpcBeanProperty(desc = "")
	public int redMax;

	private Hall parent;

	public BattleRoom(Hall parent, int blueMax, int redMax) {
		super();

		uuid = UUID.randomUUID().toString();
		seats = new BattleRoomSeat[blueMax + redMax];
		this.blueMax = blueMax;
		this.redMax = redMax;
		this.parent = parent;
		this.parent.rooms.put(uuid, this);
	}
	
	@Override
	public boolean removeSession(ISession value) {
		boolean res = super.removeSession(value);
		if (getSessions().size() == 0) {
			parent.rooms.remove(this);
		}
		return res;
	}

	public void play() {
		battle.startTime = System.currentTimeMillis();
		List<String> buildingIds = new ArrayList<String>(battle.getItems(BattleItemBuilding.class).keySet());
		for (int i = 0; i < seats.length; i++) {
			BattleRoomSeat seat = seats[i];
			if (seat != null) {
				String random = (String) GMathUtil.random(buildingIds);
				BattleItemBuilding home = (BattleItemBuilding) battle.items.get(random);
				home.owner = seat;
				buildingIds.remove(random);
				TaskProduce produce = new TaskProduce(battle.startTime, 700, home, "A0", 2);
				home.produce = produce;
				home.produce.updateExecuteTime(battle.startTime + produce.interval, battle);
			}
		}
		World.instance.battles.put(uuid, battle);
	}
	
	public void close() {
		parent.rooms.remove(uuid);
		parent = null;
	}
}
