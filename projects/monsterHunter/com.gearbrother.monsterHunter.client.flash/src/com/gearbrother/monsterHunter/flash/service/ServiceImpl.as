package com.gearbrother.monsterHunter.flash.service {
	import com.gearbrother.glash.common.oper.GQueue;
	import com.gearbrother.glash.net.GHttpChannel;
	import com.gearbrother.monsterHunter.flash.model.MonsterModel;
	import com.gearbrother.monsterHunter.flash.model.SkillBookModel;
	import com.gearbrother.monsterHunter.flash.model.SkillModel;


	/**
	 * @author 		lifeng
	 * @version 	1.0.0
	 * create on	2012-12-9 下午3:09:19
	 */
	public class ServiceImpl implements IGameService {
		public function ServiceImpl() {
		}

		public function login(callback:Function):void {
		}

		public function combineMonsterSkill(monster:MonsterModel, skillIndex:int, book:SkillBookModel, callback:Function):void {
		}
		
		public function getBagItems(callback:Function):void {
		}

		public function getMonsters(callback:Function):void {
		}
		
		public function getMonsterFomat(callback:Function):void {
		}
		
		public function setMonsterFomat(monsters:Array, callback:Function):void {
		}

		public function getReplay(callback:Function):void {
		}
		
		public function enterExploreMap(mapID:*, callback:Function):void {
		}
		
		public function hunt(mapID:*, monsterID:*, callback:Function):void {
		}
		
		public function fightHunter(hunterID:*, callback:Function):void {
		}
		
		public function catchMonster(replayID:*, monsterID:*, callback:Function):void {
		}
	}
}
