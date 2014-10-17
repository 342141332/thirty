package com.gearbrother.mushroomWar.pojo;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
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
		battle.state = Battle.STATE_PLAYING;
		battle.startTime = System.currentTimeMillis();
		battle.observer = this.observer;
		battle.seats = seats;
		for (int i = 0; i < seats.length; i++) {
			BattleRoomSeat seat = seats[i];
			if (seat != null)
				seat.force = battle.forces[blueMax > seat.index ? 0 : 1];
		}
	}

	public static void main(String[] args) {
		final List<BattleRoom> rooms = new ArrayList<BattleRoom>();
		for (int i = 0; i < 2000; i++) {
			long currentTime = System.currentTimeMillis();
			final BattleRoom room = new BattleRoom(World.instance.hall, 4, 4);
			room.battle = new Battle();
			List<BattleItem> buildings = new ArrayList<BattleItem>();
			for (int j = 0; j < buildings.size(); j++) {
				BattleItem building = buildings.get(j);
				BattleItem pickedBuilding = (BattleItem) GMathUtil.random(buildings);
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
