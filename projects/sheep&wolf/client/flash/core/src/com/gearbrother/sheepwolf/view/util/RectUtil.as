package com.gearbrother.sheepwolf.view.util {

	/**
	 *
	 * @author 	Neo.Zhang
	 * @create 	2014-8-22 下午6:16:01
	 *
	 */
	public class RectUtil {
		static public function intersects(x1:Number, y1:Number, w1:Number, h1:Number
			, x:Number, y:Number, w:Number, h:Number):Boolean {
			var tw:Number = w1;
			var th:Number = h1;
			var rw:Number = w;
			var rh:Number = h;
			if (rw <= 0 || rh <= 0 || tw <= 0 || th <= 0) {
				return false;
			}
			var tx:Number = x1;
			var ty:Number = y1;
			var rx:Number = x;
			var ry:Number = y;
			rw += rx;
			rh += ry;
			tw += tx;
			th += ty;
			// overflow || intersect
			return ((rw < rx || rw > tx) && (rh < ry || rh > ty) && (tw < tx || tw > rx) && (th < ty || th > ry));
		}
	}
}
