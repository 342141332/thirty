package com.gearbrother.sheepwolf.pojo;

import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanProperty;

/**
 * @author feng.lee
 * @create on 2014-6-4
 */
@RpcBeanPartTransportable
public class Skill extends RpcBean implements IBagItem {
	static public final String CATEGORY_WEAPON = "weapon";
	
	static public final String CATEGORY_TOOL = "tool";
	
	static public final String CATEGORY_EQUIP = "equip";
	
/**
	//狼狼独有技能
	static public final BattleSkill ATTACK 			= new BattleSkill("w1"	,"攻击"				,0l			,1000l		,-1	, null, "_attack");
	
	//羊羊独有技能
	static public final BattleSkill EAT_GRASS 		= new BattleSkill("s1"	,"吃草"				,1000l		,0l			,-1	,"_eatGrass");
	static public final BattleSkill BUILD_HOUSE 	= new BattleSkill("s2"	,"造羊羊小屋"			,0l			,500l		,-1	,"_buildHouse");
	static public final BattleSkill RESCUE 			= new BattleSkill("s3"	,"营救"				,0l			,10000l		,-1	,"_rescue");
	static public final BattleSkill BLINK 			= new BattleSkill("s4"	,"跳跃"				,0l			,10000l		,0	,"_blink");
	
	//共有技能
	static public final BattleSkill DARK_NIGHT 		= new BattleSkill("1"	,"创造黑夜"			,0l			,10000l		,1	,"_darkNight"			,new Object[] {10 * 1000});
	static public final BattleSkill SLOWDOWN 		= new BattleSkill("2"	,"周围减速"			,0l			,10000l		,1	,"_slowDown"			,new Object[] {.5, 10 * 1000});
	static public final BattleSkill INVISIBLE 		= new BattleSkill("3"	,"隐形药水"			,0l			,10000l		,1	,"_invisible"			,new Object[] {10 * 1000});
	static public final BattleSkill SPEED_UP 		= new BattleSkill("4"	,"大加速药水"			,0l			,10000l		,1	,"_changeSpeed"			,new Object[] {2.5, 10 * 1000});
	static public final BattleSkill POWER_UP 		= new BattleSkill("5"	,"强力药水"			,0l			,10000l		,1	,"_changeAbilityDamage"	,new Object[] {5, 10 * 1000});
**/
	
	@RpcBeanProperty(desc = "归类id")
	public String confId;
	
	@RpcBeanProperty(desc = "name")
	public String name;
	
	@RpcBeanProperty(desc = "catagory")
	public String category;

	@RpcBeanProperty(desc = "剩余数量, -1表示无限, >-1则为实际数量")
	public int num;

	private int bagIndex;
	@Override
	public int getBagIndex() {
		return bagIndex;
	}
	public void setBagIndex(int newValue) {
		bagIndex = newValue;
	}

	@RpcBeanProperty(desc = "上一次使用时间")
	public long lastUseTime;
	
	private int exp;
	@RpcBeanProperty(desc = "经验")
	public int getExp() {
		return exp;
	}
	@RpcBeanProperty(desc = "经验")
	public void setExp(int newValue) {
		exp = newValue;
		
		for (SkillLevel level : levels) {
			if (exp >= level.exp)
				_level = level;
		}
	}
	
	private SkillLevel _level;
	@RpcBeanProperty(desc = "等级信息")
	public SkillLevel getLevel() {
		return _level;
	}
	
	@RpcBeanProperty(desc = "")
	public String icon;
	
	@RpcBeanProperty(desc = "")
	public String description;
	
	@RpcBeanProperty(desc = "")
	public List<SkillLevel> levels;
	
	private JsonNode _node;

	public Skill(JsonNode node) {
		_node = node;
		this.confId = node.get("id").asText();
		this.name = node.get("name").asText();
		this.num = node.get("num").asInt();
		this.category = node.get("category").asText();
		this.icon = node.get("icon").asText();
		this.levels = new ArrayList<SkillLevel>();
		ArrayNode levelsNode = (ArrayNode) node.get("levels");
		for (int i = 0; i < levelsNode.size(); i++) {
			SkillLevel levelProperty = new SkillLevel(levelsNode.get(i));
			levelProperty.id = i;
			this.levels.add(levelProperty);
		}
		setExp(0);
	}
	
	public Skill() {
	}
	
	@Override
	public Skill clone() {
		return new Skill(_node);
	}
	
	@Override
	public int hashCode() {
		return confId.hashCode();
	}
	
	@Override
	public boolean equals(Object obj) {
		if (obj instanceof Skill) {
			return ((Skill) obj).confId.equals(confId);
		} else {
			return false;
		}
	}
}