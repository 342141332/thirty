package com.gearbrother.mushroomWar.pojo;

import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;

/**
 * @author feng.lee
 * @create on 2014-5-19
 */
@RpcBeanPartTransportable
public class BattleItemActionMove extends RpcBean {
	@RpcBeanProperty(desc = "开始时间")
	public long startTime;

	@RpcBeanProperty(desc = "开始位置")
	public PointBean startPos;
	
	@RpcBeanProperty(desc = "结束时间")
	public long endTime;
	
	@RpcBeanProperty(desc = "目的地")
	public PointBean targetPos;
	
	@RpcBeanProperty(desc = "移动速度")
	public double moveSpeed;
	
	@RpcBeanProperty(desc = "超时后的移动速度")
	public double changeSpeed;

	@RpcBeanProperty(desc = "超时时间")
	public long changeSpeedTime;
	
	@RpcBeanProperty(desc = "游离")
	public int offset;

	public BattleItemActionMove(long startTime, long endTime, PointBean startPos, PointBean targetPos, int moveTo, double moveSpeed, double changeSpeed, long changeSpeedTime) {
		super();

		this.startTime = startTime;
		this.endTime = endTime;
		this.startPos = startPos;
		this.targetPos = targetPos;
		this.moveSpeed = moveSpeed;
		this.changeSpeed = changeSpeed;
		this.changeSpeedTime = changeSpeedTime;
	}
}
