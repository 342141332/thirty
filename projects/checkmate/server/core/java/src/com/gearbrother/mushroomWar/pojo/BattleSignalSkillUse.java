package com.gearbrother.mushroomWar.pojo;

import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;

/**
 * @author feng.lee
 * @create on 2014-6-4
 */
@RpcBeanPartTransportable
public class BattleSignalSkillUse extends RpcBean {
	@RpcBeanProperty(desc = "当前使用技能")
	public Skill skill;
	
	@RpcBeanProperty(desc = "")
	public String userUuid;
	
	public BattleSignalSkillUse() {
	}
}
