package com.gearbrother.mushroomWar.pojo;

import java.text.SimpleDateFormat;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BattleItemProtocol;

@RpcBeanPartTransportable
public class TaskFoward extends TaskInterval {
	static Logger logger = LoggerFactory.getLogger(TaskFoward.class);

	static SimpleDateFormat format = new SimpleDateFormat("HH:mm:ss.SSS");
	
	public int forwardX;
	
	public int forwardY;

	public BattleItem behavior;

	public TaskFoward(Battle battle, long executeTime, long interval
			, int forwardX, int forwardY, BattleItem behavior) {
		super(battle, executeTime, interval);

		this.forwardX = forwardX;
		this.forwardY = forwardY;
		this.behavior = behavior;
	}

	@Override
	public void execute(long now) {
		logger.debug("{} arrive field", behavior.instanceId);
		int destX = behavior.getX(), oldX = behavior.getX();
		int destY = behavior.getY(), oldY = behavior.getY();
		BattleItem collision = null;
		//move
		for (int range = 1; range <= behavior.moveRange; range++) {
			int x = behavior.getX() + range * forwardX;
			int y = behavior.getY() + range * forwardY;
			if (-1 < x && x < battle.width && -1 < y && y < battle.height) {
				if (battle.collisions[y][x] == null) {
					destX = x;
					destY = y;
				} else {
					collision = battle.collisions[y][x];
					break;
				}
			} else {
				return;
			}
		}
		if (oldX != destX || oldY != destY) {
			behavior.setXY(destX, destY);
			BattleItemProtocol soilderProto = new BattleItemProtocol();
			soilderProto.setInstanceId(behavior.instanceId);
			soilderProto.setAction(new TaskMove(now, now + 1000, oldX, oldY, destX, destY));
			battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, soilderProto));
		}
		if (collision != null && collision.owner != behavior.owner) {
			//attack
			BattleItemProtocol soilderProto = new BattleItemProtocol();
			soilderProto.setInstanceId(behavior.instanceId);
			soilderProto.setX(behavior.getX());
			soilderProto.setY(behavior.getY());
			soilderProto.setAction(new TaskAttack(behavior, collision));
			battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, soilderProto));

			collision.hp -= behavior.attackDamage;
			BattleItemProtocol targetProto = new BattleItemProtocol();
			targetProto.setInstanceId(collision.instanceId);
			targetProto.setHp(collision.hp);
			if (collision.hp < 1) {
				if (collision.getTask() != null)
					collision.getTask().halt();
				collision.setBattle(null);
				battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_REMOVE, targetProto));
			} else {
				battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, targetProto));
			}
		}
		setExecuteTime(now + interval);
	}
}
