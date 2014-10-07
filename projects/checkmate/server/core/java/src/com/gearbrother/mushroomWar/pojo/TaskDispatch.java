package com.gearbrother.mushroomWar.pojo;

import java.text.SimpleDateFormat;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.gearbrother.mushroomWar.util.GMathUtil;

public class TaskDispatch extends TaskInterval {
	static Logger logger = LoggerFactory.getLogger(TaskDispatch.class);

	static SimpleDateFormat format = new SimpleDateFormat("HH:mm:ss.SSS");
	
	public BattleItemBuilding sourceBuilding;
	
	public BattleItemBuilding targetBuilding;
	
	public int maxNum;

	public TaskDispatch(Battle battle, long executeTime, long interval
			, BattleItemBuilding sourceBuilding, BattleItemBuilding targetBuilding, int maxNum) {
		super(battle, executeTime, interval);

		this.sourceBuilding = sourceBuilding;
		this.targetBuilding = targetBuilding;
		this.maxNum = maxNum;
	}

	@Override
	public void execute(long now) {
		for (BattleItemSoilder dispatchedTroop : sourceBuilding.restingSoilders) {
			int toX = targetBuilding.x + GMathUtil.random(7, -7);
			int toY = targetBuilding.y + GMathUtil.random(7);
			long costTime = (long) (50L * Math.sqrt(Math.pow(dispatchedTroop.x - toX, 2) + Math.pow(dispatchedTroop.y - toY, 2)));
			dispatchedTroop.setTask(new TaskArriveBuilding(battle, now + costTime, now
					, dispatchedTroop.x, dispatchedTroop.y, toX, toY
					, dispatchedTroop, targetBuilding));
			battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, dispatchedTroop));
		}
		sourceBuilding.restingSoilders.clear();
	}
}
