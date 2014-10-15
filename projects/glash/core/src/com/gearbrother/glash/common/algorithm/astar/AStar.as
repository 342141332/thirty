package com.gearbrother.glash.common.algorithm.astar {
	import com.gearbrother.glash.common.algorithm.GBinaryHeap;

	/**
	 * @author neozhang
	 * @create on Jul 18, 2013
	 */
	public class AStar {
		/**
		 * if cant findPath, the get close path
		 */
		private var _closeNode:Node;
		
		public var evaluatedTiles:Array;

		private var allowDiagonal:Boolean;
		private var dontCrossCorners:Boolean;
		private var heuristic:Function;
		private var weight:Number;

		/**
		 * A* path-finder.
		 * based upon https://github.com/bgrins/javascript-astar
		 * @constructor
		 * @param {boolean} allowDiagonal Whether diagonal movement is allowed.
		 * @param {boolean} dontCrossCorners Disallow diagonal movement touching block corners.
		 * @param {function} heuristic Heuristic function to estimate the distance
		 *     (defaults to manhattan).
		 * @param {integer} weight Weight to apply to the heuristic to allow for suboptimal paths, 
		 *     in order to speed up the search.
		 */
		public function AStar(allowDiagonal:Boolean = false, dontCrossCorners:Boolean = false, heuristic:Function = null, weight:Number = 1.0) {
			this.allowDiagonal = allowDiagonal;
			this.dontCrossCorners = dontCrossCorners;
			this.heuristic = heuristic || Heuristic.manhattan;
			this.weight = weight;
		}

		private function _compare(a:Node, b:Node):Boolean {
			return a.f < b.f;
		}

		/**
		 * Find and return the the path.
		 * @return {Array.<[number, number]>} The path, including both start and
		 *     end positions.
		 */
		public function findPath(startX:int, startY:int, endX:int, endY:int, grid:Grid):Array {
			var openList:GBinaryHeap = new GBinaryHeap(_compare);
			var scanedNodes:Array = [];
			var startNode:Node = grid.getNodeAt(startX, startY);
			var endNode:Node = grid.getNodeAt(endX, endY);
			var SQRT2:Number = Math.SQRT2;

			// set the `g` and `f` value of the start node to be 0
			startNode.g = 0;
			startNode.f = 0;

			// push the start node into the open list
			openList.push(startNode);
			scanedNodes.push(startNode);
			startNode.opened = true;

			// while the open list is not empty
			while (openList.size) {
				// pop the position of node which has the minimum `f` value.
				var node:Node = openList.pop();
				node.closed = true;

				// if reached the end position, construct the path and return it
				if (node === endNode) {
					return Util.backtrace(endNode);
				}

				if (!_closeNode || _closeNode.f > node.f)
					_closeNode = node;

				// get neigbours of the current node
				var neighbors:Array = grid.getNeighbors(node, allowDiagonal, dontCrossCorners);
				for (var i:int = 0, l:int = neighbors.length; i < l; ++i) {
					var neighbor:Node = neighbors[i];

					if (neighbor.closed) {
						continue;
					}

					var x:int = neighbor.x;
					var y:int = neighbor.y;

					// get the distance between current node and the neighbor
					// and calculate the next g score
					var ng:Number = node.g + ((x - node.x === 0 || y - node.y === 0) ? 1 : SQRT2);

					// check if the neighbor has not been inspected yet, or
					// can be reached with smaller cost from the current node
					if (!neighbor.opened || ng < neighbor.g) {
						neighbor.g = ng;
						neighbor.h = neighbor.h || weight * heuristic(Math.abs(x - endX), Math.abs(y - endY));
						neighbor.f = neighbor.g + neighbor.h;
						neighbor.parent = node;

						if (!neighbor.opened) {
							openList.push(neighbor);
							scanedNodes.push(node);
							neighbor.opened = true;
						} else {
							// the neighbor can be reached with smaller cost.
							// Since its f value has been updated, we have to
							// update its position in the open list
							openList.rescoreElement(neighbor);
						}
					}
				} // end for each neighbor
			} // end while not open list empty
			
			for each (var scanedNode:Node in scanedNodes) {
				scanedNode.f = scanedNode.g = scanedNode.h = 0;
				scanedNode.closed = scanedNode.opened = false;
				scanedNode.parent = null;
			}

			// fail to find the path
			return [];
		}
	}
}
