package com.gearbrother.sheepwolf.pojo;

import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanProperty;

public class ControllerUser extends RpcBean {
	@RpcBeanProperty(desc = "")
	public String userUuid;

	public ControllerUser() {
	}
}
