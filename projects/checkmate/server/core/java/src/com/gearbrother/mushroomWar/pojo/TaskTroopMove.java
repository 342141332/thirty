package com.gearbrother.mushroomWar.pojo;

import java.text.SimpleDateFormat;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;
import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BattleItemBuildingProtocol;

public class TaskTroopMove extends Task {
	static Logger logger = LoggerFactory.getLogger(TaskTroopMove.class);

	static SimpleDateFormat format = new SimpleDateFormat("HH:mm:ss.SSS");
	
	public BattleItemBuilding targetBuilding;
	@RpcBeanProperty(desc = "")
	public String getTargetBuildingId() {
		return targetBuilding.instanceId;
	}
	
	@RpcBeanProperty(desc = "")
	public long startTime;
	
	@RpcBeanProperty(desc = "")
	public String itemConfId;
	
	@RpcBeanProperty(desc = "")
	public int num;
	
	public BattleItem army;
	
	public TaskTroopMove(String instanceId, long startTime, BattleItemBuilding sourceBuilding, BattleItemBuilding targetBuilding, String itemConfId, int num) {
		super(instanceId);

		this.startTime = startTime;
		this.targetBuilding = targetBuilding;
		this.itemConfId = itemConfId;
		this.num = num;
	}

	@Override
	public void execute(long executeTime) {
		int current = this.targetBuilding.troops.containsKey(itemConfId) ? this.targetBuilding.troops.get(itemConfId) : 0;
		BattleItemBuildingProtocol targetBuildingProto = new BattleItemBuildingProtocol();
		targetBuildingProto.setInstanceId(this.targetBuilding.instanceId);
		if (army.owner == this.targetBuilding.owner) {
			logger.debug("move {}:{} > {}:{}", itemConfId, current, itemConfId, current + num);
			this.targetBuilding.troops.put(itemConfId, current + num);
		} else {
			current = current - num;
			targetBuilding.fightTime = executeTime;
			if (current > 0) {
				this.targetBuilding.troops.put(itemConfId, current);
			} else {
				this.targetBuilding.troops.put(itemConfId, Math.abs(current));
				this.targetBuilding.owner = army.owner;
				targetBuildingProto.setOwnerId(this.targetBuilding.getOwnerId());
				if (this.targetBuilding.produce != null)
					this.targetBuilding.produce.halt();
				if (this.targetBuilding.dispatch != null)
					this.targetBuilding.dispatch.halt();
				this.targetBuilding.level = 0;
				targetBuildingProto.setLevel(this.targetBuilding.level);
				this.targetBuilding.produce = new TaskProduce(executeTime, 1100, this.targetBuilding, "A0", 1);
				this.targetBuilding.produce.updateExecuteTime(executeTime + this.targetBuilding.produce.interval, battleRoom);
			}
		}
		army.setBattle(null);
		targetBuildingProto.setTroops(this.targetBuilding.troops);
		battleRoom.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, targetBuildingProto));
	}
}
