package com.gearbrother.mushroomWar.pojo;

import java.text.SimpleDateFormat;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;

@RpcBeanPartTransportable
public class TaskProduce extends TaskInterval {
	static Logger logger = LoggerFactory.getLogger(TaskProduce.class);

	static SimpleDateFormat format = new SimpleDateFormat("HH:mm:ss.SSS");

	public BattleItem building;

	public String itemConfId;

	public int num;

	public TaskProduce(Battle battle, long executeTime, long interval
			, BattleItem building, String itemConfId, int num) {
		super(battle, executeTime, interval);

		this.building = building;
		this.itemConfId = itemConfId;
		this.num = num;
	}

	@Override
	public void execute(long now) {
		logger.debug("{} produce", building.instanceId);
		setExecuteTime(now + interval);
	}
}
