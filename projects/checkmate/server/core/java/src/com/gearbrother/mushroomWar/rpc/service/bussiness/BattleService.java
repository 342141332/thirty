package com.gearbrother.mushroomWar.rpc.service.bussiness;

import java.util.Iterator;
import java.util.Timer;
import java.util.TimerTask;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.gearbrother.mushroomWar.model.ISession;
import com.gearbrother.mushroomWar.pojo.Battle;
import com.gearbrother.mushroomWar.pojo.BattleItemBuilding;
import com.gearbrother.mushroomWar.pojo.BattlePropertyEvent;
import com.gearbrother.mushroomWar.pojo.BattleRoom;
import com.gearbrother.mushroomWar.pojo.GameConf;
import com.gearbrother.mushroomWar.pojo.TaskSkill;
import com.gearbrother.mushroomWar.pojo.TaskTroopDispatch;
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
	
	private GameConf _conf;
	public GameConf getConf() {
		return _conf;
	}
	public void setConf(GameConf newValue) {
		_conf = newValue;
	}
	
	public BattleService() {
		Timer timer = new Timer();
		timer.schedule(new TimerTask() {
			@Override
			public void run() {
				long now = System.currentTimeMillis();
				for (Iterator<String> iterator = World.instance.battles.keySet().iterator(); iterator.hasNext();) {
					String instanceId = (String) iterator.next();
					World.instance.battles.get(instanceId).execute(now);
				}
			}
		}, 0, 50);
	}

	@RpcServiceMethod(desc = "重新连接战场")
	public Battle reload(ISession session) {
		return null;
	}
	
	@RpcServiceMethod(desc = "派遣")
	public void dispatch(ISession session
			, @RpcServiceMethodParameter(name = "sourceBuildingInstanceId", desc = "初始建筑") String sourceBuildingInstanceId
			, @RpcServiceMethodParameter(name = "targetBuildingInstanceId", desc = "目标建筑") String targetBuildingInstanceId) {
		BattleRoom room = session.getRoomSeat().getRoom();
		long current = System.currentTimeMillis();
		BattleItemBuilding sourceBuilding = (BattleItemBuilding) room.battle.items.get(sourceBuildingInstanceId);
		if (sourceBuilding.owner != session.getRoomSeat())
			return;

		room.battle.execute(current);
		BattleItemBuilding targetBuilding = (BattleItemBuilding) room.battle.items.get(targetBuildingInstanceId);
		if (sourceBuilding.dispatch != null) {
			sourceBuilding.dispatch.updateExecuteTime(0, null);
		}
		sourceBuilding.dispatch = new TaskTroopDispatch(current, 300, sourceBuilding, targetBuilding, 10);
		sourceBuilding.dispatch.updateExecuteTime(sourceBuilding.dispatch.lastIntervalTime + sourceBuilding.dispatch.interval, room.battle);
		room.board(new BattlePropertyEvent(BattlePropertyEvent.TYPE_UPDATE, room.battle));
	}
	
	@RpcServiceMethod(desc = "")
	public void upgrade(ISession session
			, @RpcServiceMethodParameter(name = "buildingInstanceUuid") String buildingInstanceId) {
		BattleRoom room = session.getRoomSeat().getRoom();
		BattleItemBuilding building = (BattleItemBuilding) room.battle.items.get(buildingInstanceId);
		building.cartoon = "static/asset/avatar/house002.swf";
		building.settledHero = session.getRoomSeat().choosedHeroes[0];
		room.board(new BattlePropertyEvent(BattlePropertyEvent.TYPE_UPDATE, building));
		long currentTimeMillis = System.currentTimeMillis();
		TaskSkill skillTask = building.skillTask = new TaskSkill(currentTimeMillis, 1100);
		skillTask.battle = room.battle;
		skillTask.hero = building;
		building.skillTask.updateExecuteTime(currentTimeMillis + 1100, building.getBattle());
	}

//
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
