package com.gearbrother.mushroomWar.pojo;

import java.text.SimpleDateFormat;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;

public class TaskArrive extends Task {
	static Logger logger = LoggerFactory.getLogger(TaskArrive.class);

	static SimpleDateFormat format = new SimpleDateFormat("HH:mm:ss.SSS");
	
	public BattleItemBuilding targetBuilding;
	@RpcBeanProperty(desc = "")
	public String getTargetBuildingId() {
		return targetBuilding.instanceId;
	}
	
	public BattleItemBuilding sourceBuilding;
	@RpcBeanProperty(desc = "")
	public String getSourceBuildingId() {
		return targetBuilding.instanceId;
	}
	
	@RpcBeanProperty(desc = "")
	public long startTime;
	
	@RpcBeanProperty(desc = "")
	public BattleItemSoilder soilder;
	
	public TaskArrive(long startTime, BattleItemBuilding sourceBuilding, BattleItemBuilding targetBuilding, BattleItemSoilder soilder) {
		super();

		this.startTime = startTime;
		this.sourceBuilding = sourceBuilding;
		this.targetBuilding = targetBuilding;
		this.soilder = soilder;
	}

	@Override
	public void execute(long executeTime) {
		logger.debug("arrive {}:{} > {}:{}");
		if (soilder.owner == targetBuilding.owner) {
		} else {
			TaskAttack attack = new TaskAttack(executeTime, 1100, soilder, targetBuilding);
			attack.updateExecuteTime(executeTime + 1100, battleRoom);
			soilder.currentAction = attack;
			battleRoom.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, soilder));
		}
	}
}
