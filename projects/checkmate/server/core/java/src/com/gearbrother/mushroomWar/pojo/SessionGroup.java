package com.gearbrother.mushroomWar.pojo;

import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;

import com.gearbrother.mushroomWar.model.ISession;

public class SessionGroup extends RpcBean {
	final private Set<ISession> _sessions;
	public int getSessionSize() {
		return _sessions.size();
	}
	public boolean addSession(ISession value) {
		return _sessions.add(value);
	}
	public boolean removeSession(ISession value) {
		return _sessions.remove(value);
	}
	
	public SessionGroup() {
		_sessions = new HashSet<ISession>();
	}

	public void board(Object message) {
		for (Iterator<ISession> iterator = _sessions.iterator(); iterator.hasNext();) {
			ISession roomSession = (ISession) iterator.next();
			roomSession.send(message);
		}
	}
}
