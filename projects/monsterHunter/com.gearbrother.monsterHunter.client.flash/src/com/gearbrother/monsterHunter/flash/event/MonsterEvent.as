package com.gearbrother.monsterHunter.flash.event {
	import com.gearbrother.monsterHunter.flash.model.MonsterModel;
	import com.gearbrother.monsterHunter.flash.model.SkillBookModel;
	import com.gearbrother.monsterHunter.flash.model.SkillModel;
	
	import flash.events.Event;


	/**
	 * @author feng.lee
	 * @create on 2013-2-26
	 */
	public class MonsterEvent extends Event {
		static public const SHOW:String = "show";

		static public const GET_FOMAT:String = "get_fomat";

		static public const SET_FOMAT:String = "set_fomat";
		
		static public const ADD_SKILL_EXP:String = "add_skill_exp";

		static public function getSetFomatEvent(fomats:Array):MonsterEvent {
			var event:MonsterEvent = new MonsterEvent(SET_FOMAT);
			event.fomats = fomats;
			return event;
		}
		
		static public function getAddSkillExpEvent(monster:MonsterModel, skillIndex:int, book:SkillBookModel):MonsterEvent {
			var event:MonsterEvent = new MonsterEvent(ADD_SKILL_EXP);
			event.monster = monster;
			event.skillIndex = skillIndex;
			event.book = book;
			return event;
		}

		public var monster:MonsterModel;
		
		public var skillIndex:int;
		
		public var book:SkillBookModel;
		
		public var fomats:Array;

		public function MonsterEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
