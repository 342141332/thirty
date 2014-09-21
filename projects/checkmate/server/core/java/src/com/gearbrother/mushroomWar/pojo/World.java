package com.gearbrother.mushroomWar.pojo;

import java.util.HashMap;
import java.util.Map;

/**
 * 游戏根节点,所有Model的根
 * 
 * @author lifeng
 *
 */
public class World {
	static public final World instance = new World();

	final public Map<String, User> users;
	
	final public Map<String, Battle> battles;

	final public Hall hall;

	private World() {
		users = new HashMap<String, User>();
		battles = new HashMap<String, Battle>();
		hall = new Hall();
	}
}
