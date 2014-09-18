package com.gearbrother.glash.common.algorithm.astar {
	import com.gearbrother.glash.mvc.model.GBean;
	
	import flash.events.IEventDispatcher;


	/**
	 * @author neozhang
	 * @create on Jul 30, 2013
	 */
	public class Node extends GBean {
		/**
		 * The x coordinate of the node on the grid.
		 * @type number
		 */
		public var x:int;

		/**
		 * The y coordinate of the node on the grid.
		 * @type number
		 */
		public var y:int;

		/**
		 * Whether this node can be walked through.
		 * @type boolean
		 */
		public var walkable:Boolean;

		internal var closed:Boolean;
		internal var opened:Boolean;
		internal var g:Number;
		internal var f:Number;
		internal var h:Number;
		internal var parent:Node;

		/**
		 * A node in grid.
		 * This class holds some basic information about a node and custom
		 * attributes may be added, depending on the algorithms' needs.
		 * @constructor
		 * @param {number} x - The x coordinate of the node on the grid.
		 * @param {number} y - The y coordinate of the node on the grid.
		 * @param {boolean} [walkable] - Whether this node is walkable.
		 */
		public function Node(x:int, y:int, walkable:Boolean = true, target:IEventDispatcher = null) {
			super(target);

			this.x = x;
			this.y = y;
			this.walkable = walkable;
		}
	}
}
