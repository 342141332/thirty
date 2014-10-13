package com.gearbrother.monsterHunter.flash.service {
	import com.gearbrother.monsterHunter.flash.model.MonsterModel;
	import com.gearbrother.monsterHunter.flash.model.SkillBookModel;
	import com.gearbrother.monsterHunter.flash.model.SkillModel;

	public interface IGameService {
		function login(callback:Function):void;

		function getMonsters(callback:Function):void;

		function getMonsterFomat(callback:Function):void;

		function setMonsterFomat(monsters:Array, callback:Function):void;

		function combineMonsterSkill(monster:MonsterModel, skillIndex:int, book:SkillBookModel, callback:Function):void;

		function getBagItems(callback:Function):void;

		function getReplay(callback:Function):void;

		function enterExploreMap(mapID:*, callback:Function):void;

		function hunt(mapID:*, monsterID:*, callback:Function):void;
		
		function fightHunter(hunterID:*, callback:Function):void;

		function catchMonster(replayID:*, monsterID:*, callback:Function):void;
	}
}
