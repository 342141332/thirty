package com.gearbrother.monsterHunter.flash.event {
	import flash.events.Event;


	/**
	 * @author feng.lee
	 * create on 2013-2-27
	 */
	public class BagEvent extends Event {
		static public const GET:String = "BagEvent::get";
		
		public function BagEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
