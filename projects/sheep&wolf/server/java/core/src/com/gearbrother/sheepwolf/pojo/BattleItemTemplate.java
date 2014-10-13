package com.gearbrother.sheepwolf.pojo;

import com.fasterxml.jackson.databind.JsonNode;
import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanProperty;

@RpcBeanPartTransportable
public class BattleItemTemplate extends RpcBean {
	@RpcBeanProperty(desc = "所在层")
	public String layer;

	@RpcBeanProperty(desc = "")
	public double width;

	@RpcBeanProperty(desc = "")
	public double height;

	@RpcBeanProperty(desc = "")
	public String cartoon;

	@RpcBeanProperty(desc = "")
	public String touchLocalCall;

	@RpcBeanProperty(desc = "")
	public JsonNode touchLocalCallParams;

	@RpcBeanProperty(desc = "")
	public String touchAutoRemoteCall;

	@RpcBeanProperty(desc = "")
	public JsonNode touchAutoRemoteCallParams;

	@RpcBeanProperty(desc = "")
	public String touchManualRemoteCall;

	@RpcBeanProperty(desc = "")
	public JsonNode touchManualRemoteCallParams;

	@RpcBeanProperty(desc = "是否会碰撞")
	public boolean isCollisionable;

	@RpcBeanProperty(desc = "")
	public boolean isSheepPassable;

	@RpcBeanProperty(desc = "")
	public boolean isWolfPassable;

	public BattleItemTemplate(JsonNode json) {
		this.layer = json.get("layer").asText();
		this.width = json.get("width").asDouble();
		this.height = json.get("height").asDouble();
		this.cartoon = json.get("cartoon").asText();
		this.touchLocalCall = json.hasNonNull("touchLocalCall") ? json.get("touchLocalCall").asText() : null;
		this.touchLocalCallParams = json.get("touchLocalCallParams");
		this.touchAutoRemoteCall = json.hasNonNull("touchAutoRemoteCall") ? json.get("touchAutoRemoteCall").asText() : null;
		this.touchAutoRemoteCallParams = json.get("touchAutoRemoteCallParams");
		this.touchManualRemoteCall = json.hasNonNull("touchManualRemoteCall") ? json.get("touchManualRemoteCall").asText() : null;
		this.touchManualRemoteCallParams = json.get("touchManualRemoteCallParams");
		this.isCollisionable = json.get("isCollisionable").asBoolean();
		this.isSheepPassable = json.get("isSheepPassable").asBoolean();
		this.isWolfPassable = json.get("isWolfPassable").asBoolean();
	}
}
