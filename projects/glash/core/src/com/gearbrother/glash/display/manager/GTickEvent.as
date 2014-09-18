package com.gearbrother.glash.display.manager {
	import flash.events.Event;

	public class GTickEvent extends Event {
		public static const TICK:String = "tick";

		/**
		 * 两次发布事件的毫秒间隔
		 */
		public var interval:int;

		/**
		 * 用于Tick的发布事件
		 *
		 * @param type	类型
		 * @param interval	两次事件的毫秒间隔
		 *
		 */
		public function GTickEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}

		public override function clone():Event {
			var evt:GTickEvent = new GTickEvent(type, bubbles, cancelable);
			evt.interval = this.interval;
			return evt;
		}
	}
}
