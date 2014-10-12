package com.gearbrother.mushroomWar.rpc.service.bussiness;

import java.util.HashMap;
import java.util.Iterator;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.gearbrother.mushroomWar.model.ISession;
import com.gearbrother.mushroomWar.pojo.Application;
import com.gearbrother.mushroomWar.pojo.CharacterModel;
import com.gearbrother.mushroomWar.pojo.GameConf;
import com.gearbrother.mushroomWar.pojo.IBagItem;
import com.gearbrother.mushroomWar.pojo.Skill;
import com.gearbrother.mushroomWar.pojo.User;
import com.gearbrother.mushroomWar.pojo.World;
import com.gearbrother.mushroomWar.rpc.annotation.RpcServiceMethod;
import com.gearbrother.mushroomWar.rpc.annotation.RpcServiceMethodParameter;

/**
 * @author feng.lee
 * @create on 2013-8-22
 */
@Service
public class UserService {
	static Logger logger = LoggerFactory.getLogger(BattleService.class);
	
	public GameConf gameConfs;
	
	public GameConf getGameConfs() {
		return gameConfs;
	}

	public void setGameConfs(GameConf gameConfs) {
		this.gameConfs = gameConfs;
	}

	public UserService() {
	}

	@RpcServiceMethod(desc = "玩家进入接口，新玩家则注册，老玩家则登陆，返回用户信息")
	public User login(ISession session
			, @RpcServiceMethodParameter(name = "userName", desc = "玩家名字") String userName) {
		User user = newUser(userName);
		session.setLogined(user);
		World.instance.loginedSessions.put(user.uuid, session);
		Application application = new Application();
		application.syntime = System.currentTimeMillis();
		session.send(application);
		return user;
	}
	
	public User newUser(String name) {
		User user = new User();
		user.uuid = UUID.randomUUID().toString();
		user.name = name;
		user.gold = 200;
		user.silver = 100;
		user.bagItems = new HashMap<String, IBagItem>();
		for (Skill skill : gameConfs.weapons.values()) {
			user.bagItems.put(skill.confId, skill.clone());
		}
		for (Skill skill : gameConfs.tools.values()) {
			user.bagItems.put(skill.confId, skill.clone());
		}
		user.heroes = new HashMap<String, CharacterModel>();
		for (Iterator<String> iterator = gameConfs.heroes.keySet().iterator(); iterator.hasNext();) {
			String confId = (String) iterator.next();
			CharacterModel avatar = gameConfs.heroes.get(confId).clone();
			avatar.uuid = UUID.randomUUID().toString();
			user.heroes.put(avatar.uuid, avatar);
		}
		return user;
	}
}
