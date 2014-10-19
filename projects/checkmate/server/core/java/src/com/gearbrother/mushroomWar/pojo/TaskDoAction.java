package com.gearbrother.mushroomWar.pojo;

import java.text.SimpleDateFormat;
import java.util.Collection;
import java.util.HashSet;
import java.util.Set;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BattleForceProtocol;
import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BattleItemProtocol;
import com.gearbrother.mushroomWar.util.GMathUtil;

public class TaskDoAction extends TaskInterval {
	static Logger logger = LoggerFactory.getLogger(TaskDoAction.class);

	static SimpleDateFormat format = new SimpleDateFormat("HH:mm:ss.SSS");

	public BattleItem behavior;

	public TaskDoAction(Battle battle, long executeTime, long interval, BattleItem behavior) {
		super(battle, executeTime, interval);

		this.behavior = behavior;
	}

	@Override
	public void execute(long now) {
		logger.debug("{} DoAction", behavior.instanceId);
		//one attack, one move
		Set<BattleItem> inAttackRange = new HashSet<BattleItem>(); 
		for (int[] attackRect : behavior.attackRects) {
			if (behavior.player.force.forward == 1) {
				attackRect = new int[] {
						behavior.left + behavior.width + attackRect[0],
						behavior.top + attackRect[1],
						behavior.left + behavior.width + attackRect[2],
						behavior.top + attackRect[3]};
			} else if (behavior.player.force.forward == -1) {
				attackRect = new int[] {
						behavior.left + attackRect[2] * -1,
						behavior.top + attackRect[1],
						behavior.left + attackRect[0] * -1,
						behavior.top + attackRect[3]};
			}
			inAttackRange.addAll(battle.getCollision(attackRect));
		}
		for (BattleItem underAttack : inAttackRange) {
			if (underAttack.force == behavior.force)
				continue;

			//attack
			BattleItemProtocol soilderProto = new BattleItemProtocol();
			soilderProto.setInstanceId(behavior.instanceId);
			soilderProto.setAction(new TaskAttack(behavior, underAttack));
			battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, soilderProto));
			underAttack.hp -= GMathUtil.random(behavior.attackDamage[1], behavior.attackDamage[0]);
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
			if (underAttack.isHomeBuilding) {
				underAttack.force.hp = underAttack.hp;
				BattleForceProtocol forceProto = new BattleForceProtocol();
				forceProto.setId(underAttack.force.id);
				forceProto.setHp(underAttack.force.hp);
				battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, forceProto));
				if (underAttack.force.hp == 0) {
					battle.observer.notifySessions(new BattleSignalEnd("end"));
					World.instance.runningBattles.remove(battle.instanceUuid);
				}
			}
		}

		int[] collisionRect = null;
		if (behavior.player.force.forward == 1) {
			collisionRect = new int[] {
					behavior.left + behavior.width,
					behavior.top,
					behavior.left + behavior.width + 1,
					behavior.top + behavior.height};
		} else if (behavior.player.force.forward == -1) {
			collisionRect = new int[] {
					behavior.left - 1,
					behavior.top,
					behavior.left,
					behavior.top + behavior.height};
		}
		Collection<BattleItem> collisions = battle.getCollision(collisionRect);
		boolean isBlock = false;
		for (BattleItem collision : collisions) {
			if (collision.isCollision(behavior)) {
				isBlock = true;
			}
		}
		if (!isBlock) {
			Set<BattleItem> alreadyMoved = new HashSet<BattleItem>();
			c:for (int r = behavior.top; r < behavior.top + behavior.height; r++) {
				if (behavior.force.forward == 1) {
					for (int left = behavior.left; left > -1; left--) {
						Collection<BattleItem> follows = battle.getCollision(new int[] {left, behavior.top, left + 1, behavior.top + 1});
						for (BattleItem follow : follows) {
							int oldLeft = follow.left;
							int oldTop = follow.top;
							if (alreadyMoved.add(follow)) {
								if (follow.isHomeBuilding) {
								} else if (battle.moveItem(follow, oldLeft + follow.force.forward, follow.top)) {
									BattleItemProtocol soilderProto = new BattleItemProtocol();
									soilderProto.setInstanceId(follow.instanceId);
									soilderProto.setLeft(follow.left);
									soilderProto.setTop(follow.top);
									soilderProto.setAction(new TaskMove(now, now + 1000, oldLeft, oldTop, follow.left, follow.top));
									battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, soilderProto));
								} else {
									break c;
								}
							}
						}
					}
				} else if (behavior.force.forward == -1) {
					for (int left = behavior.left; left < battle.col; left++) {
						Collection<BattleItem> follows = battle.getCollision(new int[] {left, behavior.top, left + 1, behavior.top + 1});
						for (BattleItem follow : follows) {
							int oldLeft = follow.left;
							int oldTop = follow.top;
							if (alreadyMoved.add(follow)) {
								if (follow.isHomeBuilding) {
								} else if (battle.moveItem(follow, oldLeft + follow.force.forward, follow.top)) {
									BattleItemProtocol soilderProto = new BattleItemProtocol();
									soilderProto.setInstanceId(follow.instanceId);
									soilderProto.setLeft(follow.left);
									soilderProto.setTop(follow.top);
									soilderProto.setAction(new TaskMove(now, now + 1000, oldLeft, oldTop, follow.left, follow.top));
									battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_UPDATE, soilderProto));
								} else {
									break c;
								}
							}
						}
					}
				}
			}
		}
		setExecuteTime(now + interval);
	}
}
