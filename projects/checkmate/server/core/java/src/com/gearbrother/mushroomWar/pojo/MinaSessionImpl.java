package com.gearbrother.mushroomWar.pojo;

import java.util.Iterator;

import org.apache.mina.core.session.IoSession;

import com.gearbrother.mushroomWar.model.ISession;

/**
 * @author feng.lee
 * @create on 2013-12-6
 */
public class MinaSessionImpl implements ISession {
	final private IoSession session;
	
	final private World world;
	
	private User logined;

	@Override
	public User getLogined() {
		return logined;
	}

	@Override
	public void setLogined(User value) {
		logined = value;
	}

	private Hall enteredHall;

	public Hall getEnteredHall() {
		return enteredHall;
	}

	public void setEnteredHall(Hall value) {
		this.enteredHall = value;
	}

	private BattlePlayer player;

	public BattlePlayer getPlayer() {
		return player;
	}

	public void setPlayer(BattlePlayer value) {
		this.player = value;
	}

	public MinaSessionImpl(IoSession session, World world) {
		super();

		this.session = session;
		this.world = world;
		this.world.connectedSessions.add(this);
	}

	public void send(Object message) {
		session.write(message);
	}

	@Override
	public void close() {
		this.world.connectedSessions.remove(this);
		if (this.logined != null) {
			this.world.loginedSessions.remove(this.logined.uuid);
			if (this.enteredHall != null)
				this.enteredHall.observer.deleteObserver(this);
			if (this.player != null) {
				this.player.force.players.remove(this.player);
				this.player.battle.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_REMOVE, this.player));
				int roomPlayers = 0;
				for (Iterator<String> iterator = this.player.battle.forces.keySet().iterator(); iterator.hasNext();) {
					String id = (String) iterator.next();
					BattleForce force = this.player.battle.forces.get(id);
					for (BattlePlayer roomPlayer : force.players) {
						roomPlayers += roomPlayer.user == null ? 0 : 1;
					}
				}
				if (roomPlayers == 0) {
					if (this.world.hall.preparingBattles.remove(this.player.battle.instanceUuid, this.player.battle))
						this.world.hall.observer.notifySessions(new PropertyEvent(PropertyEvent.TYPE_REMOVE, this.player.battle));
					if (this.world.runningBattles.remove(this.player.battle.instanceUuid, this.player.battle)) {
					}
				}
			}
		}
	}
}
