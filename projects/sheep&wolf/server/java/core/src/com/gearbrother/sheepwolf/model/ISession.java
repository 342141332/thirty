package com.gearbrother.sheepwolf.model;

import com.gearbrother.sheepwolf.pojo.BattleRoomSeat;
import com.gearbrother.sheepwolf.pojo.BoardRoom;
import com.gearbrother.sheepwolf.pojo.User;

/**
 * @author feng.lee
 * @create on 2013-12-6
 */
public interface ISession {
	public User getLogined();
	
	public void setLogined(User value);

	public BoardRoom getRoom();

	public void setRoom(BoardRoom newValue);
	
	public BattleRoomSeat getRoomSeat();
	
	public void setRoomMember(BattleRoomSeat member);

	public void send(Object message);

	public void close();
}
