package com.gearbrother.monsterHunter.flash.command {
	import com.gearbrother.glash.common.utils.GHandler;
	import com.gearbrother.monsterHunter.flash.event.MonsterEvent;
	import com.gearbrother.monsterHunter.flash.model.MonsterModel;
	import com.gearbrother.monsterHunter.flash.view.window.MyFomatWindowView;
	import com.gearbrother.monsterHunter.flash.view.window.MyMonsterWindowView;

	/**
	 * @author feng.lee
	 * @create on 2013-2-26
	 */
	public class MonsterCommand extends GameCommand {
		public var event:MonsterEvent;
		
		public function MonsterCommand() {
			super();
		}
		
		override public function execute():void {
			switch (event.type) {
				case MonsterEvent.SHOW:
					service.getMonsters(handleResponse);
					break;
				case MonsterEvent.GET_FOMAT:
					service.getMonsterFomat(handleResponse);
					break;
				case MonsterEvent.SET_FOMAT:
					service.setMonsterFomat(event.fomats, handleResponse);
					break;
				case MonsterEvent.ADD_SKILL_EXP:
					service.combineMonsterSkill(event.monster, event.skillIndex, event.book, handleResponse);
					break;
			}
		}
		
		override public function result(body:Object):void {
			super.result(body);

			switch (event.type) {
				case MonsterEvent.SHOW:
					new MyMonsterWindowView().open();
					break;
				case MonsterEvent.GET_FOMAT:
					new MyFomatWindowView().open();
					break;
				case MonsterEvent.ADD_SKILL_EXP:
					decodeSkill(body["private"], event.monster.skills[event.skillIndex]);
					break;
			}
		}
	}
}
