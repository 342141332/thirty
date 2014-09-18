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

	private BoardRoom _room;

	@Override
	public BoardRoom getRoom() {
		return _room;
	}

	@Override
	public void setRoom(BoardRoom room) {
		if (_room != null) {
			_room.removeSession(this);
		}
		_room = room;
		if (_room != null)
			_room.addSession(this);
	}
	
	private IoSession session;

	private World world;
	
	private BattleRoomSeat member;
	@Override
	public BattleRoomSeat getRoomSeat() {
		return member;
	}
	
	@Override
	public void setRoomMember(BattleRoomSeat member) {
		this.member = member;
	}

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
		setRoom(null);
	}
}
