package com.gearbrother.sheepwolf.pojo;

import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanProperty;

public class RpcBean {
	@RpcBeanProperty(desc = "")
	final public String $class = this.getClass().getName();
	
	public RpcBean() {
		super();
	}
}
