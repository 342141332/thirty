package com.gearbrother.mushroomWar.pojo;

import java.util.List;
import java.util.UUID;

import com.gearbrother.mushroomWar.util.GMathUtil;

public class TaskDispatch extends Task {
	public BattleRoomSeat seat;
	
	public String confId;
	
	public int left;
	
	public int top;
	
	public TaskDispatch(BattleRoomSeat seat, long executeTime, String confId, int left, int top) {
		super(seat.room.battle, executeTime);

		this.seat = seat;
		this.confId = confId;
		this.left = left;
		this.top = top;
	}

	@Override
	public void execute(long now) {
		BattleRoomSeatCharacter seatCharacter = seat.choosedSoilders.get(confId);
		if (seatCharacter.num == 0)
			return;

		BattleForce force = seat.force;
		int[] forward = force.forward;
		if (forward[0] == 0 && forward[1] == 0) {
			throw new Error("forward can't be zero");
		} else {
			CharacterModel character = seatCharacter.character.clone();
			int width = character.width;
			int height = character.height;
			Battle battle = seat.room.battle;
			//slide to born rect
			int fromRow = forward[1] == 1 ? 0 : battle.row - height;
			int[] thredshold;
			if (forward[1] == 1) {
				thredshold = new int[] {0, force.border};
			} else {
				thredshold = new int[] {force.border, battle.height};
			}
			int[] leftTop = null;
			if (Battle.STATE_PREPARING == battle.state) {
				while (true) {
					if (left < 0 || left + width > battle.col || fromRow < thredshold[0] || fromRow + height > thredshold[1]) {
						break;
					}
					List<BattleItem> collisions = battle.getCollision(new int[] {left, fromRow, left + width, fromRow + height});
					if (collisions.size() > 0) {
						break;
					} else {
						leftTop = new int[] {left, fromRow};
					}
					fromRow += forward[1];
				}
				if (leftTop != null) {
					BattleItem item = new BattleItem(true, 1, 1);
					item.instanceId = UUID.randomUUID().toString();
					item.character = seatCharacter.character.clone();
					item.forward = force.forward;
					item.cartoon = item.character.cartoon;
					item.left = leftTop[0];
					item.top = leftTop[1];
					item.hp = item.maxHp = 7;
					item.attackDamage = GMathUtil.random(3, 1);
					item.attackRects = item.character.attackRects;
					item.layer = "over";
					item.owner = seat;
					item.setTask(new TaskForward(battle, now + 1000, 3000L, forward, item));
					battle.addItem(item);
					battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_ADD, item));
				}
			} else if (Battle.STATE_PLAYING == battle.state) {
				boolean isBlock = false;
				while (true) {
					if (left < 0 || left + width > battle.col || fromRow < thredshold[0] || fromRow + height > thredshold[1]) {
						break;
					}
					List<BattleItem> collisions = battle.getCollision(new int[] {left, fromRow, left + width, fromRow + height});
					if (collisions.size() > 0) {
						isBlock = true;
						break;
					} else {
						leftTop = new int[] {left, fromRow};
					}
					fromRow += forward[1];
				}
				if (leftTop != null) {
					int[] followPos = null;
					if (!isBlock) {
						thredshold = new int[] {0, battle.height};
						c:while (true) {
							if (fromRow < thredshold[0] || fromRow + height > thredshold[1]) {
								followPos = null;
								break;
							}
							List<BattleItem> collisions = battle.getCollision(new int[] {left, fromRow, left + width, fromRow + height});
							//if first collision.owner is enemy break;
							if (collisions.size() > 0) {
								for (BattleItem collision : collisions) {
									if (collision.owner == seat) {
										break c;
									} else {
										followPos = null;
										break c;
									}
								}
							} else {
								followPos = new int[] {left, fromRow};
							}
							fromRow += forward[1];
						}
					}
					BattleItem item = new BattleItem(true, 1, 1);
					item.instanceId = UUID.randomUUID().toString();
					item.character = seatCharacter.character.clone();
					item.forward = force.forward;
					item.cartoon = item.character.cartoon;
					if (followPos != null) {
						item.left = followPos[0];
						item.top = followPos[1];
					} else {
						item.left = leftTop[0];
						item.top = leftTop[1];
					}
					item.hp = item.maxHp = 7;
					item.attackDamage = GMathUtil.random(3, 1);
					item.attackRects = item.character.attackRects;
					item.layer = "over";
					item.owner = seat;
					item.setTask(new TaskForward(battle, now + 1000, 3000L, forward, item));
					battle.addItem(item);
					battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_ADD, item));
				}
			} else {
				throw new Error();
			}
		}
	}
}
