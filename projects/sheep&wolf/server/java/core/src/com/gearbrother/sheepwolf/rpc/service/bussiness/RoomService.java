package com.gearbrother.sheepwolf.rpc.service.bussiness;

import java.util.Timer;
import java.util.TimerTask;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.gearbrother.sheepwolf.model.ISession;
import com.gearbrother.sheepwolf.pojo.Battle;
import com.gearbrother.sheepwolf.pojo.BattleRoom;
import com.gearbrother.sheepwolf.pojo.BattleRoomSeat;
import com.gearbrother.sheepwolf.pojo.BattleSignalBegin;
import com.gearbrother.sheepwolf.pojo.BoardRoom;
import com.gearbrother.sheepwolf.pojo.GameConf;
import com.gearbrother.sheepwolf.pojo.Hall;
import com.gearbrother.sheepwolf.pojo.IBagItem;
import com.gearbrother.sheepwolf.pojo.Skill;
import com.gearbrother.sheepwolf.pojo.User;
import com.gearbrother.sheepwolf.rpc.annotation.RpcServiceMethod;
import com.gearbrother.sheepwolf.rpc.annotation.RpcServiceMethodParameter;
import com.gearbrother.sheepwolf.rpc.error.RpcException;

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

	private Timer timer;
	
	private Hall hall;

	public RoomService() {
		hall = new Hall();
	}
	
	@RpcServiceMethod(desc = "进入大厅")
	public Hall enterHall(ISession session) {
		session.setRoom(hall);
		return hall;
	}
	
	@RpcServiceMethod(desc = "离开大厅")
	public void outHall(ISession session) {
		session.setRoom(null);
	}
	
	public void updateClientsHall() {
		if (timer == null) {
			timer = new Timer();
			timer.schedule(new TimerTask() {
				@Override
				public void run() {
					hall.board(hall);
					timer = null;
				}
			}, 1000);
		}
	}
	
	public void updateClientsRoom(BoardRoom room) {
		room.board(room);
	}
	
	@RpcServiceMethod(desc = "创建房间")
	public BattleRoom createRoom(ISession session
			, @RpcServiceMethodParameter(name = "battleConfId") String battleConfId) throws CloneNotSupportedException, RpcException {
		BattleRoom room = new BattleRoom(hall, 4, 4);
		User logined = session.getLogined();
		room.name = logined.name;
		room.battle = gameConfs.battles.get(battleConfId).clone();
		BattleRoomSeat member = new BattleRoomSeat();
		session.setRoomMember(member);
		member.avatar = logined.avatars.values().iterator().next();
		room.seats[0] = member;
		room.addSession(session);
		session.setRoom(room);
		hall.rooms.put(room.uuid, room);
		updateClientsHall();
		return room;
	}
	
	@RpcServiceMethod(desc = "进入房间")
	public BattleRoom enterRoom(ISession session
			, @RpcServiceMethodParameter(name = "roomUuid", desc = "房间ID") String roomUuid) throws RpcException {
		User logined = session.getLogined();
		BattleRoom room = hall.rooms.get(roomUuid);
		for (int i = 0; i < room.blueMax + room.redMax; i++) {
			if (room.seats[i] == null) {
				BattleRoomSeat member = room.seats[i] = new BattleRoomSeat();
				member.avatar = logined.avatars.values().iterator().next();
				session.setRoomMember(member);
				session.setRoom(room);
				updateClientsRoom(room);
				break;
			}
		}
		return room;
	}
	
	@RpcServiceMethod(desc = "修改角色")
	public void switchAvatar(ISession session
			, @RpcServiceMethodParameter(name = "avatarUuid") String avatarUuid) {
		BattleRoomSeat roomMember = session.getRoomSeat();
		roomMember.avatar = session.getLogined().avatars.get(avatarUuid);
		updateClientsRoom(session.getRoom());
	}

	@RpcServiceMethod(desc = "换位子")
	public void switchSeat(ISession session
			, @RpcServiceMethodParameter(name = "seatId") int seatId) throws RpcException {
		BattleRoomSeat seat = session.getRoomSeat();
		BattleRoom room = (BattleRoom) session.getRoom();
		if (room.seats[seatId] == null && seat != null) {
			for (int i = 0; i < room.seats.length; i++) {
				if (room.seats[i] == seat) {
					room.seats[i] = null;
					break;
				}
			}
			room.seats[seatId] = seat;
			updateClientsRoom(session.getRoom());
		}
	}

	@RpcServiceMethod(desc = "装备武器")
	public void setWeapon(ISession session
			, @RpcServiceMethodParameter(name = "avatarUuid", desc = "") String avatarUuid
			, @RpcServiceMethodParameter(name = "bagUuid", desc = "背包实例ID") String bagUuid
			, @RpcServiceMethodParameter(name = "index") int index) {
		User logined = session.getLogined();
		IBagItem bagItem = logined.bagItems.get(bagUuid);
		if (bagItem instanceof Skill) {
			logined.avatars.get(avatarUuid).addSkill((Skill) bagItem);
		}
		updateClientsRoom(session.getRoom());
	}

	@RpcServiceMethod(desc = "装备道具")
	public void setTool(ISession session
			, @RpcServiceMethodParameter(name = "avatarUuid", desc = "") String avatarUuid
			, @RpcServiceMethodParameter(name = "bagUuid", desc = "背包实例ID") String bagUuid
			, @RpcServiceMethodParameter(name = "index") int index) {
		User logined = session.getLogined();
		IBagItem bagItem = logined.bagItems.get(bagUuid);
		if (bagItem instanceof Skill) {
		}
		updateClientsRoom(session.getRoom());
	}
	
	@RpcServiceMethod(desc = "准备")
	public void ready(ISession session) throws RpcException {
		BattleRoom room = (BattleRoom) session.getRoom();
		BattleRoomSeat member = session.getRoomSeat();
		member.isReady = true;
		updateClientsRoom(room);
	}

	@RpcServiceMethod(desc = "取消准备")
	public void unready(ISession session) throws RpcException {
		BattleRoom room = (BattleRoom) session.getRoom();
		BattleRoomSeat member = session.getRoomSeat();
		member.isReady = false;
		updateClientsRoom(room);
	}
	
	@RpcServiceMethod(desc = "")
	public void switchMap(ISession session) {
//		BattleRoom room = (BattleRoom) session.getRoom();
//		room.battle = gameConfs.battles.
	}
	
	@RpcServiceMethod(desc = "开启房间(只有房主可以)")
	public void startRoom(ISession session
			, @RpcServiceMethodParameter(name = "roomUuid", desc = "房间ID") String roomUuid) {
		BattleRoom room = (BattleRoom) session.getRoom();
		hall.rooms.remove(room.uuid);
		hall.removeSession(session);
		updateClientsHall();
		Battle battle = room.battle;
		room.play();
		BattleSignalBegin beginSignal = new BattleSignalBegin();
		beginSignal.battle = battle;
		room.board(beginSignal);
	}
}
