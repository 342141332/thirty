package com.gearbrother.mushroomWar.pojo;

import java.text.SimpleDateFormat;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;
import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BattleItemBuildingProtocol;

@RpcBeanPartTransportable
public class TaskProduce extends TaskInterval {
	static Logger logger = LoggerFactory.getLogger(TaskProduce.class);

	static SimpleDateFormat format = new SimpleDateFormat("HH:mm:ss.SSS");
	
	public BattleItemBuilding building;
	@RpcBeanProperty(desc = "")
	public String getBuildingId() {
		return building.instanceId;
	}
	
	@RpcBeanProperty(desc = "生产资源配置id")
	public String itemConfId;
	
	@RpcBeanProperty(desc = "间隔生产数量")
	public int num;
	
	public TaskProduce(long lastIntervalTime, long interval, BattleItemBuilding building, String itemConfId, int num) {
		super(lastIntervalTime, interval);

		this.building = building;
		this.itemConfId = itemConfId;
		this.num = num;
	}

	@Override
	protected long doInterval(long lastIntervalTime, long now) {
		int troop = building.troops.containsKey(itemConfId) ? building.troops.get(itemConfId).intValue() : 0;
		long oldNum = troop;
		troop += (now - lastIntervalTime) / interval * num;
		building.troops.put(itemConfId, troop);
		logger.debug("{} produce {}:{} > {}:{}", building.instanceId, itemConfId, oldNum, itemConfId, troop);
//		BattleItemBuildingProtocol buildingProto = new BattleItemBuildingProtocol();
//		buildingProto.setInstanceId(building.instanceId);
//		buildingProto.setTroops(building.troops);
//		battleRoom.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, buildingProto));
		return now;
	}
}
