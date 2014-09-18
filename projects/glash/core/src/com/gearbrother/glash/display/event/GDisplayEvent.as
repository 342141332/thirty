package com.gearbrother.glash.display.event {
	import flash.events.Event;

	public class GDisplayEvent extends Event {
		static public const SCROLL_CHANGE:String = "scroll";

		static public const SELECT_CHANGE:String = "select";

		static public const LABEL_ENTER:String = "label_enter";
		
		static public const LABEL_QUEUE_START:String = "label_queue_start";

		static public const LABEL_QUEUE_END:String = "label_queue_end";

		static public const LABEL_QUEUE_EMPTY:String = "label_queue_empty";

		static public const LABEL_QUEUE_ERROR:String = "label_queue_error";

		public function GDisplayEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}

		public override function clone():Event {
			var evt:GDisplayEvent = new GDisplayEvent(type, bubbles, cancelable);
			return evt;
		}
	}
}
