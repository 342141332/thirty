package com.gearbrother.glash.display {
	import flash.events.IEventDispatcher;


	[Event(name = "scroll", type = "com.gearbrother.glash.display.event.GDisplayEvent")]

	public interface IGScrollable extends IEventDispatcher {
		function get width():Number;
		function get height():Number;
		
		function get minScrollH():int;
		function get maxScrollH():int;
		function get scrollH():int;
		function set scrollH(newValue:int):void;
		function get scrollHPageSize():int;

		function get minScrollV():int;
		function get maxScrollV():int;
		function get scrollV():int;
		function set scrollV(newValue:int):void;
		function get scrollVPageSize():int;
	}
}
