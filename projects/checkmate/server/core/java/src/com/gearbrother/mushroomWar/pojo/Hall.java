package com.gearbrother.mushroomWar.pojo;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;

/**
 * @author feng.lee
 * @create on 2013-12-6
 */
@RpcBeanPartTransportable
public class Hall extends RpcBean {
	@RpcBeanProperty(desc = "大厅唯一ID")
	public String uuid;

	@RpcBeanProperty(desc = "可选地图id")
	public Set<String> mapIds;

	final public SessionObserver observer;

	@RpcBeanProperty(desc = "等候的房间")
	final public Map<String, BattleRoom> rooms;

	public Hall() {
		super();

		observer = new SessionObserver();
		rooms = new HashMap<String, BattleRoom>();
	}
}
