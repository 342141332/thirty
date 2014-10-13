package com.gearbrother.monsterHunter.flash.event {
	import flash.events.Event;

	/**
	 * @author feng.lee
	 * create on 2013-2-26
	 */
	public class LoginEvent extends Event {
		static public const LOGIN:String = "login";
		
		public function LoginEvent(type:String) {
			super(type);
		}
	}
}
