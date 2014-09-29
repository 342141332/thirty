package com.gearbrother.mushroomWar.pojo;

import java.util.ArrayList;
import java.util.List;

import com.gearbrother.mushroomWar.util.GMathUtil;

public class TaskDefense extends Task {
	public BattleItemBuilding major;

	public TaskDefense(Battle battle, long executeTime, BattleItemBuilding major) {
		super(battle, executeTime);
		
		this.major = major;
	}

	@Override
	public void execute(long now) {
		List<BattleItemSoilder> defenders = new ArrayList<BattleItemSoilder>();
		List<BattleItemSoilder> enemies = new ArrayList<BattleItemSoilder>();
		for (BattleItemSoilder soilder : major.settledTroops) {
			if (soilder.owner == major.owner) {
				defenders.add(soilder);
			} else {
				enemies.add(soilder);
			}
		}
		while (defenders.size() > 0) {
			BattleItemSoilder defender = defenders.remove(0);
			if (defender.task == null && (defender.focusTarget == null || defender.focusTarget.hp == 0)) {
				if (enemies.size() > 0) {
					BattleItemSoilder enemy = enemies.remove(0);
					defender.task = new TaskArrive(battle, now + 100, now, defender.x, defender.y, enemy.x + GMathUtil.random(20, -20)
							, enemy.y + GMathUtil.random(7, -7), defender, major, enemy);
					battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, enemy));
					defender.focusTarget = enemy;
					enemy.focusTarget = defender;
				}
			}
		}
//		for (int i = 0; i < enemies.size(); i++) {
//			BattleItemSoilder enemy = enemies.get(i % defenders.size());
//			if (defenders.size() > 0) {
//				BattleItemSoilder defender = defenders.remove(0);
//				defender.task = new TaskArrive(battle, now + 100, now, defender.x, defender.y, enemy.x + GMathUtil.random(20, -20)
//						, enemy.y + GMathUtil.random(7, -7), defender, major, enemy);
//				defender.focusTarget = enemy;
//				enemy.focusTarget = defender;
//			} else {
//				return;
//			}
//		}
	}
}
