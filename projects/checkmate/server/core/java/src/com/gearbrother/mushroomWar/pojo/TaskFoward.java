package com.gearbrother.mushroomWar.pojo;

import java.text.SimpleDateFormat;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BattleItemProtocol;

@RpcBeanPartTransportable
public class TaskFoward extends TaskInterval {
	static Logger logger = LoggerFactory.getLogger(TaskFoward.class);

	static SimpleDateFormat format = new SimpleDateFormat("HH:mm:ss.SSS");
	
	public int[] forward;

	public BattleItem behavior;

	public TaskFoward(Battle battle, long executeTime, long interval
			, int[] forward, BattleItem behavior) {
		super(battle, executeTime, interval);

		this.forward = forward;
		this.behavior = behavior;
	}

	@Override
	public void execute(long now) {
		logger.debug("{} forward", behavior.instanceId);
		List<BattleItem> collisions = battle.getCollision(
			new int[] {
				behavior.left + forward[0],
				behavior.top + forward[1],
				behavior.left + forward[0] + behavior.collisionRect[0],
				behavior.top + forward[1] + behavior.collisionRect[1]
			}
		);
		if (collisions.size() > 0) {
			for (int i = 0; i < behavior.attackRects.length; i++) {
				int[] attackRect = behavior.attackRects[i];
				if (behavior.forward[0] == 1) {
					attackRect = new int[] {attackRect[0] - attackRect[1], attackRect[1] - attackRect[0], attackRect[0], attackRect[1]};
				} else if (behavior.forward[0] == -1) {
					attackRect = new int[] {attackRect[0], attackRect[1], attackRect[0] + 1, attackRect[1] + 1};
				} else if (behavior.forward[1] == 1) {
					attackRect = new int[] {
							behavior.left + attackRect[0],
							behavior.top + -1 * attackRect[3] + behavior.height,
							behavior.left + attackRect[2],
							behavior.top + -1 * attackRect[1] + behavior.height};
				} else if (behavior.forward[1] == -1) {
					attackRect = new int[] {
							behavior.left + attackRect[0],
							behavior.top + attackRect[1],
							behavior.left + attackRect[2],
							behavior.top + attackRect[3]
					};
				}
				collisions = battle.getCollision(attackRect);
				for (BattleItem collision : collisions) {
					if (collision.owner == behavior.owner)
						continue;

					//attack
					BattleItemProtocol soilderProto = new BattleItemProtocol();
					soilderProto.setInstanceId(behavior.instanceId);
					soilderProto.setAction(new TaskAttack(behavior, collision));
					battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, soilderProto));
					collision.hp -= behavior.attackDamage;
					BattleItemProtocol targetProto = new BattleItemProtocol();
					targetProto.setInstanceId(collision.instanceId);
					targetProto.setHp(collision.hp);
					if (collision.hp < 1) {
						if (collision.getTask() != null)
							collision.getTask().halt();
						battle.removeItem(collision);
						battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_REMOVE, targetProto));
					} else {
						battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, targetProto));
					}
				}
			}
		} else {
			int oldLeft = behavior.left;
			int oldTop = behavior.top;
			if (battle.moveItem(behavior, behavior.left + forward[0], behavior.top + forward[1])) {
				BattleItemProtocol soilderProto = new BattleItemProtocol();
				soilderProto.setInstanceId(behavior.instanceId);
				soilderProto.setLeft(behavior.left);
				soilderProto.setTop(behavior.top);
				soilderProto.setAction(new TaskMove(now, now + 1000, oldLeft, oldTop, behavior.left, behavior.top));
				battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, soilderProto));
			} else {
				throw new Error("");
			}
		}
		setExecuteTime(now + interval);
	}
}
