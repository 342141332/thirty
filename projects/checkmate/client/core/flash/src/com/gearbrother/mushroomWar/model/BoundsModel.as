package com.gearbrother.mushroomWar.model {
	import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BoundsProtocol;

	public class BoundsModel extends BoundsProtocol {
		public function get left():int {
			return x;
		}
		public function set left(newValue:int):void {
			width = Math.max(0, right - newValue);
			x = newValue;
		}
		
		public function get top():int {
			return y;
		}
		
		public function set top(newValue:int):void {
			height = Math.max(0, bottom - newValue);
			y = newValue;
		}
		
		public function get right():int {
			return x + width;
		}
		
		public function set right(newValue:int):void {
			width = Math.max(0, newValue - x);
		}
		
		public function get bottom():int {
			return y + height;
		}
		
		public function set bottom(newValue:int):void {
			height = Math.max(0, newValue - y);
		}
		
		public function BoundsModel(prototype:Object = null) {
			super(prototype);
		}
		
		public function intersect(r:BoundsProtocol):Boolean {
			var tw:Number = this.width;
			var th:Number = this.height;
			var rw:Number = r.width;
			var rh:Number = r.height;
			if (rw <= 0 || rh <= 0 || tw <= 0 || th <= 0) {
				return false;
			}
			var tx:Number = this.x;
			var ty:Number = this.y;
			var rx:Number = r.x;
			var ry:Number = r.y;
			rw += rx;
			rh += ry;
			tw += tx;
			th += ty;
			//      overflow || intersect
			return ((rw < rx || rw > tx) &&
				(rh < ry || rh > ty) &&
				(tw < tx || tw > rx) &&
				(th < ty || th > ry));
		}
		
		public function encode():Object {
			return {"x": x
				, "y": y
				, "width": width
				, "height": height
			};
		}
		
		public function decode(obj:Object):BoundsModel {
			x = obj.x;
			y = obj.y;
			width = obj.width;
			height = obj.height;
			return this;
		}
	}
}
