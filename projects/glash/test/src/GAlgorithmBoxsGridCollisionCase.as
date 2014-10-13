package {
	import com.gearbrother.glash.GMain;
	import com.gearbrother.glash.common.algorithm.GBoxsGrid;
	import com.gearbrother.glash.common.algorithm.GQuadtree;
	
	import flash.geom.Rectangle;

	[SWF(frameRate="60", width="500", height="500")]

	/**
	 * @author lifeng
	 * @create on 2013-12-17
	 * @see http://www.mikechambers.com/blog/2011/03/21/javascript-quadtree-implementation/
	 */
	public class GAlgorithmBoxsGridCollisionCase extends GMain {
		var circles:Array;
		var tree:GBoxsGrid;

		var CIRCLE_COUNT:int = 500;
		var bounds:Rectangle;
		var shape;
		var showOverlay:Boolean = false;

		public function GAlgorithmBoxsGridCollisionCase(id:String = null) {
			super(id);
		}

		override protected function doInit():void {
			super.doInit();

			circles = [];

			bounds = new Rectangle(0, 0, width, height);

			initCircles();

			enableTick = true;
		}

		function initCircles() {
			//note, we are sharing the same graphics instance between all shape instances
			//this saves CPU and memory, but could lead to some weird bugs, so keep that in mind

			var radius;
			for (var i = 0; i < CIRCLE_COUNT; i++) {
				radius = Math.ceil(Math.random() * 30) + 1;
				var c:Circle = new Circle(bounds, radius);

				var x:int = Math.random() * bounds.width;
				var y:int = Math.random() * bounds.height;

				if (x + c.width > bounds.width) {
					x = bounds.width - c.width - 1;
				}

				if (y + c.height > bounds.height) {
					y = bounds.height - c.height - 1;
				}

				c.x = x;
				c.y = y;

				stage.addChild(c);
				circles.push(c);
			}
		}

		function updateTree() {
			tree = new GBoxsGrid(bounds, 10, 10);
			for each (var circle:Circle in circles)
				tree.insert(circle);
		}

		override public function tick(interval:int):void {
			for (var k:int = 0; k < CIRCLE_COUNT; k++) {
				(circles[k] as Circle).update();
			}

			updateTree();

			if (showOverlay) {
				renderQuad();
			}

			var count:int;
			for (var i:int = 0; i < CIRCLE_COUNT; i++) {
				var c:Circle = circles[i];

				var items:Array = tree.retrieve(new Rectangle(c.x, c.y, c.width, c.height));
//				items = circles;
				var len:uint = items.length;
				count += items.length;
				for (var j:int = 0; j < len; j++) {
					var item:Circle = items[j];

					if (c == item) {
						continue;
					}

					if (c.isColliding && item.isColliding) {
						continue;
					}

					var dx:Number = c.x + c.radius - item.x - item.radius;
					var dy:Number = c.y + c.radius - item.y - item.radius;
					var radii:int = c.radius + item.radius;

					var colliding:Boolean = ((dx * dx) + (dy * dy)) < (radii * radii);

					if (!c.isColliding) {
						c.setIsColliding(colliding);
					}

					if (!item.isColliding) {
						item.setIsColliding(colliding);
					}
				}
			}
			trace(count);
		}

		function tick_brute() {
			for (var k = 0; k < CIRCLE_COUNT; k++) {
				circles[k].update();
			}

			updateTree();

			if (showOverlay) {
				renderQuad();
			}

			var colliding = false;

			for (var i = 0; i < CIRCLE_COUNT; i++) {
				var c:Circle = circles[i];

				for (var j = i + 1; j < CIRCLE_COUNT; j++) {
					var item:Circle = circles[j];

					if (c == item) {
						continue;
					}

					if (c.isColliding && item.isColliding) {
						continue;
					}

					var dx:Number = c.x - item.x;
					var dy:Number = c.y - item.y;
					var radii:int = c.radius + item.radius;

					colliding = ((dx * dx) + (dy * dy)) < (radii * radii);

					if (!c.isColliding) {
						c.setIsColliding(colliding);
					}

					if (!item.isColliding) {
						item.setIsColliding(colliding);
					}
				}
			}
		}

		function renderQuad() {
			var g = shape.graphics;
			g.clear();
			g.setStrokeStyle(1);
			g.beginStroke("#000000");
			drawNode(tree);
		}

		function drawNode(node) {
			var bounds = node._bounds;
			var g = shape.graphics;

			g.drawRect(abs(bounds.x) + 0.5, abs(bounds.y) + 0.5, bounds.width, bounds.height);

			var len = node.nodes.length;

			for (var i = 0; i < len; i++) {
				drawNode(node.nodes[i]);
			}
		}

		//fast Math.abs
		function abs(x) {
			return (x < 0 ? -x : x);
		}
	}
}
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Rectangle;

class Circle extends Sprite {
	static public const MAX_SPEED:int = 4;
	
	override public function get width():Number {
		return this.radius << 1;
	}
	
	override public function get height():Number {
		return this.radius << 1;
	}

	private var _vx:int;
	private var _vy:int;

	private var _bounds:Rectangle;
	public var radius:int;
	public var isColliding:Boolean;

	function Circle(bounds:Rectangle, radius:int) {
		super();

		this._bounds = bounds;
		this.radius = radius;
		this._vx = Circle.MAX_SPEED * Math.random() + 1;
		//y velocity and direction
		this._vy = Circle.MAX_SPEED * Math.random() + 1;

		//pick a random direction on x axis
		if (Math.random() > .5) {
			this._vx *= -1;
		}

		//pick a random direction on y axis
		if (Math.random() > .5) {
			this._vy *= -1;
		}
//		cacheAsBitmap = true;
		repaint();
	}
	
	public function setIsColliding(colliding:Boolean):void {
		isColliding = colliding;
		repaint();
	}

	public function repaint():void {
		graphics.clear();
		graphics.lineStyle(1, 0x000000);
		graphics.beginFill(0xff0000, isColliding ? .3 : 0);
		graphics.drawCircle(radius, radius, radius);
		graphics.endFill();
	}

	public function update():void {
		setIsColliding(false);

		this.x += this._vx;
		this.y += this._vy;

		if (this.x + this.width > this._bounds.width) {
			this.x = this._bounds.width - this.width - 1;
			this._vx *= -1;
		} else if (this.x < this._bounds.x) {
			this.x = this._bounds.x + 1;
			this._vx *= -1;
		}

		if (this.y + this.height > this._bounds.height) {
			this.y = this._bounds.height - this.height - 1;
			this._vy *= -1;
		} else if (this.y < this._bounds.y) {
			this.y = this._bounds.y + 1;
			this._vy *= -1;
		}
	}
}
