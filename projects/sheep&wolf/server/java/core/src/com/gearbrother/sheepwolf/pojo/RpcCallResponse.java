package com.gearbrother.sheepwolf.pojo;

import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanProperty;

/**
 * @author feng.lee
 * @create on 2013-12-11
 */
@RpcBeanPartTransportable
public class RpcCallResponse extends RpcBean {
	@RpcBeanProperty(desc = "单次请求标示唯一id")
	public String uuid;

	@RpcBeanProperty(desc = "是否失败")
	public boolean isFailed;

	@RpcBeanProperty(desc = "请求结果，按isFailed失败成功返回的信息不同，失败当前内容则是失败原因，成功则是请求返回结果")
	public Object result;
}
