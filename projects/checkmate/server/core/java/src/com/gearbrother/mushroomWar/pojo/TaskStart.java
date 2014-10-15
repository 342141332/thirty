package com.gearbrother.mushroomWar.pojo;

public class TaskStart extends Task {
	public TaskStart(Battle battle, long executeTime) {
		super(battle, executeTime);
	}

	@Override
	public void execute(long now) {
		battle.state = Battle.STATE_PLAYING;
	}
}
