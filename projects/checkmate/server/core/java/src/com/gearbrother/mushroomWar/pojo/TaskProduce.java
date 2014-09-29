package com.gearbrother.mushroomWar.pojo;

import java.text.SimpleDateFormat;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.util.GMathUtil;

@RpcBeanPartTransportable
public class TaskProduce extends TaskInterval {
	static Logger logger = LoggerFactory.getLogger(TaskProduce.class);

	static SimpleDateFormat format = new SimpleDateFormat("HH:mm:ss.SSS");

	public BattleItemBuilding building;

	public String itemConfId;

	public int num;

	public int total;

	public TaskProduce(Battle battle, long executeTime, long interval, BattleItemBuilding building, String itemConfId, int num) {
		super(battle, executeTime, interval);

		this.building = building;
		this.itemConfId = itemConfId;
		this.num = num;
	}

	@Override
	public void execute(long now) {
		logger.debug("{} produce {}:{} > {}:{}", building.instanceId, itemConfId);
		if (total < num) {
			BattleItemSoilder dispatchedTroop = new BattleItemSoilder(building);
			dispatchedTroop.instanceId = UUID.randomUUID().toString();
			dispatchedTroop.cartoon = "static/kingdomrush/7207.swf";
			dispatchedTroop.x = building.x + GMathUtil.random(30, -30);
			dispatchedTroop.y = building.y + GMathUtil.random(17);
			dispatchedTroop.hp = dispatchedTroop.maxHp = 7;
			dispatchedTroop.attackDamage = GMathUtil.random(3, 1);
			dispatchedTroop.layer = "over";
			dispatchedTroop.setBattle(building.getBattle());
			dispatchedTroop.building = building;
			dispatchedTroop.owner = building.owner;
			building.settledTroops.add(dispatchedTroop);
			building.getBattle().observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_ADD, dispatchedTroop));
			total++;
			setExecuteTime(now + interval);
		}
	}
}
