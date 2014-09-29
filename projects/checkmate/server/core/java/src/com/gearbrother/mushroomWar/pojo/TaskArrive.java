package com.gearbrother.mushroomWar.pojo;

import java.text.SimpleDateFormat;
import java.util.Iterator;

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
	
	public BattleItemBuilding targetBuilding;

	public BattleItemSoilder behavior;

	public TaskArrive(Battle battle, long executeTime, long startTime
			, int startX, int startY, int endX, int endY, BattleItemBuilding targetBuilding, BattleItemSoilder behavior) {
		super(battle, executeTime);

		this.startTime = startTime;
		this.endTime = executeTime;
		this.startX = startX;
		this.startY = startY;
		this.targetX = endX;
		this.targetY = endY;
		this.targetBuilding = targetBuilding;
		this.behavior = behavior;
	}

	@Override
	public void execute(long now) {
		logger.debug("arrive {}:{} > {}:{}");
		behavior.x = targetX;
		behavior.y = targetY;
		behavior.task = null;
		targetBuilding.settledTroops.add(behavior);
		BattleItemSoilderProtocol soilderProto = new BattleItemSoilderProtocol();
		soilderProto.setInstanceId(behavior.instanceId);
		soilderProto.setTask(behavior.task);
		battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, soilderProto));
		if (targetBuilding.owner != behavior.owner) {
			for (Iterator<BattleItemSoilder> iterator = targetBuilding.settledTroops.iterator(); iterator.hasNext();) {
				BattleItemSoilder soilder = (BattleItemSoilder) iterator.next();
				if (soilder.task == null) {
					soilder.task = new TaskAttack(battle, now + 700, 2700, soilder, targetBuilding);
					break;
				}
			}
		}
	}
}
