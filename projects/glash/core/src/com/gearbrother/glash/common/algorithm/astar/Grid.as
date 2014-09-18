package com.gearbrother.glash.common.algorithm.astar {
	import com.gearbrother.glash.mvc.model.GBean;
	
	import flash.events.IEventDispatcher;


	/**
	 * @author lifeng
	 * @create on 2013-7-28
	 */
	public class Grid extends GBean {
		/**
		 * The int of columns of the grid.
		 * @type int
		 */
		public var width:int;
		/**
		 * The int of rows of the grid.
		 * @type int
		 */
		public var height:int;

		/**
		 * A 2D array of nodes.
		 */
		public var nodes:Array;

		/**
		 * The Grid class, which serves as the encapsulation of the layout of the nodes.
		 * @constructor
		 * @param {int} width Number of columns of the grid.
		 * @param {int} height Number of rows of the grid.
		 * @param {Array.<Array.<(int|boolean)>>} [matrix] - A 0-1 matrix
		 *     representing the walkable status of the nodes(0 or false for walkable).
		 *     If the matrix is not supplied, all the nodes will be walkable.  */
		public function Grid(width:Number, height:Number, matrix:Array = null) {
			this.width = width;
			this.height = height;
			buildNodes(width, height, matrix);
		}

		/**
		 * Build and return the nodes.
		 * @private
		 * @param {int} width
		 * @param {int} height
		 * @param {Array.<Array.<int|boolean>>} [matrix] - A 0-1 matrix representing
		 *     the walkable status of the nodes.
		 * @see Grid
		 */
		private function buildNodes(width:int, height:int, matrix:Array = null):void {
			var i:int;
			var j:int;
			var row:int;
			var nodes:Array = new Array(height);
			
			for (i = 0; i < height; ++i) {
				nodes[i] = new Array(width);
				for (j = 0; j < width; ++j) {
					nodes[i][j] = new Node(j, i);
				}
			}
			
			matrix ||= [];
			for (i = 0; i < matrix.length; ++i) {
				for (j = 0; j < (matrix[i] as Array).length; ++j) {
					if (matrix[i][j]) {
						// 0, false, null will be walkable
						// while others will be un-walkable
						(nodes[i][j] as Node).walkable = false;
					}
				}
			}
			
			this.nodes = nodes;
		}
		
		public function getNodeAt(x:int, y:int):Node {
			return this.nodes[y][x];
		}

		/**
		 * Determine whether the node at the given position is walkable.
		 * (Also returns false if the position is outside the grid.)
		 * @param {int} x - The x coordinate of the node.
		 * @param {int} y - The y coordinate of the node.
		 * @return {boolean} - The walkability of the node.
		 */
		public function isWalkableAt(x:int, y:int):Boolean {
			return this.isInside(x, y) && this.nodes[y][x].walkable;
		}

		/**
		 * Determine whether the position is inside the grid.
		 * XXX: `grid.isInside(x, y)` is wierd to read.
		 * It should be `(x, y) is inside grid`, but I failed to find a better
		 * name for this method.
		 * @param {int} x
		 * @param {int} y
		 * @return {boolean}
		 */
		public function isInside(x:int, y:int):Boolean {
			return (x >= 0 && x < this.width) && (y >= 0 && y < this.height);
		}

		/**
		 * Set whether the node on the given position is walkable.
		 * NOTE: throws exception if the coordinate is not inside the grid.
		 * @param {int} x - The x coordinate of the node.
		 * @param {int} y - The y coordinate of the node.
		 * @param {boolean} walkable - Whether the position is walkable.
		 */
		public function setWalkableAt(x:int, y:int, walkable:Boolean):void {
			this.nodes[y][x].walkable = walkable;
		}

		/**
		 * Get the neighbors of the given node.
		 *
		 *     offsets      diagonalOffsets:
		 *  +---+---+---+    +---+---+---+
		 *  |   | 0 |   |    | 0 |   | 1 |
		 *  +---+---+---+    +---+---+---+
		 *  | 3 |   | 1 |    |   |   |   |
		 *  +---+---+---+    +---+---+---+
		 *  |   | 2 |   |    | 3 |   | 2 |
		 *  +---+---+---+    +---+---+---+
		 *
		 *  When allowDiagonal is true, if offsets[i] is valid, then
		 *  diagonalOffsets[i] and
		 *  diagonalOffsets[(i + 1) % 4] is valid.
		 * @param {Node} node
		 * @param {boolean} allowDiagonal
		 * @param {boolean} dontCrossCorners
		 */
		public function getNeighbors(node:Node, allowDiagonal:Boolean, dontCrossCorners:Boolean):Array {
			var x:int = node.x;
			var y:int = node.y;
			var neighbors:Array = [];
			var s0:Boolean = false;
			var d0:Boolean = false;
			var s1:Boolean = false;
			var d1:Boolean = false;
			var s2:Boolean = false;
			var d2:Boolean = false;
			var s3:Boolean = false;
			var d3:Boolean = false;

			// ↑
			if (this.isWalkableAt(x, y - 1)) {
				neighbors.push(nodes[y - 1][x]);
				s0 = true;
			}
			// →
			if (this.isWalkableAt(x + 1, y)) {
				neighbors.push(nodes[y][x + 1]);
				s1 = true;
			}
			// ↓
			if (this.isWalkableAt(x, y + 1)) {
				neighbors.push(nodes[y + 1][x]);
				s2 = true;
			}
			// ←
			if (this.isWalkableAt(x - 1, y)) {
				neighbors.push(nodes[y][x - 1]);
				s3 = true;
			}

			if (!allowDiagonal) {
				return neighbors;
			}

			if (dontCrossCorners) {
				d0 = s3 && s0;
				d1 = s0 && s1;
				d2 = s1 && s2;
				d3 = s2 && s3;
			} else {
				d0 = s3 || s0;
				d1 = s0 || s1;
				d2 = s1 || s2;
				d3 = s2 || s3;
			}

			// ↖
			if (d0 && this.isWalkableAt(x - 1, y - 1)) {
				neighbors.push(nodes[y - 1][x - 1]);
			}
			// ↗
			if (d1 && this.isWalkableAt(x + 1, y - 1)) {
				neighbors.push(nodes[y - 1][x + 1]);
			}
			// ↘
			if (d2 && this.isWalkableAt(x + 1, y + 1)) {
				neighbors.push(nodes[y + 1][x + 1]);
			}
			// ↙
			if (d3 && this.isWalkableAt(x - 1, y + 1)) {
				neighbors.push(nodes[y + 1][x - 1]);
			}

			return neighbors;
		}
	}
}
