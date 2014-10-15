package com.gearbrother.mushroomWar.pojo;

import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;

/**
 * @author feng.lee
 * @create on 2014-5-27
 */
@RpcBeanPartTransportable
public class PropertyEvent extends RpcBean {
	static public final int TYPE_ADD = 1;
	static public final int TYPE_UPDATE = 2;
	static public final int TYPE_REMOVE = 3;
	static public final int TYPE_SKILL = 4;
	static public final int TYPE_REMOVED_BY_SKILL = 5;

	@RpcBeanProperty(desc = "操作, 1：增加，2：更新，3：删除")
	public int type;

	@RpcBeanProperty(desc = "")
	public Object item;
	
	@RpcBeanProperty(desc = "")
	public String code;

	public PropertyEvent(int type, Object item) {
		this.type = type;
		this.item = item;
	}
	
	public PropertyEvent(int type, Object item, String code) {
		this(type, item);
		
		this.code = code;
	}
}
