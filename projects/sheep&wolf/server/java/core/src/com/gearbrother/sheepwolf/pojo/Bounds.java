package com.gearbrother.sheepwolf.pojo;

import com.fasterxml.jackson.databind.JsonNode;
import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanProperty;

@RpcBeanPartTransportable
public class Bounds extends RpcBean {
	@RpcBeanProperty(desc = "x")
	public double x;

	@RpcBeanProperty(desc = "y")
	public double y;

	@RpcBeanProperty(desc = "width")
	public double width;

	@RpcBeanProperty(desc = "height")
	public double height;

	public Bounds() {
	}

	public Bounds(JsonNode json) {
		this(json.get("x").asDouble(), json.get("y").asDouble(), json.get("width").asDouble(), json.get("height").asDouble());
	}

	public Bounds(double x, double y, double width, double height) {
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
	}

	static public boolean intersects(double x1, double y1, double w1, double h1
			, double x, double y, double w, double h) {
		double tw = w1;
		double th = h1;
		double rw = w;
		double rh = h;
		if (rw <= 0 || rh <= 0 || tw <= 0 || th <= 0) {
			return false;
		}
		double tx = x1;
		double ty = y1;
		double rx = x;
		double ry = y;
		rw += rx;
		rh += ry;
		tw += tx;
		th += ty;
		// overflow || intersect
		return ((rw < rx || rw > tx) && (rh < ry || rh > ty) && (tw < tx || tw > rx) && (th < ty || th > ry));
	}
}
