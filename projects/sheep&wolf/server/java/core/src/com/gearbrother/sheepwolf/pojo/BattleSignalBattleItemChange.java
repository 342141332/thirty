package com.gearbrother.sheepwolf.pojo;

import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanProperty;

/**
 * @author feng.lee
 * @create on 2014-5-27
 */
@RpcBeanPartTransportable
public class BattleSignalBattleItemChange extends BattleSignal {
	static public final int TYPE_ADD = 1;
	static public final int TYPE_UPDATE = 2;
	static public final int TYPE_REMOVE = 3;

	@RpcBeanProperty(desc = "操作, 1：增加，2：更新，3：删除")
	public int type;

	@RpcBeanProperty(desc = "")
	public Object item;

	@RpcBeanProperty(desc = "使用者位置")
	public PointBean userPos;

	public BattleSignalBattleItemChange(int type, Object item) {
		this.type = type;
		this.item = item;
	}

	public BattleSignalBattleItemChange(int type, Object item, PointBean userPos) {
		this.type = type;
		this.item = item;
		this.userPos = userPos;
	}
}
