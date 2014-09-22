package com.gearbrother.mushroomWar.pojo;

import org.apache.mina.core.session.IoSession;

import com.gearbrother.mushroomWar.model.ISession;

/**
 * @author feng.lee
 * @create on 2013-12-6
 */
public class MinaSessionImpl implements ISession {
	final private IoSession session;
	
	final private World world;
	
	private User logined;

	@Override
	public User getLogined() {
		return logined;
	}

	@Override
	public void setLogined(User value) {
		logined = value;
	}

	private Hall enteredHall;

	public Hall getEnteredHall() {
		return enteredHall;
	}

	public void setEnteredHall(Hall value) {
		this.enteredHall = value;
	}

	private BattleRoomSeat seat;

	public BattleRoomSeat getSeat() {
		return seat;
	}


	public void setSeat(BattleRoomSeat value) {
		this.seat = value;
	}

	public MinaSessionImpl(IoSession session, World world) {
		super();

		this.session = session;
		this.world = world;
		this.world.connectedSessions.add(this);
	}

	public void send(Object message) {
		session.write(message);
	}

	@Override
	public void close() {
		this.world.connectedSessions.remove(this);
		if (this.logined != null) {
			this.world.loginedSessions.remove(this.logined.uuid);
			if (this.enteredHall != null)
				this.enteredHall.observer.deleteObserver(this);
			if (this.seat != null) {
				for (int i = 0; i < this.seat.room.seats.length; i++) {
					if (this.seat.room.seats[i] == this.seat) {
						this.seat.room.seats[i] = null;
					}
				}
				int unemptySeatCount = 0;
				for (int i = 0; i < this.seat.room.seats.length; i++) {
					unemptySeatCount += this.seat.room.seats[i] != null ? 1 : 0;
				}
				if (unemptySeatCount > 0) {
					this.seat.room.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_REMOVE, this.seat));
				} else {
					this.seat.room.hall.rooms.remove(this.seat.room.uuid);
					this.seat.room.hall.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_REMOVE, this.seat.room));
				}
			}
		}
	}
}
