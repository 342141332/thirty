package com.gearbrother.mushroomWar.pojo;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.SortedSet;
import java.util.Timer;
import java.util.TimerTask;
import java.util.TreeSet;
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

	final public SortedSet<Task> tasks;
	
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
		this.tasks = new TreeSet<Task>(
				new Comparator<Task>() {
					
					@Override
					public int compare(Task o1, Task o2) {
						return o1.getNextExecuteTime() > o2.getNextExecuteTime()
								? 1 : (o1.getNextExecuteTime() < o2.getNextExecuteTime() ? -1 : o1.instanceId.compareTo(o2.instanceId));
					}
				}
			);
		this.observer = new SessionObserver();
	}

	public void play() {
		battle.startTime = System.currentTimeMillis();
		Map<String, BattleItem> buildings = battle.getItems(BattleItemBuilding.class);
		List<BattleItemBuilding> hostBuildings = new ArrayList<BattleItemBuilding>();
		for (Iterator<String> iterator = buildings.keySet().iterator(); iterator.hasNext();) {
			String buildingId = (String) iterator.next();
			BattleItemBuilding building = (BattleItemBuilding) buildings.get(buildingId);
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
				TaskProduce produce = new TaskProduce(battle.startTime, 1100, home, "A0", 1);
				home.produce = produce;
				home.produce.updateExecuteTime(battle.startTime + produce.interval, this);
			}
		}
	}

	public void execute(long now) {
		while (tasks.size() > 0) {
			Task head = tasks.first();
			if (now >= head.getNextExecuteTime()) {
				boolean res = tasks.remove(head);
				if (!res)
					throw new Error("remove fail");
				head.execute(now);
			} else {
				break;
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
				building.produce = new TaskProduce(currentTime, 300, building, "itemConfId", 1);
				building.produce.updateExecuteTime(currentTime + 300, room);
				buildings.add(building);
			}
			for (int j = 0; j < buildings.size(); j++) {
				BattleItemBuilding building = buildings.get(j);
				BattleItemBuilding pickedBuilding = (BattleItemBuilding) GMathUtil.random(buildings);
				building.dispatch = new TaskDispatch(currentTime, 500, building, pickedBuilding, 10);
				building.dispatch.updateExecuteTime(currentTime + 500, room);
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
					room.execute(now);
				}
			}
		}, 0, 100);
	}
}
