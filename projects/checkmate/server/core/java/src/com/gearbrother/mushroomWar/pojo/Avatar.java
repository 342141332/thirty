package com.gearbrother.mushroomWar.pojo;

import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.databind.JsonNode;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;

/**
 * @author feng.lee
 * @create on 2014-2-17
 */
@RpcBeanPartTransportable(isPartTransport = true)
public class Avatar extends RpcBean {
	@RpcBeanProperty(desc = "")
	public String uuid;

	@RpcBeanProperty(desc = "")
	public String confId;
	
	@RpcBeanProperty(desc = "")
	public String name;

	public String headPortraint;

	@RpcBeanProperty(desc = "")
	public String cartoon;

	@RpcBeanProperty(desc = "")
	public List<AvatarLevel> levels;

	private AvatarLevel _level;

	@RpcBeanProperty(desc = "")
	public AvatarLevel getLevel() {
		return _level;
	}

	private int _exp;

	@RpcBeanProperty(desc = "经验")
	public void setExp(int value) {
		_exp = value;

		for (AvatarLevel level : levels) {
			if (_exp >= level.exp)
				_level = level;
		}
	}

	@RpcBeanProperty(desc = "经验")
	public int getExp() {
		return _exp;
	}

	@RpcBeanProperty(desc = "装备")
	public List<Equip> equips;
	
	@RpcBeanProperty(desc = "道具")
	public List<Skill> skills;
	public void addSkill(Skill newValue) {
		int at = skills.indexOf(newValue);
		if (at > -1) {
			skills.get(at).num++;
		} else {
			skills.add(newValue.clone());
		}
	}
	public void removeSkill(Skill newValue) {
		int at = skills.indexOf(newValue);
		if (at > -1) {
			newValue = skills.get(at);
			newValue.num--;
			if (newValue.num < 1)
				skills.remove(at);
		}
	}
	
	@RpcBeanProperty(desc = "简介")
	public String describe;

	private JsonNode json;

	public Avatar(JsonNode json) {
		this.json = json;
		this.name = json.get("name").asText();
		this.headPortraint = json.get("head").asText();
		this.cartoon = json.get("avatar").asText();
		this.describe = json.get("describe").asText();
		this.levels = new ArrayList<AvatarLevel>();
		/*ArrayNode levelsNode = (ArrayNode) json.get("levels");
		for (int i = 0; i < levelsNode.size(); i++) {
			AvatarLevel _level = new AvatarLevel(levelsNode.get(i));
			_level.id = i;
			this.levels.add(_level);
		}*/
		AvatarLevel _level = new AvatarLevel();
		_level.id = 0;
		this.levels.add(_level);
		equips = new ArrayList<Equip>();
		skills = new ArrayList<Skill>();
		setExp(0);
	}

	@Override
	public Avatar clone() {
		Avatar clone = new Avatar(json);
		clone.confId = confId;
		return clone;
	}
}
