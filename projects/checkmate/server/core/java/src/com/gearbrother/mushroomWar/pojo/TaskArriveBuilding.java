package com.gearbrother.mushroomWar.pojo;

import java.text.SimpleDateFormat;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;
import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BattleItemSoilderProtocol;

@RpcBeanPartTransportable
public class TaskArriveBuilding extends Task {
	static Logger logger = LoggerFactory.getLogger(TaskArriveBuilding.class);

	static SimpleDateFormat format = new SimpleDateFormat("HH:mm:ss.SSS");
	
	@RpcBeanProperty(desc = "")
	public long startTime;
	
	@RpcBeanProperty(desc = "")
	public long endTime;
	
	@RpcBeanProperty(desc = "")
	public int startX;
	
	@RpcBeanProperty(desc = "")
	public int startY;
	
	@RpcBeanProperty(desc = "")
	public int targetX;

	@RpcBeanProperty(desc = "")
	public int targetY;
	
	public BattleItemSoilder behavior;
	
	public BattleItemBuilding building;
	
	public TaskArriveBuilding(Battle battle, long executeTime, long startTime
			, int startX, int startY, int endX, int endY
			, BattleItemSoilder behavior, BattleItemBuilding building) {
		super(battle, executeTime);

		this.startTime = startTime;
		this.endTime = executeTime;
		this.startX = startX;
		this.startY = startY;
		this.targetX = endX;
		this.targetY = endY;
		this.behavior = behavior;
		this.building = building;
	}

	@Override
	public void execute(long now) {
		logger.debug("arrive building");
		behavior.setTask(null);
		behavior.x = targetX;
		behavior.y = targetY;
		building.restingSoilders.add(behavior);
		BattleItemSoilderProtocol soilderProto = new BattleItemSoilderProtocol();
		soilderProto.setInstanceId(behavior.instanceId);
		soilderProto.setTask(behavior.getTask());
		battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, soilderProto));
		if (building.defense == null)
			building.defense = new TaskDefense(battle, now + 100, building);
		else if (!building.defense.getIsInQueue())
			building.defense.setExecuteTime(now + 100);
	}

	@Override
	public void halt() {
		super.halt();

		long current = System.currentTimeMillis();
		double progress = Math.min(1, (current - startTime) / (endTime - startTime));
		behavior.x = (int) ((targetX - startX) * progress + startX);
		behavior.y = (int) ((targetY - startY) * progress + startY);
	}
}
