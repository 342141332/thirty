package com.gearbrother.mushroomWar.rpc.service.bussiness;

import org.springframework.stereotype.Service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.gearbrother.mushroomWar.model.ISession;
import com.gearbrother.mushroomWar.rpc.annotation.RpcServiceMethod;
import com.gearbrother.mushroomWar.rpc.annotation.RpcServiceMethodParameter;

/**
 * @author feng.lee
 * @create on 2013-8-22
 */
@Service
public class ShopService {
	public ShopService() {
	}

	@RpcServiceMethod(desc = "购买坦克")
	public void buyAvatar(ISession session
			, @RpcServiceMethodParameter(name = "avatarConfId", desc = "") String avatarConfId) throws JsonProcessingException {
	}
}
