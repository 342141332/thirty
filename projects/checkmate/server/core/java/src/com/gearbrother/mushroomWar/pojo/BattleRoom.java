package com.gearbrother.mushroomWar.pojo;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.SortedSet;
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
//				Task second = queue.size() > 0 ? queue.first() : null;
//				long time = Math.max(now, second != null ? second.nextExecuteTime : 0);
				head.execute(now);
			} else {
				break;
			}
		}
	}
}
