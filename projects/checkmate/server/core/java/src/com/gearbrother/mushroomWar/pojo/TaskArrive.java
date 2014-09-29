package com.gearbrother.mushroomWar.pojo;

import java.text.SimpleDateFormat;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;
import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BattleItemSoilderProtocol;

@RpcBeanPartTransportable
public class TaskArrive extends Task {
	static Logger logger = LoggerFactory.getLogger(TaskArrive.class);

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
	
	public BattleItemBuilding joinBuilding;

	public BattleItemSoilder behavior;
	
	public BattleItem target;

	public TaskArrive(Battle battle, long executeTime, long startTime
			, int startX, int startY, int endX, int endY, BattleItemSoilder behavior, BattleItemBuilding joinBuilding, BattleItem target) {
		super(battle, executeTime);

		this.startTime = startTime;
		this.endTime = executeTime;
		this.startX = startX;
		this.startY = startY;
		this.targetX = endX;
		this.targetY = endY;
		this.behavior = behavior;
		this.joinBuilding = joinBuilding;
		this.target = target;
	}

	@Override
	public void execute(long now) {
		logger.debug("arrive {}:{} > {}:{}");
		behavior.x = targetX;
		behavior.y = targetY;
		behavior.setTask(null);
		joinBuilding.settledTroops.add(behavior);
		BattleItemSoilderProtocol soilderProto = new BattleItemSoilderProtocol();
		soilderProto.setInstanceId(behavior.instanceId);
		soilderProto.setTask(behavior.getTask());
		battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, soilderProto));
		if (target instanceof BattleItemBuilding) {
			if (((BattleItemBuilding) target).defense == null)
				((BattleItemBuilding) target).defense = new TaskDefense(battle, now + 100, (BattleItemBuilding) target);
		} else if (target instanceof BattleItemSoilder) {
			behavior.setTask(new TaskAttack(battle, now + 100, 2700, behavior, target, joinBuilding));
		}
	}
}
