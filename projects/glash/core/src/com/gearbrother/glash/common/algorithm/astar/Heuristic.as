package com.gearbrother.glash.common.algorithm.astar {
	
	/**
	 * @author lifeng
	 * @create on 2013-7-28
	 */
	public class Heuristic {
		/**
		 * Manhattan distance.
		 * @param {number} dx - Difference in x.
		 * @param {number} dy - Difference in y.
		 * @return {number} dx + dy
		 */
		static public function manhattan(dx:Number, dy:Number):Number {
			return dx + dy;
		}
		
		/**
		 * Euclidean distance.
		 * @param {number} dx - Difference in x.
		 * @param {number} dy - Difference in y.
		 * @return {number} sqrt(dx * dx + dy * dy)
		 */
		static public function euclidean(dx:Number, dy:Number):Number {
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		/**
		 * Chebyshev distance.
		 * @param {number} dx - Difference in x.
		 * @param {number} dy - Difference in y.
		 * @return {number} max(dx, dy)
		 */
		static public function chebyshev(dx:Number, dy:Number):Number {
			return Math.max(dx, dy);
		}
	}
}