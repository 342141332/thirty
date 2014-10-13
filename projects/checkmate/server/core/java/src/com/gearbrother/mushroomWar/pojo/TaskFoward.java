package com.gearbrother.mushroomWar.pojo;

import java.text.SimpleDateFormat;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

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
		Set<BattleItem> inAttackRects = new HashSet<BattleItem>(); 
		for (int[] attackRect : behavior.attackRects) {
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
			inAttackRects.addAll(battle.getCollision(attackRect));
		}
		for (BattleItem underAttack : inAttackRects) {
			if (underAttack.owner == behavior.owner)
				continue;

			//attack
			BattleItemProtocol soilderProto = new BattleItemProtocol();
			soilderProto.setInstanceId(behavior.instanceId);
			soilderProto.setAction(new TaskAttack(behavior, underAttack));
			battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, soilderProto));
			underAttack.hp -= behavior.attackDamage;
			BattleItemProtocol targetProto = new BattleItemProtocol();
			targetProto.setInstanceId(underAttack.instanceId);
			targetProto.setHp(underAttack.hp);
			if (underAttack.hp < 1) {
				if (underAttack.getTask() != null)
					underAttack.getTask().halt();
				battle.removeItem(underAttack);
				battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_REMOVE, targetProto));
			} else {
				battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, targetProto));
			}
		}

		List<BattleItem> collisions = battle.getCollision(
			new int[] {
				behavior.left + forward[0],
				behavior.top + forward[1],
				behavior.left + forward[0] + behavior.width,
				behavior.top + forward[1] + behavior.height
			}
		);
		boolean isMoveable = false;
		if (collisions.size() > 0) {
		} else {
			isMoveable = true;
		}
		if (isMoveable) {
			Set<BattleItem> alreadyMoved = new HashSet<BattleItem>();
			for (int c = behavior.left; c < behavior.left + behavior.width; c++) {
				if (forward[1] == 1) {
					for (int r = behavior.top; r > 0; r--) {
						List<BattleItem> follows = battle.getCollision(new int[] {c, r, c + 1, r + 1});
						for (BattleItem follow : follows) {
							int oldLeft = follow.left;
							int oldTop = follow.top;
							if (alreadyMoved.add(follow) && battle.moveItem(follow, c, r + forward[1])) {
								BattleItemProtocol soilderProto = new BattleItemProtocol();
								soilderProto.setInstanceId(follow.instanceId);
								soilderProto.setLeft(follow.left);
								soilderProto.setTop(follow.top);
								soilderProto.setAction(new TaskMove(now, now + 1000, oldLeft, oldTop, follow.left, follow.top));
								battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, soilderProto));
							}
						}
					}
				} else if (forward[1] == -1) {
					for (int r = behavior.top; r < battle.row; r++) {
						List<BattleItem> follows = battle.getCollision(new int[] {c, r, c + 1, r + 1});
						for (BattleItem follow : follows) {
							int oldLeft = follow.left;
							int oldTop = follow.top;
							if (alreadyMoved.add(follow) && battle.moveItem(follow, c, r + forward[1])) {
								BattleItemProtocol soilderProto = new BattleItemProtocol();
								soilderProto.setInstanceId(follow.instanceId);
								soilderProto.setLeft(follow.left);
								soilderProto.setTop(follow.top);
								soilderProto.setAction(new TaskMove(now, now + 1000, oldLeft, oldTop, follow.left, follow.top));
								battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, soilderProto));
							}
						}
					}
				}
			}
		}
		setExecuteTime(now + interval);
	}
}
