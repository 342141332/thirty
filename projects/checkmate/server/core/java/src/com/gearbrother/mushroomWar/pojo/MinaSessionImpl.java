package com.gearbrother.mushroomWar.pojo;

import org.apache.mina.core.session.IoSession;

import com.gearbrother.mushroomWar.model.ISession;

/**
 * @author feng.lee
 * @create on 2013-12-6
 */
public class MinaSessionImpl implements ISession {
	private User logined;

	@Override
	public User getLogined() {
		return logined;
	}

	@Override
	public void setLogined(User value) {
		if (logined != null) {
			world.sessions.remove(logined.uuid);
		}
		logined = value;
		if (logined != null) {
			world.sessions.put(logined.uuid, this);
		}
	}
	
	private World world;
	
	public World getWorld() {
		return world;
	}
	
	public void setWorld(World value) {
		this.world = value;
		this.world.addSession(this);
	}

	private Hall hall;

	@Override
	public Hall getHall() {
		return hall;
	}

	@Override
	public void setHall(Hall value) {
		if (this.hall != null) {
			this.hall.removeSession(this);
		}
		this.hall = value;
		if (this.hall != null) {
			this.hall.addSession(this);
		}
	}

	private BattleRoomSeat seat;

	@Override
	public BattleRoomSeat getRoomSeat() {
		return seat;
	}

	@Override
	public void setRoomSeat(BattleRoomSeat value) {
		if (this.seat != null)
			this.seat.getRoom().removeSession(this);
		this.seat = value;
	}

	private IoSession session;

	public MinaSessionImpl(IoSession session, World world) {
		super();

		this.session = session;
		this.world = world;
	}

	public void send(Object message) {
		session.write(message);
	}

	@Override
	public void close() {
		world.sessions.remove(logined.uuid);
		setHall(null);
		setRoomSeat(null);
	}
}
