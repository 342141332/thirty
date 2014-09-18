package com.gearbrother.glash.display.animation {
	import com.gearbrother.glash.common.oper.GOper;
	import com.gearbrother.glash.common.utils.GHandler;
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;


	/**
	 * @author neozhang
	 * @create on May 20, 2013
	 */
	public class GAnimation extends GOper {
		public var target:DisplayObject;

		public var duration:Number;

		private var _process:Number;

		public function get process():Number {
			return _process;
		}

		public function set process(newValue:Number):void {
			_process = newValue;
		}

		public var ease:Function;

		public function GAnimation(duration:Number = .7) {
			super();

			this.duration = duration;
//			ease = Linear.easeNone;
		}

		override public function execute():void {
			super.execute();

			_process = .0;
			TweenLite.killTweensOf(this);
			TweenLite.to(this, duration, {process: 1.0, ease: ease, onComplete: notifyResult});
		}
	}
}
