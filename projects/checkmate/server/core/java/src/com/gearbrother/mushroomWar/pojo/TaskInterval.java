package com.gearbrother.mushroomWar.pojo;

import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;
import com.gearbrother.mushroomWar.util.GMathUtil;

public abstract class TaskInterval extends Task {
	@RpcBeanProperty(desc = "最近执行时间")
	public long lastIntervalTime;
	
	@RpcBeanProperty(desc = "间隔时间")
	public long interval;

	public TaskInterval(long lastIntervalTime, long interval) {
		super();
		
		this.lastIntervalTime = lastIntervalTime;
		this.interval = interval;
	}

	@Override
	final public void execute(long executeTime) {
		long currentTimes = GMathUtil.roundDownToMultiple(executeTime, interval);
		if (currentTimes > lastIntervalTime) {
			lastIntervalTime = doInterval(lastIntervalTime, currentTimes);
			commit(lastIntervalTime + interval);
		} else {
			throw new Error("why here?");
		}
	}
	
	abstract protected long doInterval(long lastIntervalTime, long now);
}
