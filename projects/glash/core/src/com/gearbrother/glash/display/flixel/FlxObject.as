package com.gearbrother.glash.display.flixel {
	import com.gearbrother.glash.display.GSprite;
	
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;

	/**
	 * This is the base class for most of the display objects (<code>FlxSprite</code>, <code>FlxText</code>, etc).
	 * It includes some basic attributes about game objects, including retro-style flickering,
	 * basic state information, sizes, scrolling, and basic physics and motion.
	 *
	 * @author	Adam Atomic
	 */
	public class FlxObject extends GSprite {
		static public const logger:ILogger = getLogger(FlxObject);

		/**
		 * Generic value for "left" Used by <code>facing</code>, <code>allowCollisions</code>, and <code>touching</code>.
		 */
		static public const LEFT:uint = 0x0001;
		/**
		 * Generic value for "right" Used by <code>facing</code>, <code>allowCollisions</code>, and <code>touching</code>.
		 */
		static public const RIGHT:uint = 0x0010;
		/**
		 * Generic value for "up" Used by <code>facing</code>, <code>allowCollisions</code>, and <code>touching</code>.
		 */
		static public const UP:uint = 0x0100;
		/**
		 * Generic value for "down" Used by <code>facing</code>, <code>allowCollisions</code>, and <code>touching</code>.
		 */
		static public const DOWN:uint = 0x1000;

		/**
		 * Special-case constant meaning no collisions, used mainly by <code>allowCollisions</code> and <code>touching</code>.
		 */
		static public const NONE:uint = 0;
		/**
		 * Special-case constant meaning up, used mainly by <code>allowCollisions</code> and <code>touching</code>.
		 */
		static public const CEILING:uint = UP;
		/**
		 * Special-case constant meaning down, used mainly by <code>allowCollisions</code> and <code>touching</code>.
		 */
		static public const FLOOR:uint = DOWN;
		/**
		 * Special-case constant meaning only the left and right sides, used mainly by <code>allowCollisions</code> and <code>touching</code>.
		 */
		static public const WALL:uint = LEFT | RIGHT;
		/**
		 * Special-case constant meaning any direction, used mainly by <code>allowCollisions</code> and <code>touching</code>.
		 */
		static public const ANY:uint = LEFT | RIGHT | UP | DOWN;

		/**
		 * Handy constant used during collision resolution (see <code>separateX()</code> and <code>separateY()</code>).
		 */
		static public const OVERLAP_BIAS:Number = 4;

		/**
		 * Path behavior controls: move from the start of the path to the end then stop.
		 */
		static public const PATH_FORWARD:uint = 0x000000;
		/**
		 * Path behavior controls: move from the end of the path to the start then stop.
		 */
		static public const PATH_BACKWARD:uint = 0x000001;
		/**
		 * Path behavior controls: move from the start of the path to the end then directly back to the start, and start over.
		 */
		static public const PATH_LOOP_FORWARD:uint = 0x000010;
		/**
		 * Path behavior controls: move from the end of the path to the start then directly back to the end, and start over.
		 */
		static public const PATH_LOOP_BACKWARD:uint = 0x000100;
		/**
		 * Path behavior controls: move from the start of the path to the end then turn around and go back to the start, over and over.
		 */
		static public const PATH_YOYO:uint = 0x001000;
		/**
		 * Path behavior controls: ignores any vertical component to the path data, only follows side to side.
		 */
		static public const PATH_HORIZONTAL_ONLY:uint = 0x010000;
		/**
		 * Path behavior controls: ignores any horizontal component to the path data, only follows up and down.
		 */
		static public const PATH_VERTICAL_ONLY:uint = 0x100000;

		/**
		 * Whether an object will move/alter position after a collision.
		 */
		public var immovable:Boolean;

		/**
		 * The basic speed of this object.
		 */
		public var velocity:Point;
		/**
		 * The virtual mass of the object. Default value is 1.
		 * Currently only used with <code>elasticity</code> during collision resolution.
		 * Change at your own risk; effects seem crazy unpredictable so far!
		 */
		public var mass:Number;
		/**
		 * The bounciness of this object.  Only affects collisions.  Default value is 0, or "not bouncy at all."
		 */
		public var elasticity:Number;
		/**
		 * How fast the speed of this object is changing.
		 * Useful for smooth movement and gravity.
		 */
		public var acceleration:Point;
		/**
		 * This isn't drag exactly, more like deceleration that is only applied
		 * when acceleration is not affecting the sprite.
		 */
		public var drag:Point;
		/**
		 * If you are using <code>acceleration</code>, you can use <code>maxVelocity</code> with it
		 * to cap the speed automatically (very useful!).
		 */
		public var maxVelocity:Point;
		/**
		 * Set the angle of a sprite to rotate it.
		 * WARNING: rotating sprites decreases rendering
		 * performance for this sprite by a factor of 10x!
		 */
		public var angle:Number;
		/**
		 * This is how fast you want this sprite to spin.
		 */
		public var angularVelocity:Number;
		/**
		 * How fast the spin speed should change.
		 */
		public var angularAcceleration:Number;
		/**
		 * Like <code>drag</code> but for spinning.
		 */
		public var angularDrag:Number;
		/**
		 * Use in conjunction with <code>angularAcceleration</code> for fluid spin speed control.
		 */
		public var maxAngular:Number;
		/**
		 * Should always represent (0,0) - useful for different things, for avoiding unnecessary <code>new</code> calls.
		 */
		static protected const _pZero:Point = new Point();

		/**
		 * A point that can store numbers from 0 to 1 (for X and Y independently)
		 * that governs how much this object is affected by the camera subsystem.
		 * 0 means it never moves, like a HUD element or far background graphic.
		 * 1 means it scrolls along a the same speed as the foreground layer.
		 * scrollFactor is initialized as (1,1) by default.
		 */
		public var scrollFactor:Point;
		/**
		 * This is just a pre-allocated x-y point container to be used however you like
		 */
		protected var _point:Point;
		/**
		 * This is just a pre-allocated rectangle container to be used however you like
		 */
		protected var _rect:Rectangle;
		/**
		 * Set this to false if you want to skip the automatic motion/movement stuff (see <code>updateMotion()</code>).
		 * FlxObject and FlxSprite default to true.
		 * FlxText, FlxTileblock, FlxTilemap and FlxSound default to false.
		 */
		public var moves:Boolean;
		/**
		 * Bit field of flags (use with UP, DOWN, LEFT, RIGHT, etc) indicating surface contacts.
		 * Use bitwise operators to check the values stored here, or use touching(), justStartedTouching(), etc.
		 * You can even use them broadly as boolean values if you're feeling saucy!
		 */
		public var touching:uint;
		/**
		 * Bit field of flags (use with UP, DOWN, LEFT, RIGHT, etc) indicating surface contacts from the previous game loop step.
		 * Use bitwise operators to check the values stored here, or use touching(), justStartedTouching(), etc.
		 * You can even use them broadly as boolean values if you're feeling saucy!
		 */
		public var wasTouching:uint;
		/**
		 * Bit field of flags (use with UP, DOWN, LEFT, RIGHT, etc) indicating collision directions.
		 * Use bitwise operators to check the values stored here.
		 * Useful for things like one-way platforms (e.g. allowCollisions = UP;)
		 * The accessor "solid" just flips this variable between NONE and ANY.
		 */
		public var allowCollisions:uint;
		/**
		 * 记录碰撞的对象
		 * TODO
		 * 每次postUpdate都要创建新的{}这样不知道是不是降低新能
		 */
		public var touchingObjs:Object;

		/**
		 * Important variable for collision processing.
		 * By default this value is set automatically during <code>preUpdate()</code>.
		 */
		public var last:Point;
		
		private var _x:Number;
		override public function set x(value:Number):void {
			_x = value;
			super.x = value;
		}
		override public function get x():Number {
			return _x;
		}

		private var _y:Number;
		override public function set y(value:Number):void {
			_y = value;
			super.y = value;
		}
		override public function get y():Number {
			return _y;
		}
		
		private var _width:Number;

		override public function get width():Number {
			return _width;
		}

		override public function set width(newValue:Number):void {
			_width = newValue;
		}

		private var _height:Number;

		override public function get height():Number {
			return _height;
		}

		override public function set height(newValue:Number):void {
			_height = newValue;
		}

		/**
		 * Instantiates a <code>FlxObject</code>.
		 *
		 * @param	X		The X-coordinate of the point in space.
		 * @param	Y		The Y-coordinate of the point in space.
		 * @param	Width	Desired width of the rectangle.
		 * @param	Height	Desired height of the rectangle.
		 */
		public function FlxObject(x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0) {
			this.x = x;
			this.y = y;
			this.last = new Point(x, y);
			this.width = width;
			this.height = height;
			this.mass = 1.0;
			this.elasticity = 0.0;

			this.immovable = false;
			this.moves = true;

			this.touching = NONE;
			this.wasTouching = NONE;
			this.allowCollisions = ANY;
			this.touchingObjs = {};

			this.velocity = new Point();
			this.acceleration = new Point();
			this.drag = new Point();
			this.maxVelocity = new Point(10000, 10000);

			this.angle = 0;
			this.angularVelocity = 0;
			this.angularAcceleration = 0;
			this.angularDrag = 0;
			this.maxAngular = 10000;

			this.scrollFactor = new Point(1.0, 1.0);

			this._point = new Point();
			this._rect = new Rectangle();
		}

		/**
		 * Pre-update is called right before <code>update()</code> on each object in the game loop.
		 * In <code>FlxObject</code> it controls the flicker timer,
		 * tracking the last coordinates for collision purposes,
		 * and checking if the object is moving along a path or not.
		 */
		public function preUpdate():void {
			last.x = x;
			last.y = y;
		}

		/**
		 * Post-update is called right after <code>update()</code> on each object in the game loop.
		 * In <code>FlxObject</code> this function handles integrating the objects motion
		 * based on the velocity and acceleration settings, and tracking/clearing the <code>touching</code> flags.
		 */
		public function postUpdate(elapsed:Number):void {
			if (moves)
				updateMotion(elapsed);

			wasTouching = touching;
			touching = NONE;
			touchingObjs = {};
		}

		/**
		 * Internal function for updating the position and speed of this object.
		 * Useful for cases when you need to update this but are buried down in too many supers.
		 * Does a slightly fancier-than-normal integration to help with higher fidelity framerate-independenct motion.
		 */
		protected function updateMotion(elapsed:Number):void {
			var delta:Number;
			var velocityDelta:Number;

			velocityDelta = (computeVelocity(elapsed, angularVelocity, angularAcceleration, angularDrag, maxAngular) - angularVelocity) / 2;
			angularVelocity += velocityDelta;
			angle += angularVelocity * elapsed;
			angularVelocity += velocityDelta;

			velocityDelta = (computeVelocity(elapsed, velocity.x, acceleration.x, drag.x, maxVelocity.x) - velocity.x) / 2;
			velocity.x += velocityDelta;
			delta = velocity.x * elapsed;
			velocity.x += velocityDelta;
			x += delta;

			velocityDelta = (computeVelocity(elapsed, velocity.y, acceleration.y, drag.y, maxVelocity.y) - velocity.y) / 2;
			velocity.y += velocityDelta;
			delta = velocity.y * elapsed;
			velocity.y += velocityDelta;
			y += delta;
		}

		static public function computeVelocity(elapsed:Number, Velocity:Number, Acceleration:Number = 0, Drag:Number = 0, Max:Number = 10000):Number {
			if (Acceleration != 0)
				Velocity += Acceleration * elapsed;
			else if (Drag != 0) {
				var drag:Number = Drag * elapsed;
				if (Velocity - drag > 0)
					Velocity = Velocity - drag;
				else if (Velocity + drag < 0)
					Velocity += drag;
				else
					Velocity = 0;
			}
			if ((Velocity != 0) && (Max != 10000)) {
				if (Velocity > Max)
					Velocity = Max;
				else if (Velocity < -Max)
					Velocity = -Max;
			}
			return Velocity;
		}

		/**
		 * Whether the object collides or not.  For more control over what directions
		 * the object will collide from, use collision constants (like LEFT, FLOOR, etc)
		 * to set the value of allowCollisions directly.
		 */
		public function get solid():Boolean {
			return (allowCollisions & ANY) > NONE;
		}

		/**
		 * @private
		 */
		public function set solid(Solid:Boolean):void {
			if (Solid)
				allowCollisions = ANY;
			else
				allowCollisions = NONE;
		}

		/**
		 * Handy function for checking if this object is touching a particular surface.
		 * For slightly better performance you can just &amp; the value directly into <code>touching</code>.
		 * However, this method is good for readability and accessibility.
		 *
		 * @param	Direction	Any of the collision flags (e.g. LEFT, FLOOR, etc).
		 *
		 * @return	Whether the object is touching an object in (any of) the specified direction(s) this frame.
		 */
		public function isTouching(Direction:uint):Boolean {
			return (touching & Direction) > NONE;
		}

		/**
		 * Handy function for checking if this object is just landed on a particular surface.
		 *
		 * @param	Direction	Any of the collision flags (e.g. LEFT, FLOOR, etc).
		 *
		 * @return	Whether the object just landed on (any of) the specified surface(s) this frame.
		 */
		public function justTouched(Direction:uint):Boolean {
			return ((touching & Direction) > NONE) && ((wasTouching & Direction) <= NONE);
		}

		/**
		 * The main collision resolution function in flixel.
		 *
		 * @param	Object1 	Any <code>FlxObject</code>.
		 * @param	Object2		Any other <code>FlxObject</code>.
		 *
		 * @return	Whether the objects in fact touched and were separated.
		 */
		static public function separate(Object1:FlxObject, Object2:FlxObject):Boolean {
			var separatedX:Boolean = separateX(Object1, Object2);
			var separatedY:Boolean = separateY(Object1, Object2);
			return separatedX || separatedY;
		}

		/**
		 * The X-axis component of the object separation process.
		 *
		 * @param	Object1 	Any <code>FlxObject</code>.
		 * @param	Object2		Any other <code>FlxObject</code>.
		 *
		 * @return	Whether the objects in fact touched and were separated along the X axis.
		 */
		static public function separateX(obj1:FlxObject, obj2:FlxObject):Boolean {
			//can't separate two immovable objects
			var obj1immovable:Boolean = obj1.immovable;
			var obj2immovable:Boolean = obj2.immovable;
			if (obj1immovable && obj2immovable)
				return false;

			//First, get the two object deltas
			var overlap:Number = 0;
			var obj1delta:Number = obj1.x - obj1.last.x;
			var obj2delta:Number = obj2.x - obj2.last.x;
			if (obj1delta != obj2delta) {
				//Check if the X hulls actually overlap
				var obj1deltaAbs:Number = (obj1delta > 0) ? obj1delta : -obj1delta;
				var obj2deltaAbs:Number = (obj2delta > 0) ? obj2delta : -obj2delta;
				var obj1rect:Rectangle = new Rectangle(obj1.x - ((obj1delta > 0) ? obj1delta : 0), obj1.last.y, obj1.width + ((obj1delta > 0) ? obj1delta : -obj1delta), obj1.height);
				var obj2rect:Rectangle = new Rectangle(obj2.x - ((obj2delta > 0) ? obj2delta : 0), obj2.last.y, obj2.width + ((obj2delta > 0) ? obj2delta : -obj2delta), obj2.height);
				if ((obj1rect.x + obj1rect.width > obj2rect.x)
					&& (obj1rect.x < obj2rect.x + obj2rect.width)
					&& (obj1rect.y + obj1rect.height > obj2rect.y)
					&& (obj1rect.y < obj2rect.y + obj2rect.height)) {
					var maxOverlap:Number = obj1deltaAbs + obj2deltaAbs + OVERLAP_BIAS;

					//If they did overlap (and can), figure out by how much and flip the corresponding flags
					if (obj1delta > obj2delta) {
						overlap = obj1.x + obj1.width - obj2.x;
						if ((overlap > maxOverlap) || !(obj1.allowCollisions & RIGHT) || !(obj2.allowCollisions & LEFT))
							overlap = 0;
						else {
							obj1.touching |= RIGHT;
							obj1.touchingObjs[RIGHT] = obj2;
							obj2.touching |= LEFT;
							obj2.touchingObjs[LEFT] = obj1;
						}
					} else if (obj1delta < obj2delta) {
						overlap = obj1.x - obj2.width - obj2.x;
						if ((-overlap > maxOverlap) || !(obj1.allowCollisions & LEFT) || !(obj2.allowCollisions & RIGHT))
							overlap = 0;
						else {
							obj1.touching |= LEFT;
							obj1.touchingObjs[LEFT] = obj2;
							obj2.touching |= RIGHT;
							obj2.touchingObjs[RIGHT] = obj1;
						}
					}
				}
			}

			//Then adjust their positions and velocities accordingly (if there was any overlap)
			if (overlap != 0) {
				var obj1v:Number = obj1.velocity.x;
				var obj2v:Number = obj2.velocity.x;

				if (!obj1immovable && !obj2immovable) {
					overlap *= 0.5;
					obj1.x = obj1.x - overlap;
					obj2.x += overlap;

					var obj1velocity:Number = Math.sqrt((obj2v * obj2v * obj2.mass) / obj1.mass) * ((obj2v > 0) ? 1 : -1);
					var obj2velocity:Number = Math.sqrt((obj1v * obj1v * obj1.mass) / obj2.mass) * ((obj1v > 0) ? 1 : -1);
					var average:Number = (obj1velocity + obj2velocity) * 0.5;
					obj1velocity -= average;
					obj2velocity -= average;
					obj1.velocity.x = average + obj1velocity * obj1.elasticity;
					obj2.velocity.x = average + obj2velocity * obj2.elasticity;
				} else if (!obj1immovable) {
					obj1.x = obj1.x - overlap;
					obj1.velocity.x = obj2v - obj1v * obj1.elasticity;
				} else if (!obj2immovable) {
					obj2.x += overlap;
					obj2.velocity.x = obj1v - obj2v * obj2.elasticity;
				}
				return true;
			} else
				return false;
		}

		/**
		 * The Y-axis component of the object separation process.
		 *
		 * @param	Object1 	Any <code>FlxObject</code>.
		 * @param	Object2		Any other <code>FlxObject</code>.
		 *
		 * @return	Whether the objects in fact touched and were separated along the Y axis.
		 */
		static public function separateY(obj1:FlxObject, obj2:FlxObject):Boolean {
			//can't separate two immovable objects
			var obj1immovable:Boolean = obj1.immovable;
			var obj2immovable:Boolean = obj2.immovable;
			if (obj1immovable && obj2immovable)
				return false;

			//First, get the two object deltas
			var overlap:Number = 0;
			var obj1delta:Number = obj1.y - obj1.last.y;
			var obj2delta:Number = obj2.y - obj2.last.y;
			if (obj1delta != obj2delta) {
				//Check if the Y hulls actually overlap
				var obj1deltaAbs:Number = (obj1delta > 0) ? obj1delta : -obj1delta;
				var obj2deltaAbs:Number = (obj2delta > 0) ? obj2delta : -obj2delta;
				var obj1rect:Rectangle = new Rectangle(obj1.x, obj1.y - ((obj1delta > 0) ? obj1delta : 0), obj1.width, obj1.height + obj1deltaAbs);
				var obj2rect:Rectangle = new Rectangle(obj2.x, obj2.y - ((obj2delta > 0) ? obj2delta : 0), obj2.width, obj2.height + obj2deltaAbs);
				if ((obj1rect.x + obj1rect.width > obj2rect.x) && (obj1rect.x < obj2rect.x + obj2rect.width) && (obj1rect.y + obj1rect.height > obj2rect.y) && (obj1rect.y < obj2rect.y + obj2rect.height)) {
					var maxOverlap:Number = obj1deltaAbs + obj2deltaAbs + OVERLAP_BIAS;

					//If they did overlap (and can), figure out by how much and flip the corresponding flags
					if (obj1delta > obj2delta) {
						overlap = obj1.y + obj1.height - obj2.y;
						if ((overlap > maxOverlap) || !(obj1.allowCollisions & DOWN) || !(obj2.allowCollisions & UP))
							overlap = 0;
						else {
							obj1.touching |= DOWN;
							obj1.touchingObjs[DOWN] = obj2;
							obj2.touching |= UP;
							obj2.touchingObjs[UP] = obj1;
						}
					} else if (obj1delta < obj2delta) {
						overlap = obj1.y - obj2.height - obj2.y;
						if ((-overlap > maxOverlap) || !(obj1.allowCollisions & UP) || !(obj2.allowCollisions & DOWN))
							overlap = 0;
						else {
							obj1.touching |= UP;
							obj1.touchingObjs[UP] = obj2;
							obj2.touching |= DOWN;
							obj2.touchingObjs[DOWN] = obj1;
						}
					}
				}
			}

			//Then adjust their positions and velocities accordingly (if there was any overlap)
			if (overlap != 0) {
				var obj1v:Number = obj1.velocity.y;
				var obj2v:Number = obj2.velocity.y;

				if (!obj1immovable && !obj2immovable) {
					overlap *= 0.5;
					obj1.y = obj1.y - overlap;
					obj2.y += overlap;

					var obj1velocity:Number = Math.sqrt((obj2v * obj2v * obj2.mass) / obj1.mass) * ((obj2v > 0) ? 1 : -1);
					var obj2velocity:Number = Math.sqrt((obj1v * obj1v * obj1.mass) / obj2.mass) * ((obj1v > 0) ? 1 : -1);
					var average:Number = (obj1velocity + obj2velocity) * 0.5;
					obj1velocity -= average;
					obj2velocity -= average;
					obj1.velocity.y = average + obj1velocity * obj1.elasticity;
					obj2.velocity.y = average + obj2velocity * obj2.elasticity;
				} else if (!obj1immovable) {
					obj1.y = obj1.y - overlap;
					obj1.velocity.y = obj2v - obj1v * obj1.elasticity;
				} else if (!obj2immovable) {
					obj2.y += overlap;
					obj2.velocity.y = obj1v - obj2v * obj2.elasticity;
				}
				return true;
			} else
				return false;
		}
	}
}
