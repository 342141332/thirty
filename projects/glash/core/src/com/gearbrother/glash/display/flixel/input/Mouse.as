package com.gearbrother.glash.display.flixel.input {
	import com.gearbrother.glash.display.flixel.system.replay.MouseRecord;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;


	/**
	 * This class helps contain and track the mouse pointer in your game.
	 * Automatically accounts for parallax scrolling, etc.
	 *
	 * @author Adam Atomic
	 */
	public class Mouse extends Point {
		/**
		 * Current "delta" value of mouse wheel.  If the wheel was just scrolled up, it will have a positive value.  If it was just scrolled down, it will have a negative value.  If it wasn't just scroll this frame, it will be 0.
		 */
		public var wheel:int;
		/**
		 * Current X position of the mouse pointer on the screen.
		 */
		public var screenX:int;
		/**
		 * Current Y position of the mouse pointer on the screen.
		 */
		public var screenY:int;

		/**
		 * Helper variable for tracking whether the mouse was just pressed or just released.
		 */
		protected var _current:int;
		/**
		 * Helper variable for tracking whether the mouse was just pressed or just released.
		 */
		protected var _last:int;
		/**
		 * Helper variables for recording purposes.
		 */
		protected var _lastX:int;
		protected var _lastY:int;
		protected var _lastWheel:int;
		protected var _point:Point;
		protected var _globalScreenPosition:Point;

		/**
		 * Constructor.
		 */
		public function Mouse() {
			super();
			_lastX = screenX = 0;
			_lastY = screenY = 0;
			_lastWheel = wheel = 0;
			_current = 0;
			_last = 0;
			_point = new Point();
			_globalScreenPosition = new Point();
		}

		/**
		 * Clean up memory.
		 */
		public function destroy():void {
			_point = null;
			_globalScreenPosition = null;
		}

		/**
		 * Called by the internal game loop to update the mouse pointer's position in the game world.
		 * Also updates the just pressed/just released flags.
		 *
		 * @param	X			The current X position of the mouse in the window.
		 * @param	Y			The current Y position of the mouse in the window.
		 * @param	XScroll		The amount the game world has scrolled horizontally.
		 * @param	YScroll		The amount the game world has scrolled vertically.
		 */
		public function update(X:int, Y:int):void {
			_globalScreenPosition.x = X;
			_globalScreenPosition.y = Y;
			if ((_last == -1) && (_current == -1))
				_current = 0;
			else if ((_last == 2) && (_current == 2))
				_current = 1;
			_last = _current;
		}

		/**
		 * Resets the just pressed/just released flags and sets mouse to not pressed.
		 */
		public function reset():void {
			_current = 0;
			_last = 0;
		}

		/**
		 * Check to see if the mouse is pressed.
		 *
		 * @return	Whether the mouse is pressed.
		 */
		public function pressed():Boolean {
			return _current > 0;
		}

		/**
		 * Check to see if the mouse was just pressed.
		 *
		 * @return Whether the mouse was just pressed.
		 */
		public function justPressed():Boolean {
			return _current == 2;
		}

		/**
		 * Check to see if the mouse was just released.
		 *
		 * @return	Whether the mouse was just released.
		 */
		public function justReleased():Boolean {
			return _current == -1;
		}

		/**
		 * Event handler so FlxGame can update the mouse.
		 *
		 * @param	FlashEvent	A <code>MouseEvent</code> object.
		 */
		public function handleMouseDown(FlashEvent:MouseEvent):void {
			if (_current > 0)
				_current = 1;
			else
				_current = 2;
		}

		/**
		 * Event handler so FlxGame can update the mouse.
		 *
		 * @param	FlashEvent	A <code>MouseEvent</code> object.
		 */
		public function handleMouseUp(FlashEvent:MouseEvent):void {
			if (_current > 0)
				_current = -1;
			else
				_current = 0;
		}

		/**
		 * Event handler so FlxGame can update the mouse.
		 *
		 * @param	FlashEvent	A <code>MouseEvent</code> object.
		 */
		public function handleMouseWheel(FlashEvent:MouseEvent):void {
			wheel = FlashEvent.delta;
		}

		/**
		 * If the mouse changed state or is pressed, return that info now
		 *
		 * @return	An array of key state data.  Null if there is no data.
		 */
		public function record():MouseRecord {
			if ((_lastX == _globalScreenPosition.x) && (_lastY == _globalScreenPosition.y) && (_current == 0) && (_lastWheel == wheel))
				return null;
			_lastX = _globalScreenPosition.x;
			_lastY = _globalScreenPosition.y;
			_lastWheel = wheel;
			return new MouseRecord(_lastX, _lastY, _current, _lastWheel);
		}

		/**
		 * Part of the keystroke recording system.
		 * Takes data about key presses and sets it into array.
		 *
		 * @param	KeyStates	Array of data about key states.
		 */
		public function playback(Record:MouseRecord):void {
			_current = Record.button;
			wheel = Record.wheel;
			_globalScreenPosition.x = Record.x;
			_globalScreenPosition.y = Record.y;
		}
	}
}
