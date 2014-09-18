package com.gearbrother.sheepwolf.pojo;

import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;

import com.gearbrother.sheepwolf.model.ISession;

public class BoardRoom extends RpcBean {
	final private Set<ISession> _sessions;
	public Set<ISession> getSessions() {
		return _sessions;
	}
	public boolean addSession(ISession value) {
		return _sessions.add(value);
	}
	public boolean removeSession(ISession value) {
		return _sessions.remove(value);
	}
	
	public BoardRoom() {
		_sessions = new HashSet<ISession>();
	}

	public void board(Object message) {
		for (Iterator<ISession> iterator = _sessions.iterator(); iterator.hasNext();) {
			ISession roomSession = (ISession) iterator.next();
			roomSession.send(message);
		}
	}
}
