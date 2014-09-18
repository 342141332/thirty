package com.gearbrother.mushroomWar.pojo;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.gearbrother.mushroomWar.Constant;

public class GameConf implements ApplicationContextAware {
	static Logger logger = LoggerFactory.getLogger(GameConf.class);
	
	static public GameConf instance;

	public Map<String, Skill> skills = new HashMap<String, Skill>();
	
	public Map<String, Skill> weapons = new HashMap<String, Skill>();
	
	public Map<String, Skill> tools = new HashMap<String, Skill>();
	
	public Map<String, Equip> equips = new HashMap<String, Equip>();
	
	public Skill invisible;
	
	public Skill speedUp;
	
	public Skill house;
	
	public Skill attack;
	
	public Map<String, Avatar> avatars = new HashMap<String, Avatar>();
	
	public Map<String, Battle> battles = new HashMap<String, Battle>();
	
	public GameConf() {
		instance = this;
	}

	@Override
	public void setApplicationContext(ApplicationContext context) throws BeansException {
		try {
			File skillFolder = context.getResource("WEB-INF/conf/skill").getFile();
			for (File skillFile : skillFolder.listFiles()) {
				if (skillFile.isFile() && skillFile.getName().equals(".svn") == false) {
					FileInputStream fileInputStream = new FileInputStream(skillFile);
					ArrayNode skillNodes = (ArrayNode) Constant.mapper.readTree(fileInputStream);
					for (JsonNode skillNode : skillNodes) {
						Skill skill = new Skill(skillNode);
						skills.put(skill.confId, skill);
						if (Skill.CATEGORY_WEAPON.equals(skill.category))
							weapons.put(skill.confId, skill);
						else if (Skill.CATEGORY_TOOL.equals(skill.category))
							tools.put(skill.confId, skill);
					}
					fileInputStream.close();
				}
			}
			invisible = weapons.get("0");
			speedUp = weapons.get("1");
			house = tools.get("house_0");
			attack = weapons.get("attack");

			File animalFolder = context.getResource("WEB-INF/conf/avatar").getFile();
			for (File animalFile : animalFolder.listFiles()) {
				if (animalFile.isFile() && animalFile.getName().equals(".svn") == false) {
					FileInputStream fileInputStream = new FileInputStream(animalFile);
					JsonNode avatarRoot = Constant.mapper.readTree(fileInputStream);
					for (Iterator<Entry<String, JsonNode>> iterator = avatarRoot.fields(); iterator.hasNext();) {
						Entry<String, JsonNode> avatarNode = (Entry<String, JsonNode>) iterator.next();
						Avatar avatar = new Avatar(avatarNode.getValue());
						avatar.confId = avatarNode.getKey();
						avatars.put(avatar.confId, avatar);
					}
					fileInputStream.close();
				}
			}

			File sceneFolder = context.getResource("WEB-INF/conf/scene").getFile();
			for (File mapFile : sceneFolder.listFiles()) {
				if (mapFile.isFile() && mapFile.getName().equals(".svn") == false && mapFile.getName().endsWith(".bak") == false) {
					FileInputStream mapInputStream = new FileInputStream(mapFile);
					JsonNode mapNode = Constant.mapper.readTree(mapInputStream);
					Battle battle = new Battle(mapNode);
					battle.confId = mapFile.getName();
					battles.put(mapFile.getName(), battle);
					mapInputStream.close();
				}
			}
		} catch (IOException e) {
			// logger.error(e.)
			e.printStackTrace();
		}
	}
}
