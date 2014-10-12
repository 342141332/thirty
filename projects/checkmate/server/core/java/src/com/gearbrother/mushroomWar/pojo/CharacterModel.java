package com.gearbrother.mushroomWar.pojo;

import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;

/**
 * @author feng.lee
 * @create on 2014-2-17
 */
@RpcBeanPartTransportable(isPartTransport = true)
public class CharacterModel extends RpcBean {
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
	public List<CharacterLevel> levels;

	private CharacterLevel _level;

	@RpcBeanProperty(desc = "")
	public CharacterLevel getLevel() {
		return _level;
	}

	private int _exp;

	@RpcBeanProperty(desc = "经验")
	public void setExp(int value) {
		_exp = value;

		for (CharacterLevel level : levels) {
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

	@RpcBeanProperty(desc = "金币")
	public int coin;

	@RpcBeanProperty(desc = "碰撞")
	public int[] collision;

	public CharacterModel(JsonNode json) {
		this.json = json;
		this.name = json.get("name").asText();
		this.headPortraint = json.get("head").asText();
		this.cartoon = json.get("avatar").asText();
		this.describe = json.get("describe").asText();
		this.levels = new ArrayList<CharacterLevel>();
		/*ArrayNode levelsNode = (ArrayNode) json.get("levels");
		for (int i = 0; i < levelsNode.size(); i++) {
			AvatarLevel _level = new AvatarLevel(levelsNode.get(i));
			_level.id = i;
			this.levels.add(_level);
		}*/
		CharacterLevel _level = new CharacterLevel();
		_level.id = 0;
		this.levels.add(_level);
		equips = new ArrayList<Equip>();
		skills = new ArrayList<Skill>();
		if (json.has("coin")) {
			this.coin = json.get("coin").asInt();
		}
		if (json.has("collision")) {
			ArrayNode collisionNode = (ArrayNode) json.get("collision");
			this.collision = new int[collisionNode.size()];
			for (int i = 0; i < collisionNode.size(); i++) {
				this.collision[i] = collisionNode.get(i).asInt();
			}
		}
		setExp(0);
	}

	@Override
	public CharacterModel clone() {
		CharacterModel clone = new CharacterModel(json);
		clone.confId = confId;
		return clone;
	}
}
