package com.gearbrother.mushroomWar.rpc.service.bussiness;

import java.util.Iterator;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.gearbrother.mushroomWar.model.ISession;
import com.gearbrother.mushroomWar.pojo.Battle;
import com.gearbrother.mushroomWar.pojo.BattleForce;
import com.gearbrother.mushroomWar.pojo.BattleItem;
import com.gearbrother.mushroomWar.pojo.BattlePlayer;
import com.gearbrother.mushroomWar.pojo.BattleSignalBegin;
import com.gearbrother.mushroomWar.pojo.CharacterModel;
import com.gearbrother.mushroomWar.pojo.GameConf;
import com.gearbrother.mushroomWar.pojo.Hall;
import com.gearbrother.mushroomWar.pojo.IBagItem;
import com.gearbrother.mushroomWar.pojo.PropertyEvent;
import com.gearbrother.mushroomWar.pojo.Skill;
import com.gearbrother.mushroomWar.pojo.User;
import com.gearbrother.mushroomWar.pojo.World;
import com.gearbrother.mushroomWar.rpc.annotation.RpcServiceMethod;
import com.gearbrother.mushroomWar.rpc.annotation.RpcServiceMethodParameter;

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
	}

	public RoomService() {
	}

	@RpcServiceMethod(desc = "进入大厅")
	public Hall enterHall(ISession session) {
		World.instance.hall.observer.addObserver(session);
		session.setEnteredHall(World.instance.hall);
		return World.instance.hall;
	}

	@RpcServiceMethod(desc = "离开大厅")
	public void outHall(ISession session) {
		World.instance.hall.observer.deleteObserver(session);
		session.setEnteredHall(null);
	}

	@RpcServiceMethod(desc = "创建房间")
	public Battle createRoom(ISession session
			, @RpcServiceMethodParameter(name = "battleConfId") String battleConfId) {
		session.getEnteredHall().observer.deleteObserver(session);
		session.setEnteredHall(null);

		User logined = session.getLogined();
		Battle battle = gameConfs.battles.get(battleConfId).clone();
		battle.instanceUuid = UUID.randomUUID().toString();
		battle.name = logined.name;
		battle.observer.addObserver(session);
		BattlePlayer player = new BattlePlayer(battle, logined);
		session.setPlayer(player);
		String forceId = battle.forces.keySet().iterator().next();
		player.force = battle.forces.get(forceId);
		player.force.players.add(session.getPlayer());
		World.instance.hall.preparingBattles.put(battle.instanceUuid, battle);
		World.instance.hall.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_ADD, battle));
		return battle;
	}

	@RpcServiceMethod(desc = "进入房间")
	public Battle enterRoom(ISession session,
			@RpcServiceMethodParameter(name = "roomUuid", desc = "房间ID") String roomUuid) {
		session.getEnteredHall().observer.deleteObserver(session);
		session.setEnteredHall(null);

		User logined = session.getLogined();
		Battle battle = World.instance.hall.preparingBattles.get(roomUuid);
		battle.observer.addObserver(session);
		for (Iterator<String> iterator = battle.forces.keySet().iterator(); iterator.hasNext();) {
			String id = (String) iterator.next();
			BattleForce force = battle.forces.get(id);
			if (force.maxPlayer > force.players.size()) {
				BattlePlayer player = new BattlePlayer(battle, logined);
				player.force = force;
				session.setPlayer(player);
				force.players.add(player);
				battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_ADD, player));
				return battle;
			}
		}
		return null;
	}

	@RpcServiceMethod(desc = "离开房间")
	public void outRoom(ISession session) {
		BattlePlayer player = session.getPlayer();
		session.setPlayer(null);
		player.force.players.remove(player);
		player.battle.observer.deleteObserver(session);
		player.battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_REMOVE, player));
	}

	@RpcServiceMethod(desc = "换位子")
	public void switchForce(ISession session
			, @RpcServiceMethodParameter(name = "forceId") String forceId) {
		BattlePlayer player = session.getPlayer();
		BattleForce force = session.getPlayer().battle.forces.get(forceId);
		if (force.players.contains(player) == false && force.maxPlayer > force.players.size()) {
			player.force.players.remove(player);
			session.getPlayer().battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_REMOVE, player));
			force.players.add(player);
			player.force = force;
			session.getPlayer().battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_ADD, player));
		}
	}

	@RpcServiceMethod(desc = "装备英雄")
	public void addHero(ISession session
			, @RpcServiceMethodParameter(name = "heroInstanceUuid", desc = "") String heroInstanceUuid) {
		BattlePlayer player = session.getPlayer();
		CharacterModel hero = session.getLogined().heroes.get(heroInstanceUuid);
		if (hero != null && !player.choosedHeroes.contains(hero) && player.choosedHeroes.size() < 3) {
			player.choosedHeroes.add(hero);
			session.getPlayer().battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, player));
		}
	}
	
	@RpcServiceMethod(desc = "删除英雄")
	public void removeHero(ISession session
			, @RpcServiceMethodParameter(name = "heroInstanceUuid") String heroInstanceUuid) {
		BattlePlayer player = session.getPlayer();
		for (Iterator<CharacterModel> iterator = player.choosedHeroes.iterator(); iterator.hasNext();) {
			CharacterModel hero = (CharacterModel) iterator.next();
			if (hero.uuid.equals(heroInstanceUuid)) {
				iterator.remove();
				session.getPlayer().battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, player));
				return;
			}
		}
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
	public void ready(ISession session) {
		BattlePlayer player = session.getPlayer();
		player.isReady = true;
		player.battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, player));
		Battle battle = player.battle;
		for (Iterator<String> iterator = battle.forces.keySet().iterator(); iterator.hasNext();) {
			String id = (String) iterator.next();
			BattleForce force = battle.forces.get(id);
			int hp = 0;
			for (BattlePlayer player2 : force.players) {
				hp += player2.hp;
			}
			force.maxHp = force.hp = hp;
		}
		for (Iterator<String> iterator = player.battle.items.keySet().iterator(); iterator.hasNext();) {
			String uuid = (String) iterator.next();
			BattleItem item = player.battle.items.get(uuid);
			if (item.isHomeBuilding) {
				item.maxHp = item.hp = item.force.hp;
			}
		}
		player.battle.state = Battle.STATE_PLAYING;
		player.battle.observer.notifySessions(new BattleSignalBegin(player.battle));
		World.instance.runningBattles.put(player.battle.instanceUuid, player.battle);
		World.instance.hall.preparingBattles.remove(player.battle);
		World.instance.hall.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_REMOVE, player.battle));
	}

	@RpcServiceMethod(desc = "取消准备")
	public void unready(ISession session) {
		BattlePlayer player = session.getPlayer();
		player.isReady = false;
		session.getPlayer().battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, player));
	}

	@RpcServiceMethod(desc = "")
	public void switchMap(ISession session) {
		// BattleRoom room = (BattleRoom) session.getRoom();
		// room.battle = gameConfs.battles.
	}
}
