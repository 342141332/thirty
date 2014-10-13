package com.gearbrother.sheepwolf.pojo;

import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanProperty;
import com.gearbrother.sheepwolf.rpc.protocol.bussiness.BattleItemUserProtocol;

/**
 * @author feng.lee
 * @create on 2014-6-9
 */
@RpcBeanPartTransportable
public class BattleSignalUserUpdate extends RpcBean {
	public BattleSignalUserUpdate(BattleItemUserProtocol userProto) {
		this.user = userProto;
	}

	@RpcBeanProperty(desc = "")
	public Object user;
}
