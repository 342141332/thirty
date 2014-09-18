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

	private Battle queue;

	public Task() {
		this(UUID.randomUUID().toString());
	}

	public Task(String instanceId) {
		super();

		this.instanceId = instanceId;
	}

	public void commit(long executeTime) {
		updateExecuteTime(executeTime, queue);
	}
	
	public void updateExecuteTime(long executeTime, Battle queue) {
		if (_nextExecuteTime != executeTime || this.queue != queue) {
			halt();
			_nextExecuteTime = executeTime;
			this.queue = queue;
			if (this.queue != null)
				this.queue.tasks.add(this);
		}
	}

	public void halt() {
		if (this.queue != null) {
			this.queue.tasks.remove(this);
			this.queue = null;
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
