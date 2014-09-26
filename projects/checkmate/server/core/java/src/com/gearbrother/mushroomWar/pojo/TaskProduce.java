package com.gearbrother.mushroomWar.pojo;

import java.text.SimpleDateFormat;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;
import com.gearbrother.mushroomWar.util.GMathUtil;

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
		for (int i = 0; i < num; i++) {
			BattleItemSoilder dispatchedTroop = new BattleItemSoilder();
			dispatchedTroop.instanceId = UUID.randomUUID().toString();
			dispatchedTroop.cartoon = "static/asset/avatar/enemy_2.swf";
			dispatchedTroop.x = building.x + GMathUtil.random(50, -50);
			dispatchedTroop.y = building.y + 97;
			dispatchedTroop.layer = "floor";
			dispatchedTroop.setBattle(building.getBattle());
			building.troops.add(dispatchedTroop);
			battleRoom.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_ADD, dispatchedTroop));
		}
		logger.debug("{} produce {}:{} > {}:{}", building.instanceId, itemConfId);
		return now;
	}
}
