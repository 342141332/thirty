package com.gearbrother.glash.mvc {
	import flash.events.Event;

	/**
	 * 指令事件
	 *
	 */
	public class GActionEvent extends Event {
		/**
		 * 指令事件
		 */
		public static const ACTION:String = "action";

		/**
		 * 指令
		 */
		public var action:String;

		/**
		 * 参数
		 */
		public var parameters:Array;

		public function GActionEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}

		public override function clone():Event {
			var evt:GActionEvent = new GActionEvent(type, bubbles, cancelable);
			evt.action = this.action;
			evt.parameters = this.parameters;
			return evt;
		}
	}
}