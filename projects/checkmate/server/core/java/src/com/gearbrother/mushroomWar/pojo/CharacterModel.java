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

	@RpcBeanProperty(desc = "")
	public int width;
	
	@RpcBeanProperty(desc = "")
	public int height;

	@RpcBeanProperty(desc = "攻击范围数组")
	public int[][] attackRects;

	public CharacterModel(JsonNode json) {
		this.json = json;
		this.name = json.get("name").asText();
		this.headPortraint = json.get("head").asText();
		this.cartoon = json.get("avatar").asText();
		this.describe = json.get("describe").asText();
		if (json.has("attackRects")) {
			ArrayNode attackRectsNode = (ArrayNode) json.get("attackRects");
			this.attackRects = new int[attackRectsNode.size()][];
			for (int i = 0; i < attackRectsNode.size(); i++) {
				ArrayNode attackRectNode = (ArrayNode) attackRectsNode.get(i);
				this.attackRects[i] = new int[4];
				this.attackRects[i][0] = attackRectNode.get(0).asInt();
				this.attackRects[i][1] = attackRectNode.get(1).asInt();
				this.attackRects[i][2] = attackRectNode.get(2).asInt();
				this.attackRects[i][3] = attackRectNode.get(3).asInt();
			}
		} else {
			this.attackRects = new int[1][];
			this.attackRects[0] = new int[] {0, -1, 1, 0};
		}
		this.levels = new ArrayList<CharacterLevel>();
		if (json.has("levels")) {
			ArrayNode levelsNode = (ArrayNode) json.get("levels");
			for (int i = 0; i < levelsNode.size(); i++) {
				CharacterLevel _level = new CharacterLevel(levelsNode.get(i));
				_level.id = i;
				this.levels.add(_level);
			}
		} else {
			CharacterLevel _level = new CharacterLevel();
			_level.id = 0;
			this.levels.add(_level);
		}
		equips = new ArrayList<Equip>();
		skills = new ArrayList<Skill>();
		if (json.has("coin")) {
			this.coin = json.get("coin").asInt();
		}
		width = height = 1;
		setExp(0);
	}

	@Override
	public CharacterModel clone() {
		CharacterModel clone = new CharacterModel(json);
		clone.confId = confId;
		return clone;
	}
}
