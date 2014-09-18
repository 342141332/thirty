package com.gearbrother.glash.common.algorithm.astar {
	import flash.events.Event;


	/**
	 * @author lifeng
	 * @create on 2013-7-28
	 */
	public class GridEvent extends Event {
		public function GridEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
