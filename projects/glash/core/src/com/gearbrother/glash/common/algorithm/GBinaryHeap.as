package com.gearbrother.glash.common.algorithm {
	public class GBinaryHeap {
		private var _content:Array;
		private var _scoreFunction:Function;

		/**
		 * A BinaryHeap implementation taken from the Javascript example at https://github.com/bgrins/javascript-astar/blob/master/graph.js
		 */
		public function GBinaryHeap(scoreFunction:Function) {
			_content = new Array();
			_scoreFunction = scoreFunction;
		}

		public function reset():void {
			_content = new Array();
		}

		public function get content():Array {
			return _content;
		}

		public function push(element:*):void {
			//add the new element to the end of the array
			_content.push(element);

			//Allow it to sink down.
			this.sinkDown(_content.length - 1);
		}

		public function pop():* {
			// Store the first element so we can return it later.
			var result:* = _content[0];

			// Get the element at the end of the array.
			var end:* = _content.pop();

			// If there are any elements left, put the end element at the
			// start, and let it bubble up.
			if (_content.length > 0) {
				_content[0] = end;
				this.bubbleUp(0);
			}
			return result;
		}

		public function remove(node:*):void {
			var i:int = _content.indexOf(node);

			// When it is found, the process seen in 'pop' is repeated
			// to fill up the hole.
			var end:* = _content.pop();
			if (i != _content.length - 1) {
				_content[i] = end;
				if (_scoreFunction(end, node) < 0) {
					sinkDown(i);
				} else {
					bubbleUp(i);
				}
			}
		}

		public function get size():int {
			return _content.length;
		}

		public function rescoreElement(node:*):void {
			sinkDown(_content.indexOf(node));
		}

		private function sinkDown(n:int):void {
			// Fetch the element that has to be sunk.
			var element:* = _content[n];

			// When at 0, an element can not sink any further.
			while (n > 0) {
				// Compute the parent element's index, and fetch it.
				var parentN:Number = ((n + 1) >> 1) -1 ;
//				var parentN:Number = _content.indexOf(element.parent);
				if (parentN == -1) {
					parentN = 0;
				}

				var parent:* = _content[parentN];

				// Swap the elements if the parent is greater.
				if (_scoreFunction(element, parent) < 0) {
					_content[parentN] = element;
					_content[n] = parent;
					// Update 'n' to continue at the new position.
					n = parentN;
				}
				// Found a parent that is less, no need to sink any further.
				else {
					break;
				}
			}
		}

		private function bubbleUp(n:Number):void {
			// Look up the target element and its score.
			var length:int = _content.length;
			var element:* = _content[n];

			while (true) {
				// Compute the indices of the child elements.
				var child2N:Number = (n + 1) << 1;
				var child1N:Number = child2N - 1;

				// This is used to store the new position of the element,
				// if any.
				var swap:* = null;

				// If the first child exists (is inside the array)...
				if (child1N < length) {
					// Look it up and compute its score.
					var child1:* = _content[child1N];
					// If the score is less than our element's, we need to swap.
					if (_scoreFunction(child1, element) < 0)
						swap = child1N;
				}
				// Do the same checks for the other child.
				if (child2N < length) {
					var child2:* = _content[child2N];
					if (_scoreFunction(child2, swap == null ? element : child1) < 0) {
						swap = child2N;
					}
				}

				// If the element needs to be moved, swap it, and continue.
				if (swap != null) {
					_content[n] = _content[swap];
					_content[swap] = element;
					n = swap;
				}
				// Otherwise, we are done.
				else {
					break;
				}
			}
		}
	}
}
