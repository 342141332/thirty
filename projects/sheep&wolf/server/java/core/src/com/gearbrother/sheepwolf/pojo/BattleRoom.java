package com.gearbrother.sheepwolf.pojo;

import java.util.Timer;
import java.util.UUID;

import com.gearbrother.sheepwolf.model.ISession;
import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanProperty;
import com.gearbrother.sheepwolf.util.GMathUtil;

/**
 * @author feng.lee
 * @create on 2013-11-27
 */

@RpcBeanPartTransportable(isPartTransport = true)
public class BattleRoom extends BoardRoom {
	@RpcBeanProperty(desc = "唯一id")
	public String uuid;

	@RpcBeanProperty(desc = "房间名字")
	public String name;

	@RpcBeanProperty(desc = "战斗")
	public Battle battle;
	
	@RpcBeanProperty(desc = "")
	public BattleRoomSeat[] seats;
	
	@RpcBeanProperty(desc = "")
	public int blueMax;
	
	@RpcBeanProperty(desc = "")
	public int redMax;

	private Hall parent;

	public BattleRoom(Hall parent, int blueMax, int redMax) {
		super();

		uuid = UUID.randomUUID().toString();
		seats = new BattleRoomSeat[blueMax + redMax];
		this.blueMax = blueMax;
		this.redMax = redMax;
		this.parent = parent;
		this.parent.rooms.put(uuid, this);
	}
	
	@Override
	public boolean removeSession(ISession value) {
		boolean res = super.removeSession(value);
		if (getSessions().size() == 0) {
			parent.rooms.remove(this);
		}
		return res;
	}
	
	//TODO写在这里是否好?
	private Timer timer;

	public void play() {
		battle.startTime = System.currentTimeMillis();
		for (int i = 0; i < seats.length; i++) {
			BattleRoomSeat seat = seats[i];
			if (seat != null) {
				BattleItemUser battleUser = new BattleItemUser(seat);
				battleUser.color = i < blueMax ? BattleColor.WOLF : BattleColor.SHEEP;
				if (battleUser.color == BattleColor.WOLF)
					battleUser.addSkill(GameConf.instance.attack);
				battleUser.originalAbilityDamage = 4;
				Bounds bounds = battleUser.color == BattleColor.SHEEP ? battle.sheepBornBounds : battle.wolfBornBounds;
				double x = bounds.x + GMathUtil.random(bounds.width);
				double y = bounds.y + GMathUtil.random(bounds.height);
				battleUser.x = x;
				battleUser.y = y;
				battleUser.lifes = 3;
				battleUser.money = battleUser.color == BattleColor.WOLF ? Battle.INIT_WOLF_MONEY : Battle.INIT_SHEEP_MONEY;
				battleUser.direction = (Integer) GMathUtil.random(Direction.All);
				battleUser.currentAction = BattleUserActionWalk.buildStop(battle.startTime
						, new PointBean(x, y)
						, battleUser.direction
						, battleUser);
				battleUser.setBattle(battle);
			}
		}
		if (timer == null)
			timer = new Timer();
//		TimerTask task = new TimerTask() {   
//			public void run() {
//				int total = GMathUtil.random(3, 1);
//				for (int i = 0; i < total; i++) {
//					BattleItemCoin coin = new BattleItemCoin(10);
//					coin.setBattle(battle);
//					coin.bounds.x = GMathUtil.random(battle.col * battle.cellPixel);
//					coin.bounds.y = GMathUtil.random(battle.row * battle.cellPixel);
//					coin.bounds.height = coin.bounds.width = battle.cellPixel;
//					board(new BattleSignalBattleItemChange(BattleSignalBattleItemChange.TYPE_ADD, coin));
//				}
//				play();
//			}
//		};
//		timer.schedule(task, GMathUtil.random(60, 20) * 1000);
	}
	
	public void stop() {
		timer.cancel();
	}
	
	public void close() {
		parent.rooms.remove(uuid);
		parent = null;
	}
}
