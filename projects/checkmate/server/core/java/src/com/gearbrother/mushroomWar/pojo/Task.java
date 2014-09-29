package com.gearbrother.mushroomWar.pojo;

import java.util.UUID;

abstract public class Task extends RpcBean {
	final public String instanceId;

	private long executeTime;
	public long getExecuteTime() {
		return executeTime;
	}
	public void setExecuteTime(long value) {
		if (executeTime != value) {
			battle.taskQueue.remove(this);
			executeTime = value;
			battle.taskQueue.add(this);
		}
	}
	public void halt() {
		battle.taskQueue.remove(this);
	}

	final public Battle battle;

	public Task(Battle battle, long executeTime) {
		this(battle, executeTime, UUID.randomUUID().toString());
	}

	public Task(Battle battle, long executeTime, String instanceId) {
		super();

		this.battle = battle;
		this.instanceId = instanceId;
		this.executeTime = executeTime;
		this.battle.taskQueue.add(this);
	}

	public abstract void execute(long now);

	@Override
	public int hashCode() {
		return instanceId.hashCode();
	}

	@Override
	public boolean equals(Object obj) {
		if (obj instanceof Task) {
			return instanceId.equals(((Task) obj).instanceId);
		} else {
			return false;
		}
	}
}
