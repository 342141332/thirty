package com.gearbrother.sheepwolf.pojo;

import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanProperty;

/**
 * @author feng.lee
 * @create on 2014-3-24
 */
@RpcBeanPartTransportable
public class BattleSignalTool extends RpcBean {
	@RpcBeanProperty(desc = "playerUuid")
	public String userUuid;

	@RpcBeanProperty(desc = "道具id")
	public String toolConfId;
	
	@RpcBeanProperty(desc = "服务器时间")
	public long time;
	
	@RpcBeanProperty(desc = "x")
	public double x;
	
	@RpcBeanProperty(desc = "y")
	public double y;

	@RpcBeanProperty(desc = "玩家方向")
	public int direct;
}
