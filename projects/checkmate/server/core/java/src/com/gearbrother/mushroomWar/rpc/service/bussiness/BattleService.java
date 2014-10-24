package com.gearbrother.mushroomWar.rpc.service.bussiness;

import java.util.Timer;
import java.util.TimerTask;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.gearbrother.mushroomWar.model.ISession;
import com.gearbrother.mushroomWar.pojo.Battle;
import com.gearbrother.mushroomWar.pojo.TaskDispatch;
import com.gearbrother.mushroomWar.pojo.World;
import com.gearbrother.mushroomWar.rpc.annotation.RpcServiceMethod;
import com.gearbrother.mushroomWar.rpc.annotation.RpcServiceMethodParameter;

/**
 * @author feng.lee
 * @create on 2013-12-30
 */
@Service
public class BattleService {
	static Logger logger = LoggerFactory.getLogger(BattleService.class);

	public BattleService() {
//		new Thread(new Runnable() {
//
//			@Override
//			public void run() {
//				while (true) {
//					long now = System.currentTimeMillis();
//					String[] keys = World.instance.runningBattles.keySet().toArray(new String[] {});
//					for (String key : keys) {
//						Battle battle = World.instance.runningBattles.get(key);
//						if (battle != null) {
//							battle.execute(now);
//						}
//					}
//				}
//			}
//		}).start();
		Timer timer = new Timer();
		timer.schedule(new TimerTask() {
			@Override
			public void run() {
				long now = System.currentTimeMillis();
				String[] keys = World.instance.runningBattles.keySet().toArray(new String[] {});
				for (String key : keys) {
					Battle battle = World.instance.runningBattles.get(key);
					if (battle != null) {
						battle.execute(now);
					}
				}
			}
		}, 0, 100);
	}

	@RpcServiceMethod(desc = "重新连接战场")
	public Battle reload(ISession session) {
		return null;
	}
	
	@RpcServiceMethod(desc = "派遣")
	public void dispatch(ISession session
			, @RpcServiceMethodParameter(name = "confId") String confId) {
		new TaskDispatch(session.getPlayer(), System.currentTimeMillis(), confId,  0, 0);
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
