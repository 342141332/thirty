package com.gearbrother.mushroomWar.pojo;

import java.text.SimpleDateFormat;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;
import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BattleItemBuildingProtocol;

@RpcBeanPartTransportable
public class TaskTroopDispatch extends TaskInterval {
	static Logger logger = LoggerFactory.getLogger(TaskTroopDispatch.class);

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

	public TaskTroopDispatch(long lastIntervalTime, long interval
			, BattleItemBuilding sourceBuilding, BattleItemBuilding targetBuilding, int maxNum) {
		super(lastIntervalTime, interval);

		this.sourceBuilding = sourceBuilding;
		this.targetBuilding = targetBuilding;
		this.maxNum = maxNum;
	}

	@Override
	protected long doInterval(long lastIntervalTime, long now) {
		for (; lastIntervalTime < now; lastIntervalTime += interval) {
			if (sourceBuilding.troops.keySet().size() > 0) {
				String itemConfId = sourceBuilding.troops.keySet().iterator().next();
				int troop = sourceBuilding.troops.containsKey(itemConfId) ? sourceBuilding.troops.get(itemConfId) : 0;
				int moveNum = Math.min(maxNum, troop);
				logger.debug("{} dispatch {}:{} > {}:{}", sourceBuilding.instanceId, itemConfId, troop, itemConfId, troop - moveNum);
				troop = troop - moveNum;
				if (moveNum > 0) {
					sourceBuilding.troops.put(itemConfId, troop);
					BattleItem dispatchedTroop = new BattleItem();
					dispatchedTroop.instanceId = UUID.randomUUID().toString();
					dispatchedTroop.cartoon = "static/asset/avatar/enemy_2.swf";
					dispatchedTroop.x = sourceBuilding.x;
					dispatchedTroop.y = sourceBuilding.y;
					dispatchedTroop.layer = "floor";
					dispatchedTroop.setBattle(sourceBuilding.getBattle());
					long costTime = (long) (50L * Math.sqrt(Math.pow(sourceBuilding.x - targetBuilding.x, 2) + Math.pow(sourceBuilding.y - targetBuilding.y, 2)));
					BattleItemActionMove action = new BattleItemActionMove(lastIntervalTime, lastIntervalTime + costTime
							, sourceBuilding, targetBuilding, 0, 200L, 0L, 0L);
					dispatchedTroop.currentAction = action;
					dispatchedTroop.owner = sourceBuilding.owner;
					battleRoom.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_ADD, dispatchedTroop));
					TaskTroopMove moveTask = new TaskTroopMove(UUID.randomUUID().toString(), lastIntervalTime, sourceBuilding, targetBuilding, itemConfId, moveNum);
					moveTask.army = dispatchedTroop;
					moveTask.updateExecuteTime(lastIntervalTime + costTime, battleRoom);
					dispatchedTroop.move = moveTask;
					BattleItemBuildingProtocol sourceBuildingProto = new BattleItemBuildingProtocol();
					sourceBuildingProto.setInstanceId(sourceBuilding.instanceId);
					sourceBuildingProto.setTroops(sourceBuilding.troops);
					battleRoom.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, sourceBuildingProto));
				}
				if (troop == 0)
					sourceBuilding.troops.remove(itemConfId);
			}
		}
		return now;
	}
}
