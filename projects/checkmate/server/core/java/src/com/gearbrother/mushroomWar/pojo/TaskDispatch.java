package com.gearbrother.mushroomWar.pojo;

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

		Battle battle = seat.room.battle;
		BattleForce force = seat.force;
		int[] forward = force.forward;	//"forward"	[0, 1]

		//slide to born rect
		int[] bornRect = force.born;	//"born"	[0, 0, 9, 1]
		if (Battle.STATE_PREPARING == battle.state) {
			left = forward[0] == 1 ? bornRect[2] - 1 : (forward[0] == -1 ? bornRect[0] : Math.max(bornRect[0], Math.min(left, bornRect[2] - 1)));
			top = forward[1] == 1 ? bornRect[3] - 1 : (forward[1] == -1 ? bornRect[1] : Math.max(bornRect[1], Math.min(top, bornRect[3] - 1)));
		} else if (Battle.STATE_PLAYING == battle.state) {
			left = forward[0] == 1 ? bornRect[2] - 1 : (forward[0] == -1 ? bornRect[0] : Math.max(bornRect[0], Math.min(left, bornRect[2] - 1)));
			top = forward[1] == 1 ? bornRect[3] - 1 : (forward[1] == -1 ? bornRect[1] : Math.max(bornRect[1], Math.min(top, bornRect[3] - 1)));
		} else {
			throw new Error();
		}

		//slide to border
		if (forward[0] == 0 && forward[1] == 0) {
			throw new Error("forward can't be zero");
		} else {
			if (battle.getCollision(new int[] {left, top, left + seatCharacter.character.width, top + seatCharacter.character.height}).size() == 0) {
				BattleItem item = new BattleItem(true, 1, 1);
				item.instanceId = UUID.randomUUID().toString();
				item.character = seatCharacter.character.clone();
				item.forward = force.forward;
				item.cartoon = item.character.cartoon;
				item.left = left;
				item.top = top;
				item.hp = item.maxHp = 7;
				item.attackDamage = GMathUtil.random(3, 1);
				item.attackRects = item.character.attackRects;
				item.layer = "over";
				item.owner = seat;
				battle.addItem(item);
				item.setTask(new TaskForward(battle, now + 1000, 3000L, forward, item));
				while (force.border[0] <= left + forward[0] && left + forward[0] <= force.border[2]
						&& force.border[1] <= top + forward[1] && top + forward[1] <= force.border[3]
						&& battle.moveItem(item, left + forward[0], top + forward[1])) {
					left += forward[0];
					top += forward[1];
				}
				item.left = left;
				item.top = top;
				battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_ADD, item));
			} else {
				return;
			}
		}
	}
}
