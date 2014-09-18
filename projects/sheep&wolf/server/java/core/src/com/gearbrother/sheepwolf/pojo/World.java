package com.gearbrother.sheepwolf.pojo;

import java.util.HashMap;
import java.util.Map;

import com.gearbrother.sheepwolf.model.ISession;

/**
 * 游戏根节点,所有Model的根
 * @author lifeng
 *
 */
public class World {
	final public Map<String, ISession> sessions;

	final public Hall hall;

	public World() {
		sessions = new HashMap<String, ISession>();
		hall = new Hall();
	}
}
