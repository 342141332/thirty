package com.gearbrother.sheepwolf.command {
	import com.gearbrother.monsterHunter.flash.event.BagEvent;
	import com.gearbrother.monsterHunter.flash.event.ExploreMapEvent;
	import com.gearbrother.monsterHunter.flash.event.LoginEvent;
	import com.gearbrother.monsterHunter.flash.event.MonsterEvent;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;


	/**
	 * @author feng.lee
	 * create on 2013-2-26
	 */
	public class GameCommandMap extends CommandMap {
		static public var instance:GameCommandMap;
		
		public function get _eventDispatcher():IEventDispatcher {
			return eventDispatcher;
		}
		
		public function GameCommandMap() {
			super(new EventDispatcher());
			
			mapEvent(LoginEvent.LOGIN, LoginCommand, LoginEvent);
			mapEvent(MonsterEvent.SHOW, MonsterCommand, MonsterEvent);
			mapEvent(MonsterEvent.GET_FOMAT, MonsterCommand, MonsterEvent);
			mapEvent(MonsterEvent.SET_FOMAT, MonsterCommand, MonsterEvent);
			mapEvent(MonsterEvent.ADD_SKILL_EXP, MonsterCommand, MonsterEvent);
			mapEvent(BagEvent.GET, BagCommand, BagEvent);
			mapEvent(ExploreMapEvent.GET, ExploreMapCommand, ExploreMapEvent);
			mapEvent(ExploreMapEvent.HUNT, ExploreMapCommand, ExploreMapEvent);
			mapEvent(ExploreMapEvent.CATCH, ExploreMapCommand, ExploreMapEvent);
			mapEvent(ExploreMapEvent.FIGHT, ExploreMapCommand, ExploreMapEvent);
			
			_eventDispatcher.dispatchEvent(new LoginEvent(LoginEvent.LOGIN));
			if (!instance)
				instance = this;
			else
				throw new Error("only one");
		}
	}
}
