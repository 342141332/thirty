package com.gearbrother.glash.common.algorithm.astar {

	/**
	 * @author lifeng
	 * @create on 2013-7-30
	 */
	public class Util {
		/**
		 * Backtrace according to the parent records and return the path.
		 * (including both start and end nodes)
		 * @param {Node} node End node
		 * @return {Array.<Array.<number>>} the path
		 */
		static public function backtrace(node:Node):Array {
			var path:Array = [[node.x, node.y]];
			while (node.parent) {
				node = node.parent;
				path.push([node.x, node.y]);
			}
			return path.reverse();
		}

		/**
		 * Backtrace from start and end node, and return the path.
		 * (including both start and end nodes)
		 * @param {Node}
		 * @param {Node}
		 */
		static public function biBacktrace(nodeA:Node, nodeB:Node):Array {
			var pathA:Array = backtrace(nodeA), pathB:Array = backtrace(nodeB);
			return pathA.concat(pathB.reverse());
		}

		/**
		 * Compute the length of the path.
		 * @param {Array.<Array.<number>>} path The path
		 * @return {number} The length of the path
		 */
		static public function pathLength(path:Array):Number {
			var sum:int = 0;
			var a:Node;
			var b:Node;
			var dx:int;
			var dy:int;
			for (var i:int = 1; i < path.length; ++i) {
				a = path[i - 1];
				b = path[i];
				dx = a[0] - b[0];
				dy = a[1] - b[1];
				sum += Math.sqrt(dx * dx + dy * dy);
			}
			return sum;
		}


		/**
		 * Given the start and end coordinates, return all the coordinates lying
		 * on the line formed by these coordinates, based on Bresenham's algorithm.
		 * http://en.wikipedia.org/wiki/Bresenham's_line_algorithm#Simplification
		 * @param {number} x0 Start x coordinate
		 * @param {number} y0 Start y coordinate
		 * @param {number} x1 End x coordinate
		 * @param {number} y1 End y coordinate
		 * @return {Array.<Array.<number>>} The coordinates on the line
		 */
		static public function getLine(x0:int, y0:int, x1:int, y1:int):Array {
			var abs:Function = Math.abs;
			var line:Array = [];

			var dx:int = abs(x1 - x0);
			var dy:int = abs(y1 - y0);

			var sx:int = (x0 < x1) ? 1 : -1;
			var sy:int = (y0 < y1) ? 1 : -1;

			var err:int = dx - dy;

			while (true) {
				line.push([x0, y0]);

				if (x0 === x1 && y0 === y1) {
					break;
				}

				var e2:int = 2 * err;
				if (e2 > -dy) {
					err = err - dy;
					x0 = x0 + sx;
				}
				if (e2 < dx) {
					err = err + dx;
					y0 = y0 + sy;
				}
			}

			return line;
		}


		/**
		 * Smoothen the give path.
		 * The original path will not be modified; a new path will be returned.
		 * @param {PF.Grid} grid
		 * @param {Array.<Array.<number>>} path The path
		 * @return {Array.<Array.<number>>} Smoothened path
		 */
		static public function smoothenPath(grid:Grid, path:Array):Array {
			var length:int = path.length;
			var x0:int = path[0][0];	// path start x
			var y0:int = path[0][1]; 	// path start y
			var x1:int = path[length - 1][0]; // path end x
			var y1:int = path[length - 1][1]; // path end y
			var sx:int, sy:int; // current start coordinate
			var ex:int, ey:int; // current end coordinate
			var lx:int, ly:int; // last valid end coordinate
			var newPath:Array;

			sx = x0;
			sy = y0;
			lx = path[1][0];
			ly = path[1][1];
			newPath = [[sx, sy]];

			for (var i:int = 2; i < length; ++i) {
				var coord:Array = path[i];
				ex = coord[0];
				ey = coord[1];
				var line:Array = getLine(sx, sy, ex, ey);

				var blocked:Boolean = false;
				for (var j:int = 1; j < line.length; ++j) {
					var testCoord:Object = line[j];

					if (!grid.isWalkableAt(testCoord[0], testCoord[1])) {
						blocked = true;
						newPath.push([lx, ly]);
						sx = lx;
						sy = ly;
						break;
					}
				}
				if (!blocked) {
					lx = ex;
					ly = ey;
				}
			}
			newPath.push([x1, y1]);

			return newPath;
		}
	}
}
