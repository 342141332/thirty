package com.gearbrother.mushroomWar.pojo;

import java.text.SimpleDateFormat;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;

@RpcBeanPartTransportable
public class TaskDispatch extends TaskInterval {
	static Logger logger = LoggerFactory.getLogger(TaskDispatch.class);

	static SimpleDateFormat format = new SimpleDateFormat("HH:mm:ss.SSS");
	
	public BattleItemBuilding sourceBuilding;
	@RpcBeanProperty(desc = "")
	public String getSourceBuildingId() {
		return sourceBuilding.instanceId;
	}
	
	public BattleItemBuilding targetBuilding;
	@RpcBeanProperty(desc = "")
	public String getTargetBuildingId() {
		return targetBuilding.instanceId;
	}
	
	@RpcBeanProperty(desc = "")
	public int maxNum;

	public TaskDispatch(long lastIntervalTime, long interval
			, BattleItemBuilding sourceBuilding, BattleItemBuilding targetBuilding, int maxNum) {
		super(lastIntervalTime, interval);

		this.sourceBuilding = sourceBuilding;
		this.targetBuilding = targetBuilding;
		this.maxNum = maxNum;
	}

	@Override
	protected long doInterval(long lastIntervalTime, long now) {
		for (; lastIntervalTime < now; lastIntervalTime += interval) {
			if (sourceBuilding.troops.size() > 0) {
				BattleItemSoilder dispatchedTroop = sourceBuilding.troops.first();
				sourceBuilding.troops.remove(dispatchedTroop);
				long costTime = (long) (50L * Math.sqrt(Math.pow(sourceBuilding.x - targetBuilding.x, 2) + Math.pow(sourceBuilding.y - targetBuilding.y, 2)));
				dispatchedTroop.currentAction = new BattleItemActionMove(lastIntervalTime, lastIntervalTime + costTime, sourceBuilding, targetBuilding, 0, 200L, 0L, 0L);;
				dispatchedTroop.owner = sourceBuilding.owner;
				TaskArrive moveTask = new TaskArrive(lastIntervalTime, sourceBuilding, targetBuilding, dispatchedTroop);
				moveTask.updateExecuteTime(lastIntervalTime + costTime, battleRoom);
				dispatchedTroop.move = moveTask;
				battleRoom.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, dispatchedTroop));
			}
		}
		return now;
	}
}
