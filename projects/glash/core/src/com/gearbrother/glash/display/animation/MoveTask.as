package com.gearbrother.glash.display.animation {
	import com.gearbrother.glash.common.oper.GOper;
	import com.gearbrother.glash.common.utils.GHandler;
	import com.gearbrother.glash.display.IGTickable;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.utils.getTimer;


	/**
	 * 沿着固定路径点移动
	 *
	 */
	public class MoveTask extends GOper implements IGTickable {
		public var item:DisplayObject;
		public var path:Array;
		public var speed:Number;
		public var ease:Function;
		public var arriveCallback:GHandler;

		private var stepLength:Array;
		private var totalLength:Number;
		private var len:Number;

		public var oldPosition:Point;
		public var position:Point;

		private var _startTime:int = -1;

		public function MoveTask(path:Array, speed:Number, item:DisplayObject, ease:Function = null, arriveCallback:GHandler = null) {
			super();

			this.path = path;
			this.speed = speed;
			this.item = item;
			this.ease = ease;
			this.arriveCallback = arriveCallback;
		}

		public function tick(interval:int):void {
			if (_startTime == -1) {
				_startTime = getTimer() - interval;
				this.stepLength = [];
				for (var i:int = 0; i < path.length - 1; i++) {
					var prevLength:Number = i > 0 ? this.stepLength[i - 1] : 0;
					this.stepLength[i] = prevLength + Point.distance(path[i], path[i + 1]);
				}
				this.totalLength = this.stepLength[this.stepLength.length - 1];
				this.len = this.totalLength / speed;
				this.position = this.oldPosition = path[0];
			}

			var interval2:Number = getTimer() - _startTime;
			interval2 /= 1000;
			oldPosition = position.clone();
			var p:Number;
			if (ease != null)
				p = ease(interval2, 0, totalLength, len);
			else
				p = interval2 * speed;

			position = getPosition(p);

			if (interval2 >= len) {
				if (arriveCallback)
					arriveCallback.call();
				arriveCallback = null;
				_startTime = -1;
			}
		}

		public function getPosition(pos:Number):Point {
			var step:int = 0;
			var l:int = stepLength.length;
			while (step < l && pos > stepLength[step])
				step++;

			if (step < l) {
				var prevLength:Number = step > 0 ? stepLength[step - 1] : 0;
				var curLength:Number = stepLength[step] - prevLength;
				return Point.interpolate(path[step + 1], path[step], isNaN((pos - prevLength) / curLength) ? 0 : (pos - prevLength) / curLength);
			} else {
				return path[path.length - 1];
			}
		}
	}
}
