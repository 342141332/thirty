package com.gearbrother.mushroomWar.rpc.service.bussiness;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.gearbrother.mushroomWar.model.ISession;
import com.gearbrother.mushroomWar.pojo.BattleRoom;
import com.gearbrother.mushroomWar.pojo.BattleRoomSeat;
import com.gearbrother.mushroomWar.pojo.BattleSignalBegin;
import com.gearbrother.mushroomWar.pojo.GameConf;
import com.gearbrother.mushroomWar.pojo.Hall;
import com.gearbrother.mushroomWar.pojo.IBagItem;
import com.gearbrother.mushroomWar.pojo.PropertyEvent;
import com.gearbrother.mushroomWar.pojo.Skill;
import com.gearbrother.mushroomWar.pojo.User;
import com.gearbrother.mushroomWar.pojo.World;
import com.gearbrother.mushroomWar.rpc.annotation.RpcServiceMethod;
import com.gearbrother.mushroomWar.rpc.annotation.RpcServiceMethodParameter;
import com.gearbrother.mushroomWar.rpc.error.RpcException;

/**
 * @author feng.lee
 * @create on 2013-11-27
 */
@Service
public class RoomService {
	static Logger logger = LoggerFactory.getLogger(BattleService.class);

	public GameConf gameConfs;

	public GameConf getGameConfs() {
		return gameConfs;
	}

	public void setGameConfs(GameConf gameConfs) {
		this.gameConfs = gameConfs;
		this.hall.mapIds = gameConfs.battles.keySet();
	}

	private Hall hall;

	public RoomService() {
		hall = new Hall();
	}

	@RpcServiceMethod(desc = "进入大厅")
	public Hall enterHall(ISession session) {
		hall.observer.addObserver(session);
		session.setEnteredHall(hall);
		return hall;
	}

	@RpcServiceMethod(desc = "离开大厅")
	public void outHall(ISession session) {
		hall.observer.deleteObserver(session);
		session.setEnteredHall(null);
	}

	@RpcServiceMethod(desc = "创建房间")
	public BattleRoom createRoom(ISession session, @RpcServiceMethodParameter(name = "battleConfId") String battleConfId) {
		session.getEnteredHall().observer.deleteObserver(session);
		session.setEnteredHall(null);

		User logined = session.getLogined();
		BattleRoom room = new BattleRoom(hall, 1, 1);
		room.observer.addObserver(session);
		session.setSeat(new BattleRoomSeat(room, 0, logined));
		room.name = logined.name;
		room.battle = gameConfs.battles.get(battleConfId).clone();
		room.seats[0] = session.getSeat();
		hall.rooms.put(room.uuid, room);
		room.hall.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_ADD, room));
		return room;
	}

	@RpcServiceMethod(desc = "进入房间")
	public BattleRoom enterRoom(ISession session,
			@RpcServiceMethodParameter(name = "roomUuid", desc = "房间ID") String roomUuid) {
		session.getEnteredHall().observer.deleteObserver(session);
		session.setEnteredHall(null);

		User logined = session.getLogined();
		BattleRoom room = hall.rooms.get(roomUuid);
		room.observer.addObserver(session);
		for (int i = 0; i < room.blueMax + room.redMax; i++) {
			if (room.seats[i] == null) {
				BattleRoomSeat seat = room.seats[i] = new BattleRoomSeat(room, i, logined);
				session.setSeat(seat);
				room.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_ADD, seat));
				break;
			}
		}
		return room;
	}

	@RpcServiceMethod(desc = "离开房间")
	public void outRoom(ISession session) {
		BattleRoomSeat seat = session.getSeat();
		seat.room.observer.deleteObserver(session);
		seat.room.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_REMOVE, seat));
		session.setSeat(null);
	}

	@RpcServiceMethod(desc = "换位子")
	public void switchSeat(ISession session
			, @RpcServiceMethodParameter(name = "newSeatId") int newSeatId) {
		BattleRoomSeat seat = session.getSeat();
		BattleRoom room = session.getSeat().room;
		if (room.seats[newSeatId] == null && seat != null) {
			for (int i = 0; i < room.seats.length; i++) {
				if (room.seats[i] == seat) {
					room.seats[i] = null;
					break;
				}
			}
			seat.index = newSeatId;
			room.seats[newSeatId] = seat;
		}
		room.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, room));
	}

	@RpcServiceMethod(desc = "装备英雄")
	public void setHero(ISession session,
			@RpcServiceMethodParameter(name = "heroInstanceUuid", desc = "") String heroInstanceUuid,
			@RpcServiceMethodParameter(name = "index") int index) {
		BattleRoomSeat seat = session.getSeat();
		session.getSeat().room.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, seat));
	}

	@RpcServiceMethod(desc = "装备道具")
	public void setTool(ISession session, @RpcServiceMethodParameter(name = "avatarUuid", desc = "") String avatarUuid,
			@RpcServiceMethodParameter(name = "bagUuid", desc = "背包实例ID") String bagUuid,
			@RpcServiceMethodParameter(name = "index") int index) {
		User logined = session.getLogined();
		IBagItem bagItem = logined.bagItems.get(bagUuid);
		if (bagItem instanceof Skill) {
		}
	}

	@RpcServiceMethod(desc = "准备")
	public void ready(ISession session) throws RpcException {
		BattleRoomSeat seat = session.getSeat();
		seat.isReady = true;
		session.getSeat().room.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, seat));
	}

	@RpcServiceMethod(desc = "取消准备")
	public void unready(ISession session) throws RpcException {
		BattleRoomSeat seat = session.getSeat();
		seat.isReady = false;
		session.getSeat().room.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, seat));
	}

	@RpcServiceMethod(desc = "")
	public void switchMap(ISession session) {
		// BattleRoom room = (BattleRoom) session.getRoom();
		// room.battle = gameConfs.battles.
	}

	@RpcServiceMethod(desc = "开启房间(只有房主可以)")
	public void startRoom(ISession session
			, @RpcServiceMethodParameter(name = "roomUuid", desc = "房间ID") String roomUuid) {
		BattleRoom room = session.getSeat().room;
		room.hall.rooms.remove(room.uuid);
		room.hall.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_REMOVE, room));
		room.play();
		room.observer.notifySessions(new BattleSignalBegin(room.battle));
		World.instance.runningBattles.put(room.uuid, room);
	}
}
