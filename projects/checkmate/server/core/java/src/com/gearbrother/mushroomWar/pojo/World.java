package com.gearbrother.mushroomWar.pojo;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.gearbrother.mushroomWar.model.ISession;

/**
 * 游戏根节点,所有Model的根
 * 
 * @author lifeng
 *
 */
public class World {
	static public final World instance = new World();

	final public List<ISession> connectedSessions;

	final public Map<String, ISession> loginedSessions;

	final public Hall hall;

	final public Map<String, BattleRoom> runningBattles;

	private World() {
		connectedSessions = new ArrayList<ISession>();
		loginedSessions = new HashMap<String, ISession>();
		hall = new Hall();
		runningBattles = Collections.synchronizedMap(new HashMap<String, BattleRoom>());
	}
}
