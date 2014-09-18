package com.gearbrother.mushroomWar.pojo;

import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;

public class ControllerUser extends RpcBean {
	@RpcBeanProperty(desc = "")
	public String userUuid;

	public ControllerUser() {
	}
}
