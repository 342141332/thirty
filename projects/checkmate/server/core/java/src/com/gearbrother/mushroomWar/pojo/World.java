package com.gearbrother.mushroomWar.pojo;

import java.util.HashMap;
import java.util.Map;

import com.gearbrother.mushroomWar.model.ISession;

/**
 * 游戏根节点,所有Model的根
 * 
 * @author lifeng
 *
 */
public class World extends SessionGroup {
	static public final World instance = new World();

	final public Map<String, ISession> sessions;
	
	final public Map<String, Battle> battles;

	final public Hall hall;

	private World() {
		sessions = new HashMap<String, ISession>();
		battles = new HashMap<String, Battle>();
		hall = new Hall();
	}
}
