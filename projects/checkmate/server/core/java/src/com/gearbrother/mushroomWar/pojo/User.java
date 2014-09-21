package com.gearbrother.mushroomWar.pojo;

import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;

import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;

@RpcBeanPartTransportable
public class User extends RpcBean {
	@RpcBeanProperty(desc = "用户身份唯一id")
	public String uuid;

	@RpcBeanProperty(desc = "玩家名称")
	public String name;

	public String password;

	@RpcBeanProperty(desc = "拥有金币")
	public int gold;

	@RpcBeanProperty(desc = "拥有银币")
	public int silver;

	@RpcBeanProperty(desc = "模型")
	public Map<String, Avatar> heroes;

	@RpcBeanProperty(desc = "背包")
	public Map<String, IBagItem> bagItems;

	public Timestamp createTime;

	public Timestamp updateTime;

	public User() {
		heroes = new HashMap<String, Avatar>();
		bagItems = new HashMap<String, IBagItem>();
	}
}
