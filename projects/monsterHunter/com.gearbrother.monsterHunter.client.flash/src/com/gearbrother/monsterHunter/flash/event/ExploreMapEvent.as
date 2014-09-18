package com.gearbrother.monsterHunter.flash.event {
	import flash.events.Event;


	/**
	 * @author feng.lee
	 * @create on 2013-3-4
	 */
	public class ExploreMapEvent extends Event {
		static public const GET:String = "ExploreMapEvent::get";
		
		static public const HUNT:String = "HUNT";
		
		static public const CATCH:String = "catch";
		
		static public const FIGHT:String = "FIGHT";
		
		static public function getFightEvent(hunterID:*):ExploreMapEvent {
			var event:ExploreMapEvent = new ExploreMapEvent(FIGHT);
			event.hunterID = hunterID;
			return event;
		}
		
		static public function getGetEvent(mapID:*):ExploreMapEvent {
			var event:ExploreMapEvent = new ExploreMapEvent(GET);
			event.mapID = mapID;
			return event;
		}
		
		static public function getHuntEvent(mapID:*, monsterID:*):ExploreMapEvent {
			var event:ExploreMapEvent = new ExploreMapEvent(HUNT);
			event.mapID = mapID;
			event.monsterID = monsterID;
			return event;
		}
		
		static public function getCatchEvent(replayID:*, monsterID:*):ExploreMapEvent {
			var event:ExploreMapEvent = new ExploreMapEvent(CATCH);
			event.replayID = replayID;
			event.monsterID = monsterID;
			return event;
		}
		
		public var mapID:*;
		
		public var monsterID:*;
		
		public var replayID:*;
		
		public var hunterID:*;
		
		public function ExploreMapEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
