package com.gearbrother.mushroomWar.pojo;

import java.util.UUID;

abstract public class Task extends RpcBean {
	final public String instanceId;

	private long executeTime;
	public long getExecuteTime() {
		return executeTime;
	}
	public void setExecuteTime(long value) {
		if (_isInQueue) {
			halt();
		}
		executeTime = value;
		battle.tasks.add(this);
		_isInQueue = true;
	}
	public void halt() {
		if (_isInQueue) {
			if (battle.tasks.remove(this))
				_isInQueue = false;
			else
				throw new Error("");
		}
	}
	
	private boolean _isInQueue;
	public boolean getIsInQueue() {
		return _isInQueue;
	}
	public void setIsInQueue(boolean value) {
		_isInQueue = value;
	}

	final public Battle battle;

	public Task(Battle battle, long executeTime) {
		this(battle, executeTime, UUID.randomUUID().toString());
	}

	public Task(Battle battle, long executeTime, String instanceId) {
		super();

		this.battle = battle;
		this.instanceId = instanceId;
		setExecuteTime(executeTime);
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
