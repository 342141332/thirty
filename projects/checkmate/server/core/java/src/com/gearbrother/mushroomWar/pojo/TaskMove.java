package com.gearbrother.mushroomWar.pojo;

import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;

@RpcBeanPartTransportable
public class TaskMove extends RpcBean {
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

	public TaskMove(long now, long endTime, int startX, int startY, int endX, int endY) {
		this.startTime = now;
		this.endTime = endTime;
		this.startX = startX;
		this.startY = startY;
		this.targetX = endX;
		this.targetY = endY;
	}
}
