package com.gearbrother.mushroomWar.pojo;

import java.util.Vector;

import com.gearbrother.mushroomWar.model.ISession;

public class SessionObserver {
	private Vector<ISession> obs;

	public SessionObserver() {
		obs = new Vector<ISession>();
	}

	public synchronized void addObserver(ISession o) {
		if (o == null)
			throw new NullPointerException();
		if (!obs.contains(o)) {
			obs.addElement(o);
		}
	}

	public synchronized void deleteObserver(ISession o) {
		obs.removeElement(o);
	}

	public void notifySessions(Object message) {
		Object[] arrLocal;

		synchronized (this) {
			arrLocal = obs.toArray();
		}

		for (int i = arrLocal.length - 1; i >= 0; i--)
			((ISession) arrLocal[i]).send(message);
	}
}
