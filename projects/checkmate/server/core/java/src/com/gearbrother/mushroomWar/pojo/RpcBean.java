package com.gearbrother.mushroomWar.pojo;

import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;

public class RpcBean {
	@RpcBeanProperty(desc = "")
	final public String $class = this.getClass().getName();
	
	public RpcBean() {
		super();
	}
}
