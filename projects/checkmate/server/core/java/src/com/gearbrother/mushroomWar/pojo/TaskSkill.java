package com.gearbrother.mushroomWar.pojo;

import java.util.HashMap;
import java.util.Map;

import com.fasterxml.jackson.databind.JsonNode;
import com.gearbrother.mushroomWar.util.GMathUtil;

public class TaskSkill extends TaskInterval {
	static public final Map<String, ISkillHandler> skillHandlers = new HashMap<String, TaskSkill.ISkillHandler>();
	{
		skillHandlers.put("slow"
				, new ISkillHandler() {
					
					@Override
					public boolean handle(JsonNode params) {
						return true;
					}
				}
			);
	}

	public Battle battle;
	
	public BattleItemBuilding hero;
	
	public Skill skill;
	
	public TaskSkill(long lastIntervalTime, long interval) {
		super(lastIntervalTime, interval);
	}

	@Override
	protected long doInterval(long lastIntervalTime, long now) {
		for (; lastIntervalTime < now; lastIntervalTime += interval) {
//			if ("attack".equals(skill.getLevel().remoteMethod)) {
//			for (int i = 0; i < 10; i++) {
				Map<String, BattleItem> items = battle.getItems(BattleItem.class);
				if (items != null && items.keySet().size() > 0) {
					String choosed = (String) GMathUtil.random(items.keySet().toArray(new String[]{}));
					BattleItem armys = items.get(choosed);
					armys.setBattle(null);
					armys.move.updateExecuteTime(0, null);
					battleRoom.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_REMOVED_BY_SKILL, armys));
				}
//			}
//			}
				battleRoom.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_SKILL, hero));
		}
		return now;
	}
	
	interface ISkillHandler {
		boolean handle(JsonNode params);
	}
}
