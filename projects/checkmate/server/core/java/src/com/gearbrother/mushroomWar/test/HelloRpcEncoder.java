package com.gearbrother.mushroomWar.test;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.gearbrother.mushroomWar.pojo.RpcBean;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;
import com.gearbrother.mushroomWar.rpc.ioHandler.codec.RpcAnnotationIntrospector;

/**
 * @author feng.lee
 * @create on 2014-6-25
 */
public class HelloRpcEncoder {
	public static void main(String[] args) throws JsonProcessingException {
		ObjectMapper objectMapper = new ObjectMapper();
		objectMapper.setAnnotationIntrospector(new RpcAnnotationIntrospector());
		System.out.println(objectMapper.writeValueAsString(new Bean()));
	}
}

/**
 * @author feng.lee
 * @create on 2014-6-25
 */
class Bean extends RpcBean {
	@RpcBeanProperty(desc = "")
	private int exp;
	@RpcBeanProperty(desc = "ff")
	public int getExp() {
		return exp;
	}
	@RpcBeanProperty(desc = "ff")
	public void setExp(int value) {
		exp = value;
	}
}
