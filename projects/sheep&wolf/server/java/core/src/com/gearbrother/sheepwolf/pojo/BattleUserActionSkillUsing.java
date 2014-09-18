package com.gearbrother.sheepwolf.pojo;

import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanProperty;

/**
 * @author feng.lee
 * @create on 2014-6-6
 */
@RpcBeanPartTransportable
public class BattleUserActionSkillUsing extends RpcBean {
	@RpcBeanProperty(desc = "")
	public long currentTime;

	@RpcBeanProperty(desc = "")
	public PointBean startPosition;

	@RpcBeanProperty(desc = "")
	public Skill skill;

	public int direction;
	
	public BattleUserActionSkillUsing(PointBean position, long currentTime, int direction) {
		this.startPosition = position;
		this.currentTime = currentTime;
		this.direction = direction;
	}
}
