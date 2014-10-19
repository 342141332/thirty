package com.gearbrother.mushroomWar.pojo;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.mushroomWar.rpc.annotation.RpcBeanProperty;

/**
 * @author feng.lee
 * @create on 2014-3-6
 */
@RpcBeanPartTransportable
public class CharacterLevel extends RpcBean {
	@RpcBeanProperty(desc = "等级")
	public int id;

	@RpcBeanProperty(desc = "")
	public int exp;

	@RpcBeanProperty(desc = "")
	public int hp;

	@RpcBeanProperty(desc = "")
	public int armor;

	@RpcBeanProperty(desc = "攻击范围数组")
	public int[][] attackRects;

	@RpcBeanProperty(desc = "攻击力上下限")
	public int[] attackDamage;
	
	@RpcBeanProperty(desc = "攻击间隔")
	public long interval;

	public CharacterLevel() {
	}

	public CharacterLevel(JsonNode node) {
		exp = node.get("exp").asInt();
		hp = node.get("hp").asInt();
		if (node.has("attackRects")) {
			ArrayNode attackRectsNode = (ArrayNode) node.get("attackRects");
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
			this.attackRects[0] = new int[] { 0, -1, 1, 0 };
		}
		this.interval = node.get("interval").asLong();
		ArrayNode attackDamageNode = (ArrayNode) node.get("attackDamage");
		this.attackDamage = new int[] {attackDamageNode.get(0).asInt(), attackDamageNode.get(1).asInt()};
	}
}
