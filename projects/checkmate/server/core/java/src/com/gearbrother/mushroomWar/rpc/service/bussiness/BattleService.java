package com.gearbrother.mushroomWar.rpc.service.bussiness;

import java.util.Map;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.gearbrother.mushroomWar.model.ISession;
import com.gearbrother.mushroomWar.pojo.Battle;
import com.gearbrother.mushroomWar.pojo.BattleForce;
import com.gearbrother.mushroomWar.pojo.BattleItem;
import com.gearbrother.mushroomWar.pojo.BattleRoom;
import com.gearbrother.mushroomWar.pojo.BattleRoomSeatCharacter;
import com.gearbrother.mushroomWar.pojo.Character2;
import com.gearbrother.mushroomWar.pojo.PropertyEvent;
import com.gearbrother.mushroomWar.pojo.TaskFoward;
import com.gearbrother.mushroomWar.pojo.World;
import com.gearbrother.mushroomWar.rpc.annotation.RpcServiceMethod;
import com.gearbrother.mushroomWar.rpc.annotation.RpcServiceMethodParameter;
import com.gearbrother.mushroomWar.util.GMathUtil;

/**
 * @author feng.lee
 * @create on 2013-12-30
 */
@Service
public class BattleService {
	static Logger logger = LoggerFactory.getLogger(BattleService.class);

	private Map<String, BattleRoom> _runningBattles;

	public BattleService() {
		_runningBattles = World.instance.runningBattles;
		new Thread(new Runnable() {
			
			@Override
			public void run() {
				while (true) {
					long now = System.currentTimeMillis();
					for (BattleRoom room : _runningBattles.values()) {
						room.battle.execute(now);
					}
				}
			}
		}).start();
//		Timer timer = new Timer();
//		timer.schedule(new TimerTask() {
//			@Override
//			public void run() {
//				long now = System.currentTimeMillis();
//				for (BattleRoom room : _runningBattles.values()) {
//					room.battle.execute(now);
//				}
//			}
//		}, 0, 100);
	}

	@RpcServiceMethod(desc = "重新连接战场")
	public Battle reload(ISession session) {
		return null;
	}

	@RpcServiceMethod(desc = "派遣")
	public void dispatch(ISession session
			, @RpcServiceMethodParameter(name = "x") int x
			, @RpcServiceMethodParameter(name = "y") int y
			, @RpcServiceMethodParameter(name = "confId") String confId) {
		BattleRoomSeatCharacter seatCharacter = session.getSeat().choosedSoilders.get(confId);
		if (seatCharacter.num == 0)
			return;

		long current = System.currentTimeMillis();
		Battle battle = session.getSeat().room.battle;
		BattleForce force = session.getSeat().force;
		int[] forward = force.forward;
		//"born"	[0, 0, 9, 1],
		//"forward"	[0, 1],
		int[] bornRect = force.born;
		int[] born = new int[] {
			forward[0] == 1 ? bornRect[2] : (forward[0] == -1 ? bornRect[0] : Math.max(bornRect[0], Math.min(x, bornRect[2]))),
			forward[1] == 1 ? bornRect[3] : (forward[1] == -1 ? bornRect[1] : Math.max(bornRect[1], Math.min(y, bornRect[3])))
		};
		BattleItem dispatchedTroop = new BattleItem();
		dispatchedTroop.instanceId = UUID.randomUUID().toString();
		dispatchedTroop.character = seatCharacter.character.clone();
		dispatchedTroop.setXY(x, y);
		if (forward[0] == -1) {
			for (x = born[0]; x >= bornRect[0]; x--) {
				boolean isCollisioned = dispatchedTroop.checkCollision(x, born[1], battle);
				if (x == born[0] && isCollisioned) {
					return false;
				} else if (isCollisioned) {
					//set position
				}
			}
		} else if (forward[0] == 1) {
			
		} else if (forward[1] == -1) {
			
		} else if (forward[1] == 1) {
			
		}
		dispatchedTroop.hp = dispatchedTroop.maxHp = 7;
		dispatchedTroop.attackDamage = GMathUtil.random(3, 1);
		dispatchedTroop.layer = "over";
		dispatchedTroop.setBattle(battle);
		dispatchedTroop.owner = session.getSeat();
		dispatchedTroop.setTask(new TaskFoward(battle, current + 1000, 3000L, forwardX, forwardY, dispatchedTroop));
		battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_ADD, dispatchedTroop));
	}

	@RpcServiceMethod(desc = "")
	public void upgrade(ISession session
			, @RpcServiceMethodParameter(name = "buildingInstanceUuid") String buildingInstanceId) {
//		building.cartoon = "static/asset/avatar/house002.swf";
//		building.settledHero = session.getSeat().choosedHeroes[0];
//		TaskSkill skillTask = building.skillTask = new TaskSkill(currentTimeMillis, 1100);
//		skillTask.battle = room.battle;
//		skillTask.hero = building;
//		building.skillTask.updateExecuteTime(currentTimeMillis + 1100, room);
	}

//	@RpcServiceMethod(desc = "使用技能")
//	public void skillUse(ISession session
//			, @RpcServiceMethodParameter(name = "skillIndex") int skillIndex
//			, @RpcServiceMethodParameter(name = "argus") JsonNode params) throws Throwable {
//		BattleRoom battleRoom = (BattleRoom) session.getRoom();
//		Battle battle = battleRoom.battle;
//		BattleItemUser loginedUser = (BattleItemUser) battle.items.get(session.getLogined().uuid);
//		Skill skill = loginedUser.skills.get(skillIndex);
//		SkillLevel level = skill.getLevel();
//		long currentTimeMillis = System.currentTimeMillis();
//		if (skill.lastUseTime + level.cooldown < currentTimeMillis && (skill.num == - 1 || skill.num > 0)) {
//			doSkill(session, skill, params);
//		}
//	}
//
//	private void doSkill(ISession session, Skill skill, JsonNode params) throws Throwable {
//		BattleRoom battleRoom = (BattleRoom) session.getRoom();
//		Battle battle = battleRoom.battle;
//		BattleItemUser loginedUser = (BattleItemUser) battle.items.get(session.getLogined().uuid);
//		SkillLevel skillLevel = skill.getLevel();
//		boolean res = skillHandlers.get(skillLevel.remoteMethod).handle(session, skill, params);
//		if (res) {
//			skill.lastUseTime = System.currentTimeMillis();
//			if (skill.num == -1) {
//				//do nothing
//			} else {
//				skill.num--;
//			}
//			if (skill.num == 0)
//				loginedUser.removeSkill(skill);
//			BattleSignalSkillUse skillUse = new BattleSignalSkillUse();
//			skillUse.userUuid = loginedUser.instanceId;
//			skillUse.skill = skill;
//			session.getRoom().board(skillUse);
//			
//			//notify
//			BattleItemUserProtocol userProto = new BattleItemUserProtocol();
//			userProto.setInstanceId(loginedUser.instanceId);
//			userProto.setSkills(loginedUser.skills);
//			session.send(new BattleSignalUserUpdate(userProto));
//		}
//	}
}
