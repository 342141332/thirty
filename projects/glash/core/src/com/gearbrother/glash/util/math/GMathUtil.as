package com.gearbrother.glash.util.math {
	import flash.geom.Point;

	/**
	 * 数学相关方法
	 *
	 */
	public class GMathUtil {
		/**
		 * 将数值限制在一个区间内
		 *
		 * @param v	数值
		 * @param min	最大值
		 * @param max	最小值
		 *
		 */
		static public function limitIn(value:Number, min:Number, max:Number):Number {
			return value < min ? min : value > max ? max : value;
		}

		/**
		 * 返回的是数学意义上的atan（坐标系与Math.atan2上下颠倒）
		 *
		 * @param dx
		 * @param dy
		 * @return
		 *
		 */
		static public function atan2(dx:Number, dy:Number):Number {
			var a:Number;
			if (dx == 0)
				a = Math.PI / 2;
			else if (dx > 0)
				a = Math.atan(Math.abs(dy / dx));
			else
				a = Math.PI - Math.atan(Math.abs(dy / dx));

			return dy >= 0 ? a : -a;

		}

		/**
		 * 求和
		 *
		 * @param arr
		 * @return
		 *
		 */
		static public function sum(arr:Array):Number {
			var result:Number = 0.0;
			for each (var num:Number in arr)
				result += num;
			return result;
		}

		/**
		 * 平均值
		 *
		 * @param arr
		 * @return
		 *
		 */
		static public function avg(arr:Array):Number {
			return sum(arr) / arr.length;
		}

		/**
		 * 最大值
		 *
		 * @param arr
		 * @return
		 *
		 */
		static public function max(arr:Array):Number {
			var result:Number = NaN;
			for (var i:int = 0; i < arr.length; i++) {
				if (isNaN(result) || arr[i] > result)
					result = arr[i];
			}
			return result;
		}

		/**
		 * 最小值
		 *
		 * @param arr
		 * @return
		 *
		 */
		static public function min(arr:Array):Number {
			var result:Number = NaN;
			for (var i:int = 0; i < arr.length; i++) {
				if (isNaN(result) || arr[i] < result)
					result = arr[i];
			}
			return result;
		}

		/**
		 * 切割数值使用sin, 类似抛物线的数字切割
		 */
		static public function sinCut(value:Number, piece:int):Array {
			var pieces:Array = [];
			var levels:Array = [];
			for (var i:int = 1; i < piece + 1; i++) {
				levels.push(int(value * Math.sin(Math.PI / 2 * i / piece)));
			}
			var prevLevel:int = 0;
			for (var j:int = 0; j < levels.length; j++) {
				pieces.push(piece[j] - prevLevel);
				prevLevel = piece[j];
			}
			return pieces;
		}

		/**
		 * Returns the sign of the specified number, that is -1 if it is negative,
		 * 0 if it is zero and 1 if it positive.
		 */
		static public function sgn(n:int):int {
			return n == 0 ? 0 : (n > 0 ? 1 : -1);
		}

		/**
		 * Returns the largest integer smaller or equal to the specified one which
		 * is a multiple of the specified factor.
		 */
		static public function roundDownToMultiple(value:Number, factor:Number):Number {
			var a:Number = Math.abs(value) % factor;
			if (a == 0)
				return value;
			else if (value >= 0)
				return value - a;
			else
				return value - (factor - a);
		}

		/**
		 * Returns the smallest integer larger or equal to the specified one, which
		 * is a multiple of the specified factor.
		 */
		static public function roundUpToMultiple(value:Number, factor:Number):Number {
			var a:Number = Math.abs(value) % factor;
			if (a == 0)
				return value;
			else if (value >= 0)
				return value + (factor - a);
			else
				return value + a;
		}

		static public function sqr(x:Number):Number {
			return x * x;
		}

		static public function getRadian(fromPt:Point, toPt:Point):Number {
			var dx:Number = toPt.x - fromPt.x;
			var dy:Number = toPt.y - fromPt.y;
			return Math.atan2(dy, dx);
		}
		
		static public function getRadian2(fromPtX:Number, fromPtY:Number, toPtX:Number, toPtY:Number):Number {
			var dx:Number = toPtX - fromPtX;
			var dy:Number = toPtY - fromPtY;
			return Math.atan2(dy, dx);
		}
		
		/**
		 * 一元两次方程 ax^ + bx + c = 0;
		 * @param a
		 * @param b
		 * @param c
		 * @return Null if no result
		 * 
		 */		
		static public function getEquation(a:Number, b:Number, c:Number):Array {
			var tal:Number; //判断是解的数量
			var x:Number; //方程式的解1
			var y:Number; //方程式的解2
			tal = b * b - 4 * a * c;
			if (tal > 0) {
				x = (-b + Math.sqrt(tal)) / (2 * a); //sqrt是math.h中的求根函数
				y = (-b - Math.sqrt(tal)) / (2 * a);
				return [x, y];
			} else if (tal == 0) {
				x = (-b) / (2 * a);
				y = x;
				return [x];
			} else {
				return null;
			}
		}

		static public function lineIntersectCircle(center:Point, radius:int, lineFrom:Point, lineTo:Point):Array {
			var $a:Number = (lineTo.y - lineFrom.y) / (-lineFrom.x + lineTo.x);
			var $b:Number = (-lineFrom.x * lineTo.y + lineFrom.y * lineTo.x) / (-lineFrom.x + lineTo.x);
			var res:Array = getEquation(1 + Math.pow($a, 2), -2 * center.x + 2 * $a * $b - 2 * center.y * $a, Math.pow(center.x, 2) + Math.pow($b, 2) - 2 * center.y * $b + Math.pow(center.y, 2) - Math.pow(radius, 2));
			if (res) {
				var points:Array;
				var d:Number = Point.distance(lineFrom, lineTo);
				for each (var r:Number in res) {
					var intersect:Point = new Point(r, (r * lineTo.y - r * lineFrom.y - lineFrom.x * lineTo.y + lineFrom.y * lineTo.x) / (-lineFrom.x + lineTo.x));
					if (Point.distance(intersect, lineFrom) <= d && Point.distance(intersect, lineTo) <= d) {
						points ||= [];
						points.push(intersect);
					}
				}
				return points;
			} else {
				return res;
			}
		}
	}
}
