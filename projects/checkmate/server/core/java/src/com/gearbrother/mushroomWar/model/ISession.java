package com.gearbrother.mushroomWar.model;

import com.gearbrother.mushroomWar.pojo.BattleRoomSeat;
import com.gearbrother.mushroomWar.pojo.Hall;
import com.gearbrother.mushroomWar.pojo.User;

/**
 * @author feng.lee
 * @create on 2013-12-6
 */
public interface ISession {
	public User getLogined();

	public void setLogined(User value);

	public Hall getEnteredHall();

	public void setEnteredHall(Hall value);

	public BattleRoomSeat getSeat();

	public void setSeat(BattleRoomSeat value);

	public void send(Object message);

	public void close();
}
