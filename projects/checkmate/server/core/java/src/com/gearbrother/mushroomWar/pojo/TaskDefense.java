package com.gearbrother.mushroomWar.pojo;

import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.gearbrother.mushroomWar.util.GMathUtil;

public class TaskDefense extends Task {
	static Logger logger = LoggerFactory.getLogger(TaskDefense.class);

	public BattleItemBuilding major;

	public TaskDefense(Battle battle, long executeTime, BattleItemBuilding major) {
		super(battle, executeTime);
		
		this.major = major;
	}

	@Override
	public void execute(long now) {
		logger.debug("defense");
		List<BattleItemSoilder> defenders = new ArrayList<BattleItemSoilder>();
		List<BattleItemSoilder> enemies = new ArrayList<BattleItemSoilder>();
		for (BattleItemSoilder soilder : major.settledTroops) {
			if (soilder.owner == major.owner) {
				defenders.add(soilder);
			} else {
				enemies.add(soilder);
			}
		}
		int min = Math.max(1, defenders.size() > enemies.size() ? enemies.size() : defenders.size());
		for (int j = 0; j < defenders.size(); j++) {
			BattleItemSoilder defender = defenders.get(j);
			if (defender.getTask() == null && enemies.size() > 0) {
				BattleItemSoilder enemy = enemies.get(j % min);
				defender.focusTarget = defender;
				defender.setTask(new TaskArrive(battle, now + 2100, now, defender.x, defender.y
						, enemy.x + GMathUtil.random(13, 7), enemy.y + GMathUtil.random(7, -7), defender, major, enemy));
				battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, defender));
				if (enemy.getTask() == null) {
					enemy.focusTarget = defender;
					enemy.setTask(new TaskAttack(battle, now + 3000, 2100, enemy, defender, major));
					battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, enemy));
				}
			}
		}
		for (int j = 0; j < enemies.size(); j++) {
			BattleItemSoilder enemy = enemies.get(j);
			if (enemy.getTask() == null && defenders.size() > 0) {
				BattleItemSoilder defender = defenders.get(j % min);
				enemy.focusTarget = enemy;
				enemy.setTask(new TaskArrive(battle, now + 2100, now, enemy.x, enemy.y
						, defender.x + GMathUtil.random(13, 7), defender.y + GMathUtil.random(7, -7), enemy, major, defender));
				battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, enemy));
				if (defender.getTask() == null) {
					defender.focusTarget = enemy;
					defender.setTask(new TaskAttack(battle, now + 3000, 2100, defender, enemy, major));
					battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, defender));
				}
			}
		}
		
		major.defense = null;
	}
}
