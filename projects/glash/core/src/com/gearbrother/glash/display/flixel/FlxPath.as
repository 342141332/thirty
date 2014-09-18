package com.gearbrother.glash.display.flixel {
	import com.gearbrother.glash.util.camera.Camera;
	import com.gearbrother.glash.util.display.GColorUtil;
	
	import flash.display.Graphics;
	import flash.geom.Point;


	/**
	 * This is a simple path data container.  Basically a list of points that
	 * a <code>FlxObject</code> can follow.  Also has code for drawing debug visuals.
	 * <code>FlxTilemap.findPath()</code> returns a path object, but you can
	 * also just make your own, using the <code>add()</code> functions below
	 * or by creating your own array of points.
	 *
	 * @author	Adam Atomic
	 */
	public class FlxPath {
		/**
		 * The list of <code>Point</code>s that make up the path data.
		 */
		public var nodes:Array;
		/**
		 * Specify a debug display color for the path.  Default is white.
		 */
		public var debugColor:uint;
		/**
		 * Specify a debug display scroll factor for the path.  Default is (1,1).
		 * NOTE: does not affect world movement!  Object scroll factors take care of that.
		 */
		public var debugScrollFactor:Point;
		/**
		 * Setting this to true will prevent the object from appearing
		 * when the visual debug mode in the debugger overlay is toggled on.
		 * @default false
		 */
		public var ignoreDrawDebug:Boolean;

		/**
		 * Internal helper for keeping new variable instantiations under control.
		 */
		protected var _point:Point;

		/**
		 * Instantiate a new path object.
		 *
		 * @param	Nodes	Optional, can specify all the points for the path up front if you want.
		 */
		public function FlxPath(Nodes:Array = null) {
			if (Nodes == null)
				nodes = new Array();
			else
				nodes = Nodes;
			_point = new Point();
			debugScrollFactor = new Point(1.0, 1.0);
			debugColor = 0xffffff;
			ignoreDrawDebug = false;
		}

		/**
		 * Clean up memory.
		 */
		public function destroy():void {
			debugScrollFactor = null;
			_point = null;
			nodes = null;
		}

		/**
		 * Add a new node to the end of the path at the specified location.
		 *
		 * @param	X	X position of the new path point in world coordinates.
		 * @param	Y	Y position of the new path point in world coordinates.
		 */
		public function add(X:Number, Y:Number):void {
			nodes.push(new Point(X, Y));
		}

		/**
		 * Add a new node to the path at the specified location and index within the path.
		 *
		 * @param	X		X position of the new path point in world coordinates.
		 * @param	Y		Y position of the new path point in world coordinates.
		 * @param	Index	Where within the list of path nodes to insert this new point.
		 */
		public function addAt(X:Number, Y:Number, Index:uint):void {
			if (Index > nodes.length)
				Index = nodes.length;
			nodes.splice(Index, 0, new Point(X, Y));
		}

		/**
		 * Sometimes its easier or faster to just pass a point object instead of separate X and Y coordinates.
		 * This also gives you the option of not creating a new node but actually adding that specific
		 * <code>Point</code> object to the path.  This allows you to do neat things, like dynamic paths.
		 *
		 * @param	Node			The point in world coordinates you want to add to the path.
		 * @param	AsReference		Whether to add the point as a reference, or to create a new point with the specified values.
		 */
		public function addPoint(Node:Point, AsReference:Boolean = false):void {
			if (AsReference)
				nodes.push(Node);
			else
				nodes.push(new Point(Node.x, Node.y));
		}

		/**
		 * Sometimes its easier or faster to just pass a point object instead of separate X and Y coordinates.
		 * This also gives you the option of not creating a new node but actually adding that specific
		 * <code>Point</code> object to the path.  This allows you to do neat things, like dynamic paths.
		 *
		 * @param	Node			The point in world coordinates you want to add to the path.
		 * @param	Index			Where within the list of path nodes to insert this new point.
		 * @param	AsReference		Whether to add the point as a reference, or to create a new point with the specified values.
		 */
		public function addPointAt(Node:Point, Index:uint, AsReference:Boolean = false):void {
			if (Index > nodes.length)
				Index = nodes.length;
			if (AsReference)
				nodes.splice(Index, 0, Node);
			else
				nodes.splice(Index, 0, new Point(Node.x, Node.y));
		}

		/**
		 * Remove a node from the path.
		 * NOTE: only works with points added by reference or with references from <code>nodes</code> itself!
		 *
		 * @param	Node	The point object you want to remove from the path.
		 *
		 * @return	The node that was excised.  Returns null if the node was not found.
		 */
		public function remove(Node:Point):Point {
			var index:int = nodes.indexOf(Node);
			if (index >= 0)
				return nodes.splice(index, 1)[0];
			else
				return null;
		}

		/**
		 * Remove a node from the path using the specified position in the list of path nodes.
		 *
		 * @param	Index	Where within the list of path nodes you want to remove a node.
		 *
		 * @return	The node that was excised.  Returns null if there were no nodes in the path.
		 */
		public function removeAt(Index:uint):Point {
			if (nodes.length <= 0)
				return null;
			if (Index >= nodes.length)
				Index = nodes.length - 1;
			return nodes.splice(Index, 1)[0];
		}

		/**
		 * Get the first node in the list.
		 *
		 * @return	The first node in the path.
		 */
		public function head():Point {
			if (nodes.length > 0)
				return nodes[0];
			return null;
		}

		/**
		 * Get the last node in the list.
		 *
		 * @return	The last node in the path.
		 */
		public function tail():Point {
			if (nodes.length > 0)
				return nodes[nodes.length - 1];
			return null;
		}

		/**
		 * While this doesn't override <code>FlxBasic.drawDebug()</code>, the behavior is very similar.
		 * Based on this path data, it draws a simple lines-and-boxes representation of the path
		 * if the visual debug mode was toggled in the debugger overlay.  You can use <code>debugColor</code>
		 * and <code>debugScrollFactor</code> to control the path's appearance.
		 *
		 * @param	Camera		The camera object the path will draw to.
		 */
		public function drawDebug(layer:GPaperLayer):void {
			if (nodes.length <= 0)
				return;
			var camera:Camera = layer.camera;

			//Set up our global flash graphics object to draw out the path
			var gfx:Graphics = layer.graphics;
			gfx.clear();

			//Then fill up the object with node and path graphics
			var node:Point;
			var nextNode:Point;
			var i:uint = 0;
			var l:uint = nodes.length;
			while (i < l) {
				//get a reference to the current node
				node = nodes[i] as Point;

				//find the screen position of the node on this camera
				_point.x = node.x - int(camera.screenRect.x * debugScrollFactor.x); //copied from getScreenXY()
				_point.y = node.y - int(camera.screenRect.y * debugScrollFactor.y);
				_point.x = int(_point.x + ((_point.x > 0) ? 0.0000001 : -0.0000001));
				_point.y = int(_point.y + ((_point.y > 0) ? 0.0000001 : -0.0000001));

				//decide what color this node should be
				var nodeSize:uint = 2;
				if ((i == 0) || (i == l - 1))
					nodeSize *= 2;
				var nodeColor:uint = debugColor;
				if (l > 1) {
					if (i == 0)
						nodeColor = GColorUtil.GREEN;
					else if (i == l - 1)
						nodeColor = GColorUtil.RED;
				}

				//draw a box for the node
				gfx.beginFill(nodeColor, 0.5);
				gfx.lineStyle();
				gfx.drawRect(_point.x - nodeSize * 0.5, _point.y - nodeSize * 0.5, nodeSize, nodeSize);
				gfx.endFill();

				//then find the next node in the path
				var linealpha:Number = 0.3;
				if (i < l - 1)
					nextNode = nodes[i + 1];
				else {
					nextNode = nodes[0];
					linealpha = 0.15;
				}

				//then draw a line to the next node
				gfx.moveTo(_point.x, _point.y);
				gfx.lineStyle(1, debugColor, linealpha);
				_point.x = nextNode.x - int(camera.screenRect.x * debugScrollFactor.x); //copied from getScreenXY()
				_point.y = nextNode.y - int(camera.screenRect.y * debugScrollFactor.y);
				_point.x = int(_point.x + ((_point.x > 0) ? 0.0000001 : -0.0000001));
				_point.y = int(_point.y + ((_point.y > 0) ? 0.0000001 : -0.0000001));
				gfx.lineTo(_point.x, _point.y);

				i++;
			}
		}
	}
}
