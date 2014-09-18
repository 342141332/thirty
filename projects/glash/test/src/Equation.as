package {
	import com.gearbrother.glash.GMain;
	import com.gearbrother.glash.util.math.GMathUtil;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;


	/**
	 * @author lifeng
	 * @create on 2013-9-28
	 */
	public class Equation extends GMain {
		public function Equation() {
			super();

			var res:Array = GMathUtil.lineIntersectCircle(new Point(2, 2), 1, new Point(0, 1), new Point(4, 1));
			trace(res);
			return;
			var a:Number = 1;
			var b:Number = 2;
			var c:Number = 10;
			var Tal:Number; //判断是解的数量
			var x:Number; //方程式的解1
			var y:Number; //方程式的解2
			Tal = b * b - 4 * a * c;
			if (Tal > 0) {
				x = (-b + Math.sqrt(Tal)) / (2 * a); //sqrt是math.h中的求根函数
				y = (-b - Math.sqrt(Tal)) / (2 * a);
				trace("此一元二次方程式的解为：x=%.1f,y=%.1f。\n", x, y);
			} else if (Tal == 0) {
				x = (-b) / (2 * a);
				y = x;
				trace("此一元二次方程式的解只有一个：x=y=%.1f。", x);
			} else {
				trace("此一元二次方程式无解。");
			}
		}
	}
}
