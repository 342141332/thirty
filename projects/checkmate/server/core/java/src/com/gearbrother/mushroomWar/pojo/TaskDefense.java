package com.gearbrother.mushroomWar.pojo;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.gearbrother.mushroomWar.pojo.BattleItemBuilding.BattleField;
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
		List<BattleItemSoilder> restingSoildersA = new ArrayList<BattleItemSoilder>();
		List<BattleItemSoilder> restingSoildersB = new ArrayList<BattleItemSoilder>();
		for (BattleItemSoilder soilder : major.restingSoilders) {
			if (major.owner == soilder.owner)
				restingSoildersA.add(soilder);
			else
				restingSoildersB.add(soilder);
		}
		//check fields
		for (Iterator<BattleField> iterator = major.fields.iterator(); iterator.hasNext();) {
			BattleField field = iterator.next();
			List<BattleItemSoilder> fieldA = new ArrayList<BattleItemSoilder>();
			List<BattleItemSoilder> fieldB = new ArrayList<BattleItemSoilder>();
			for (BattleItemSoilder soilder : field.soilders) {
				if (soilder.owner == major.owner) {
					fieldA.add(soilder);
				} else {
					fieldB.add(soilder);
				}
			}
			int min = Math.min(fieldA.size(), fieldB.size());
			if (min > 0) {
				restingSoildersA.addAll(fieldA.subList(1, fieldA.size() - 1));
				restingSoildersB.addAll(fieldB.subList(1, fieldB.size() - 1));
			} else {
				restingSoildersA.addAll(fieldA);
				restingSoildersB.addAll(fieldB);
				iterator.remove();
			}
		}
		int min = Math.min(restingSoildersA.size(), restingSoildersB.size());
		for (int i = 0; i < min; i++) {
			BattleField field = new BattleField(major.x + GMathUtil.random(50, -50), major.y + GMathUtil.random(17), major);
			
			BattleItemSoilder soilderA = restingSoildersA.get(i);
			major.restingSoilders.remove(soilderA);
			if (soilderA.inField != null)
				soilderA.inField.soilders.remove(soilderA);
			if (soilderA.getTask() != null)
				soilderA.getTask().halt();
			soilderA.setTask(new TaskArriveField(battle, now + 100, now, soilderA.x, soilderA.y, field.x - 10, field.y, soilderA, field));
			battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, soilderA, "forward"));

			BattleItemSoilder soilderB = restingSoildersB.get(i);
			major.restingSoilders.remove(soilderB);
			if (soilderB.inField != null)
				soilderB.inField.soilders.remove(soilderB);
			if (soilderB.getTask() != null)
				soilderB.getTask().halt();
			soilderB.setTask(new TaskArriveField(battle, now + 100, now, soilderB.x, soilderB.y, field.x + 10, field.y, soilderB, field));
			battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, soilderB, "forward"));
		}
	}
}
