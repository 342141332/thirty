package com.gearbrother.mushroomWar.rpc.service.bussiness;

import java.util.Iterator;
import java.util.Map.Entry;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.JsonNode;
import com.gearbrother.mushroomWar.model.ISession;
import com.gearbrother.mushroomWar.pojo.GameConf;
import com.gearbrother.mushroomWar.pojo.IBagItem;
import com.gearbrother.mushroomWar.pojo.User;
import com.gearbrother.mushroomWar.rpc.annotation.RpcServiceMethod;
import com.gearbrother.mushroomWar.rpc.annotation.RpcServiceMethodParameter;

/**
 * @author feng.lee
 * @create on 2013-8-22
 */
@Service
public class BagService {
	static Logger logger = LoggerFactory.getLogger(BattleService.class);
	
	public GameConf gameConfs;
	
	public GameConf getGameConfs() {
		return gameConfs;
	}

	public void setGameConfs(GameConf gameConfs) {
		this.gameConfs = gameConfs;
	}

	public BagService() {
	}

	@RpcServiceMethod(desc = "玩家进入接口，新玩家则注册，老玩家则登陆，返回用户信息")
	public void sort(ISession session
			, @RpcServiceMethodParameter(name = "bagIndexs", desc = "重新排序的位置") JsonNode bagIndexs) {
		User logined = session.getLogined();
		for (Iterator<Entry<String, JsonNode>> iterator = bagIndexs.fields(); iterator.hasNext();) {
			Entry<String, JsonNode> node = (Entry<String, JsonNode>) iterator.next();
			IBagItem bagItem = logined.bagItems.get(node.getKey());
			bagItem.setBagIndex(node.getValue().asInt());
		}
	}
}
