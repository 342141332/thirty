package com.gearbrother.mushroomWar.rpc.service.bussiness;

import org.springframework.stereotype.Service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.gearbrother.mushroomWar.model.ISession;
import com.gearbrother.mushroomWar.pojo.Avatar;
import com.gearbrother.mushroomWar.pojo.IBagItem;
import com.gearbrother.mushroomWar.pojo.Skill;
import com.gearbrother.mushroomWar.pojo.User;
import com.gearbrother.mushroomWar.rpc.annotation.RpcServiceMethod;
import com.gearbrother.mushroomWar.rpc.annotation.RpcServiceMethodParameter;

/**
 * @author feng.lee
 * @create on 2013-8-22
 */
@Service
public class AvatarService {
	public AvatarService() {
	}

	@RpcServiceMethod(desc = "玩家进入接口，新玩家则注册，老玩家则登陆，返回用户信息")
	public void sell(ISession session
			, @RpcServiceMethodParameter(name = "avatarUuid", desc = "") String avatarUuid) throws JsonProcessingException {
	}
	
	@RpcServiceMethod(desc = "装备装备")
	public void setEquip(ISession session
			, @RpcServiceMethodParameter(name = "avatarUuid") String avatarUuid
			, @RpcServiceMethodParameter(name = "weaponIndex") int weaponIndex
			, @RpcServiceMethodParameter(name = "weaponUuid") String weaponUuid) {
	}

	@RpcServiceMethod(desc = "装备武器")
	public void setWeapon(ISession session
			, @RpcServiceMethodParameter(name = "avatarUuid", desc = "") String avatarUuid
			, @RpcServiceMethodParameter(name = "bagUuid", desc = "背包实例ID") String bagUuid
			, @RpcServiceMethodParameter(name = "index") int weaponIndex) {
		User logined = session.getLogined();
		Avatar avatar = logined.heroes.get(avatarUuid);
		IBagItem bagItem = logined.bagItems.get(bagUuid);
		if (bagItem instanceof Skill) {
			avatar.addSkill((Skill) bagItem);
		}
	}

	@RpcServiceMethod(desc = "装备道具")
	public void setTool(ISession session
			, @RpcServiceMethodParameter(name = "avatarUuid") String avatarUuid
			, @RpcServiceMethodParameter(name = "weaponIndex") int weaponIndex
			, @RpcServiceMethodParameter(name = "weaponUuid") String weaponUuid) {
	}
}
