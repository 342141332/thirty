package com.gearbrother.mushroomWar.pojo;

import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;

public abstract class TaskInterval extends Task {
	@RpcBeanProperty(desc = "间隔时间")
	public long interval;

	public TaskInterval(Battle battle, long executeTime, long interval) {
		super(battle, executeTime);

		this.interval = interval;
	}
}
