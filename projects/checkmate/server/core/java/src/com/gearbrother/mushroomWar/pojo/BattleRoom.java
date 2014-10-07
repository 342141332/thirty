package com.gearbrother.mushroomWar.pojo;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;
import java.util.UUID;

import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;
import com.gearbrother.mushroomWar.util.GMathUtil;

/**
 * @author feng.lee
 * @create on 2013-11-27
 */

@RpcBeanPartTransportable(isPartTransport = true)
public class BattleRoom extends RpcBean {
	@RpcBeanProperty(desc = "唯一id")
	final public String uuid;

	@RpcBeanProperty(desc = "房间名字")
	public String name;

	@RpcBeanProperty(desc = "战斗")
	public Battle battle;

	@RpcBeanProperty(desc = "")
	public int blueMax;

	@RpcBeanProperty(desc = "")
	public int redMax;

	@RpcBeanProperty(desc = "")
	final public BattleRoomSeat[] seats;
	
	final public SessionObserver observer;

	final public Hall hall;

	public BattleRoom(Hall hall, int blueMax, int redMax) {
		super();

		this.uuid = UUID.randomUUID().toString();
		this.hall = hall;
		this.hall.rooms.put(uuid, this);
		this.blueMax = blueMax;
		this.redMax = redMax;
		this.seats = new BattleRoomSeat[blueMax + redMax];
		this.observer = new SessionObserver();
	}

	public void play() {
		battle.startTime = System.currentTimeMillis();
		battle.observer = this.observer;
		Map<String, BattleItem> buildings = battle.getItems(BattleItemBuilding.class);
		List<BattleItemBuilding> hostBuildings = new ArrayList<BattleItemBuilding>();
		for (Iterator<String> iterator = buildings.keySet().iterator(); iterator.hasNext();) {
			String buildingId = (String) iterator.next();
			BattleItemBuilding building = (BattleItemBuilding) buildings.get(buildingId);
			building.produce = new TaskProduce(battle, battle.startTime, 3000, building, "A0", 2);
			if (building.host) {
				hostBuildings.add(building);
			}
		}
		for (int i = 0; i < seats.length; i++) {
			BattleRoomSeat seat = seats[i];
			if (seat != null) {
				BattleItemBuilding home = (BattleItemBuilding) GMathUtil.random(hostBuildings);
				hostBuildings.remove(home);
				home.owner = seat;
			}
		}
	}
	
	public static void main(String[] args) {
		final List<BattleRoom> rooms = new ArrayList<BattleRoom>();
		for (int i = 0; i < 2000; i++) {
			long currentTime = System.currentTimeMillis();
			final BattleRoom room = new BattleRoom(World.instance.hall, 4, 4);
			room.battle = new Battle();
			List<BattleItemBuilding> buildings = new ArrayList<BattleItemBuilding>();
			for (int j = 0; j < 40; j++) {
				BattleItemBuilding building = new BattleItemBuilding();
				building.instanceId = "Building_" + j;
				building.x = 0;
				building.y = 0;
				building.setBattle(room.battle);
				buildings.add(building);
			}
			for (int j = 0; j < buildings.size(); j++) {
				BattleItemBuilding building = buildings.get(j);
				BattleItemBuilding pickedBuilding = (BattleItemBuilding) GMathUtil.random(buildings);
			}
			rooms.add(room);
		}
		Timer timer = new Timer();
		timer.schedule(new TimerTask() {
			@Override
			public void run() {
				long now = System.currentTimeMillis();
				for (Iterator<BattleRoom> iterator = rooms.iterator(); iterator.hasNext();) {
					BattleRoom room = (BattleRoom) iterator.next();
					room.battle.execute(now);
				}
			}
		}, 0, 100);
	}
}
