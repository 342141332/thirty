package com.gearbrother.mushroomWar.pojo;

import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;

/**
 * @author feng.lee
 * @create on 2014-5-19
 */
@RpcBeanPartTransportable
public class PointBean extends RpcBean {
	@RpcBeanProperty(desc = "x")
	public double x;

	@RpcBeanProperty(desc = "y")
	public double y;
	
	public PointBean() {
		this(0, 0);
	}
	
	public PointBean(double x, double y) {
		this.x = x;
		this.y = y;
	}
	
	@Override
	public PointBean clone() {
		return new PointBean(x, y);
	}
	
	@Override
	public String toString() {
		return "Point(x = " + x + ", y = " + y + ")";
	}
}
