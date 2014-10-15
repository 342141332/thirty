package com.gearbrother.glash.display.event {
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.Event;

	/**
	 * 拖拽事件 
	 * @author yi.zhang
	 * 
	 */	
	public class GDndEvent extends Event {
		public static const Drop:String = "DndEvent.Drop";

		public static const MOVE:String = "DndEvent.Move";

		public static const OUT:String = "DndEvent.Out";

		public static const OVER:String = "DndEvent.Over";

		private var _data:Object;

		public function get data():Object {
			return _data;
		}

		private var _source:DisplayObject;

		public function get source():DisplayObject {
			return _source;
		}

		public function GDndEvent(type:String, data:Object, source:DisplayObject, bubbles:Boolean = true, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);

			_data = data;
			_source = source;
		}
	}
}