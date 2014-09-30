package com.gearbrother.mushroomWar.pojo;

import java.text.SimpleDateFormat;
import java.util.Iterator;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.gearbrother.mushroomWar.util.GMathUtil;

public class TaskDispatch extends TaskInterval {
	static Logger logger = LoggerFactory.getLogger(TaskDispatch.class);

	static SimpleDateFormat format = new SimpleDateFormat("HH:mm:ss.SSS");
	
	public BattleItemBuilding sourceBuilding;
	
	public BattleItemBuilding targetBuilding;
	
	public int maxNum;

	public TaskDispatch(Battle battle, long executeTime, long interval, BattleItemBuilding sourceBuilding, BattleItemBuilding targetBuilding, int maxNum) {
		super(battle, executeTime, interval);

		this.sourceBuilding = sourceBuilding;
		this.targetBuilding = targetBuilding;
		this.maxNum = maxNum;
	}

	@Override
	public void execute(long now) {
		for (Iterator<BattleItemSoilder> iterator = sourceBuilding.settledTroops.iterator(); iterator.hasNext();) {
			BattleItemSoilder dispatchedTroop = (BattleItemSoilder) iterator.next();
			iterator.remove();
			long costTime = (long) (50L * Math.sqrt(Math.pow(dispatchedTroop.x - targetBuilding.x, 2) + Math.pow(dispatchedTroop.y - targetBuilding.y, 2)));
			TaskArrive arrive = new TaskArrive(battle, now + costTime, now
<<<<<<< HEAD
							, dispatchedTroop.x, dispatchedTroop.y, targetBuilding.x + GMathUtil.random(37, -37), targetBuilding.y + GMathUtil.random(27)
							, dispatchedTroop, targetBuilding, targetBuilding);
			dispatchedTroop.setTask(arrive);
=======
							, dispatchedTroop.x, dispatchedTroop.y, targetBuilding.x + GMathUtil.random(50, -50), targetBuilding.y + GMathUtil.random(17)
							, dispatchedTroop, targetBuilding, targetBuilding);
			dispatchedTroop.task = arrive;
			dispatchedTroop.building = null;
>>>>>>> branch 'master' of https://github.com/342141332/thirty.git
			battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, dispatchedTroop));
		}
	}
}
