package com.gearbrother.mushroomWar.pojo;

import java.text.SimpleDateFormat;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.gearbrother.mushroomWar.pojo.BattleItemBuilding.BattleField;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;
import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BattleItemSoilderProtocol;

@RpcBeanPartTransportable
public class TaskArriveField extends Task {
	static Logger logger = LoggerFactory.getLogger(TaskArriveField.class);

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
	
	public TaskArriveField(Battle battle, long executeTime, long startTime
			, int startX, int startY, int endX, int endY
			, BattleItemSoilder behavior, BattleField field) {
		super(battle, executeTime);

		this.startTime = startTime;
		this.endTime = executeTime;
		this.startX = startX;
		this.startY = startY;
		this.targetX = endX;
		this.targetY = endY;
		this.behavior = behavior;
		this.behavior.inField = field;
		this.behavior.inField.soilders.add(behavior);
	}

	@Override
	public void execute(long now) {
		if (TaskAttack.deads.containsKey(behavior.instanceId))
			throw new Error("f");
		logger.debug("{} arrive field", behavior.instanceId);
		behavior.x = targetX;
		behavior.y = targetY;
		BattleItemSoilderProtocol soilderProto = new BattleItemSoilderProtocol();
		soilderProto.setInstanceId(behavior.instanceId);
		soilderProto.setTask(behavior.getTask());
		battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, soilderProto));
		behavior.setTask(new TaskAttack(battle, now + 100, 2300, behavior));
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
