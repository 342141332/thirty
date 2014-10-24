package com.gearbrother.mushroomWar.pojo;

import java.util.Collection;
import java.util.UUID;

public class TaskDispatch extends Task {
	public BattlePlayer player;
	
	public String confId;
	
	public int left;
	
	public int top;
	
	public TaskDispatch(BattlePlayer player, long executeTime, String confId, int left, int top) {
		super(player.battle, executeTime);

		this.player = player;
		this.confId = confId;
		this.left = left;
		this.top = top;
	}

	@Override
	public void execute(long now) {
		CharacterModel character = player.choosedSoilders.get(confId);
		if (character.coin > player.coin)
			return;

		player.coin -= character.coin;
		int forward = player.force.forward;
		character = character.clone();
		Battle battle = player.battle;
		int[] thredshold = null;
		if (forward == 1) {
			thredshold = new int[] {0, 0, player.force.border, battle.row};
			left = 0;
		} else if (forward == -1) {
			thredshold = new int[] {battle.col - player.force.border, 0, battle.col, battle.row};
			left = battle.col - character.width;
		} else {
			throw new Error("forward can't be zero");
		}
		for (int r = 0; r < battle.row; r++) {
			_newCharacter(now, character, forward, battle, thredshold, left, r);
		}
	}

	private void _newCharacter(long now, CharacterModel character, int forward, Battle battle, int[] thredshold, int left, int top) {
		int[] leftTop = null;
		//first, close to border
		boolean isBlock = false;
		c:while (true) {
			if (left < thredshold[0] || left + character.height > thredshold[2]) {
				break;
			}
			Collection<BattleItem> collisions = battle.getCollision(new int[] {left, top, left + character.width, top + character.height});
			for (BattleItem collision : collisions) {
				if (collision.isCollision(character)) {
					isBlock = true;
					break c;
				}
			}
			leftTop = new int[] {left, top};
			left += forward;
		}
		if (leftTop == null)
			return;

		//second, close to battle
		int[] followPos = null;
		if (Battle.STATE_PLAYING == battle.state && leftTop != null) {
			if (!isBlock) {
				c:while (true) {
					if (left < 0 || left + character.width > battle.col) {
						followPos = null;
						break;
					}
					Collection<BattleItem> collisions = battle.getCollision(new int[] {left, top, left + character.width, top + character.height});
					//if first collision.owner is enemy break;
					if (collisions.size() > 0) {
						for (BattleItem collision : collisions) {
							if (collision.player == player) {
								break c;
							} else {
								followPos = null;
								break c;
							}
						}
					} else {
						followPos = new int[] {left, top};
					}
					left += forward;
				}
			}
		}
		BattleItem item = new BattleItem(character);
		item.instanceId = UUID.randomUUID().toString();
		item.player = player;
		if (followPos != null) {
			item.left = followPos[0];
			item.top = followPos[1];
		} else {
			item.left = leftTop[0];
			item.top = leftTop[1];
		}
		item.force = player.force;
		item.player = player;
		battle.addItem(item);
		battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_ADD, item));
		item.setTask(new TaskDoAction(battle, now + item.interval, item.interval, item));
	}
}
