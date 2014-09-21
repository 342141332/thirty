package com.gearbrother.mushroomWar.pojo;

import java.util.UUID;

import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;

abstract public class Task extends RpcBean {
	@RpcBeanProperty(desc = "实例唯一id")
	final public String instanceId;

	private long _nextExecuteTime;
	@RpcBeanProperty(desc = "下次执行时间")
	public long getNextExecuteTime() {
		return _nextExecuteTime;
	}

	protected BattleRoom battleRoom;

	public Task() {
		this(UUID.randomUUID().toString());
	}

	public Task(String instanceId) {
		super();

		this.instanceId = instanceId;
	}

	public void commit(long executeTime) {
		updateExecuteTime(executeTime, battleRoom);
	}

	public void updateExecuteTime(long executeTime, BattleRoom queue) {
		if (_nextExecuteTime != executeTime || this.battleRoom != queue) {
			halt();
			_nextExecuteTime = executeTime;
			this.battleRoom = queue;
			if (this.battleRoom != null)
				this.battleRoom.tasks.add(this);
		}
	}

	public void halt() {
		if (this.battleRoom != null) {
			this.battleRoom.tasks.remove(this);
			this.battleRoom = null;
		}
	}

	public abstract void execute(long executeTime);

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
