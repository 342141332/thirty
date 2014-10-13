package com.gearbrother.sheepwolf.pojo;

import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanProperty;

public class ControllerAI extends RpcBean {
	@RpcBeanProperty(desc = "运行逻辑的客户端")
	public String clientUuid;
	
	@RpcBeanProperty(desc = "难度")
	public int hard;
	
	public ControllerAI() {
		super();
	}
}
