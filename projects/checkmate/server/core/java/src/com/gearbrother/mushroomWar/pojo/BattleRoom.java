package com.gearbrother.mushroomWar.pojo;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;
import com.gearbrother.mushroomWar.util.GMathUtil;

/**
 * @author feng.lee
 * @create on 2013-11-27
 */

@RpcBeanPartTransportable(isPartTransport = true)
public class BattleRoom extends SessionGroup {
	@RpcBeanProperty(desc = "唯一id")
	final public String uuid;

	@RpcBeanProperty(desc = "房间名字")
	public String name;

	@RpcBeanProperty(desc = "战斗")
	public Battle battle;
	
	@RpcBeanProperty(desc = "")
	public List<BattleRoomSeat> seats;
	
	@RpcBeanProperty(desc = "")
	public int blueMax;
	
	@RpcBeanProperty(desc = "")
	public int redMax;

	private Hall hall;
	public Hall getHall() {
		return hall;
	}
	public void setHall(Hall value) {
		if (this.hall != null) {
			this.hall.rooms.remove(uuid);
		}
		this.hall = value;
		this.hall.rooms.put(uuid, this);
	}

	public BattleRoom(Hall hall, int blueMax, int redMax) {
		super();

		uuid = UUID.randomUUID().toString();
		setHall(hall);
		seats = new ArrayList<BattleRoomSeat>(blueMax + redMax);
		this.blueMax = blueMax;
		this.redMax = redMax;
	}

	public void play() {
		battle.startTime = System.currentTimeMillis();
		List<String> buildingIds = new ArrayList<String>(battle.getItems(BattleItemBuilding.class).keySet());
		for (int i = 0; i < seats.size(); i++) {
			BattleRoomSeat seat = seats.get(i);
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
		hall.rooms.remove(uuid);
		hall = null;
	}
}
