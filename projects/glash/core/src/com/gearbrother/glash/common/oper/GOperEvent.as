package com.gearbrother.glash.common.oper {
	import flash.events.Event;


	/**
	 * 队列事件
	 *
	 */
	public class GOperEvent extends Event {
		/**
		 * 开始
		 */
		static public const OPERATION_START:String = "operation_start";

		/**
		 * 请求完成
		 */
		static public const OPERATION_COMPLETE:String = "operation_complete";

		/**
		 * 子对象开始
		 */
		static public const CHILD_OPERATION_START:String = "child_operation_start";

		/**
		 * 子对象请求完成
		 */
		static public const CHILD_OPERATION_COMPLETE:String = "child_operation_complete";

		/**
		 * 加载器
		 */
		public var task:GOper;

		/**
		 * 子加载器
		 */
		public var childTask:GOper;

		public function GOperEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}

		public override function clone():Event {
			var evt:GOperEvent = new GOperEvent(type, bubbles, cancelable);
			evt.task = this.task;
			evt.childTask = this.childTask;
			return evt;
		}
	}
}