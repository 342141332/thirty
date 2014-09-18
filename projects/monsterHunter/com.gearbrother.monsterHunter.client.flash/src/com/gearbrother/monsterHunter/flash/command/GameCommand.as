package com.gearbrother.monsterHunter.flash.command {
	import com.gearbrother.glash.common.resource.type.GAliasFile;
	import com.gearbrother.glash.common.resource.type.GFile;
	import com.gearbrother.glash.common.utils.GHandler;
	import com.gearbrother.glash.util.math.GRandomUtil;
	import com.gearbrother.monsterHunter.flash.GameMain;
	import com.gearbrother.monsterHunter.flash.model.ExploreMapModel;
	import com.gearbrother.monsterHunter.flash.model.GameModel;
	import com.gearbrother.monsterHunter.flash.model.HunterModel;
	import com.gearbrother.monsterHunter.flash.model.MonsterModel;
	import com.gearbrother.monsterHunter.flash.model.ReplayModel;
	import com.gearbrother.monsterHunter.flash.model.ReplaySignalModel;
	import com.gearbrother.monsterHunter.flash.model.SkillBookModel;
	import com.gearbrother.monsterHunter.flash.model.SkillModel;
	import com.gearbrother.monsterHunter.flash.protocal.GameResponse;
	import com.gearbrother.monsterHunter.flash.protocal.GameResponseDomain;
	import com.gearbrother.monsterHunter.flash.service.IGameService;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;

	/**
	 * @author feng.lee
	 * create on 2013-2-26
	 */
	public class GameCommand {
		public var service:IGameService;
		
		public var model:GameModel;
		
		public function GameCommand() {
			service = GameMain.instance.apiService;
			model = GameModel.instance;
		}
		
		public function execute():void {}
		
		final public function handleResponse(res:Object):void {
			if (GameResponse.STATUS_SUCC == res.status) {
				result(res.body);
			} else {
				
			}
		}
		
		public function result(body:Object):void {
			if (body.hasOwnProperty(GameResponseDomain.BODY_TIME)) {
				model.serverTime = body[GameResponseDomain.BODY_TIME];
			}
			if (body.hasOwnProperty(GameResponseDomain.BODY_ME)) {
				decodeHunter(body[GameResponseDomain.BODY_ME], model.loginedUser);
			}
		}
		
		protected function decodeExploreMap(data:Object, model:ExploreMapModel = null):ExploreMapModel {
			model ||= new ExploreMapModel();
			var d:Object;
			if (data.hasOwnProperty("id"))
				model.id = data["id"];
			if (data.hasOwnProperty("name")) {
				model.name = data["name"];
			}
			model.backgoundSrc = new GAliasFile("asset/scene/"+ model.id % 17 +"/1.swf");
			if (data.hasOwnProperty("monsters")) {
				var monsters:Array = [];
				for each (d in data["monsters"]) {
					monsters.push(decodeMonster(d));
				}
				model.monsters = monsters;
			}
			if (data.hasOwnProperty("hunters")) {
				var hunters:Array = [];
				for each (d in data["hunters"]) {
					hunters.push(decodeHunter(d));
				}
				model.hunters = hunters;
			}
			return model;
		}
		
		protected function decodeReplay(data:Object, model:ReplayModel = null):ReplayModel {
			model ||= new ReplayModel();
			var monsterMap:Dictionary = new Dictionary();
			model.hunterA = decodeHunter(data["hunterA"]);
			if (data["hunterB"])
				model.hunterB = decodeHunter(data["hunterB"]);
			model.monstersA = [];
			var d:Object;
			for each (d in data["monstersA"]) {
				var monster:MonsterModel = decodeMonster(d);
				monsterMap[monster.id] = monster;
				model.monstersA.push(monster);
			}
			model.monstersB = [];
			for each (d in data["monstersB"]) {
				monster = decodeMonster(d);
				monsterMap[monster.id] = monster;
				model.monstersB.push(monster);
			}
			for each (d in data["signals"]) {
				var signal:ReplaySignalModel = new ReplaySignalModel();
				signal.round = d["round"];
				signal.actor = monsterMap[d["monsterID"]];
				for each (var skill:SkillModel in signal.actor.skills) {
					if (skill.id == d["skillID"])
						signal.skill = skill;
				}
				signal.results = [];
				for each (var r:Object in d["results"]) {
					signal.results.push(decodeMonster(r));
				}
				if (signal.results.length == 0)
					throw new Error("Invalid");
				model.signals.push(signal);
			}
			model.winner = data["winner"];
			return model;
		}
		
		protected function decodeHunter(data:Object, model:HunterModel = null):HunterModel {
			model ||= new HunterModel();
			var id:*;
			if (data.hasOwnProperty(GameResponseDomain.HUNTER_ID)) 
				model.id = data[GameResponseDomain.HUNTER_ID];
			if (data.hasOwnProperty(GameResponseDomain.HUNTER_NAME))
				model.name = data[GameResponseDomain.HUNTER_NAME];
			if (data.hasOwnProperty(GameResponseDomain.HUNTER_COIN)) {
				var coin:Object = data[GameResponseDomain.HUNTER_COIN];
				if (coin && coin.hasOwnProperty(GameResponseDomain.HUNTER_COIN_GOLD))
					model.gold = coin[GameResponseDomain.HUNTER_COIN_GOLD];
				if (coin && coin.hasOwnProperty(GameResponseDomain.HUNTER_COIN_SILVER))
					model.silver = coin[GameResponseDomain.HUNTER_COIN_SILVER];
			}
			if (data.hasOwnProperty(GameResponseDomain.HUNTER_ACTION_POINT)) {
				model.actionPoint = data[GameResponseDomain.HUNTER_ACTION_POINT];
			}
			if (data.hasOwnProperty(GameResponseDomain.HUNTER_MONSTERS)) {
				var monsters:Array = [];
				for (id in data[GameResponseDomain.HUNTER_MONSTERS]) {
					monsters.push(decodeMonster(data[GameResponseDomain.HUNTER_MONSTERS][id]));
				}
				model.monsters = monsters;
				var filterFomated:Function = function(d:*, index:int, array:Array):Boolean {
					return (d as MonsterModel).fomat != null;
				};
				model.fomats = model.monsters.filter(filterFomated);
				var filterFollow:Function = function(d:*, index:int, array:Array):Boolean {
					return (d as MonsterModel).follow;
				};
				var follows:Array = model.monsters.filter(filterFollow);
				model.followMonster = follows.length > 0 ? follows[0] : null;
			}
			if (data.hasOwnProperty(GameResponseDomain.HUNTER_BAGS)) {
				var bags:Array = [];
				for (id in data[GameResponseDomain.HUNTER_BAGS]) {
					bags.push(decodeBag(data[GameResponseDomain.HUNTER_BAGS][id]));
				}
				model.bagItems = bags;
			}
			if (data.hasOwnProperty(GameResponseDomain.HUNTER_MAP_ID)) {
				model.mapID = data[GameResponseDomain.HUNTER_MAP_ID];
			}
			return model;
		}
		
		protected function decodeMonster(data:Object, model:MonsterModel = null):MonsterModel {
			model ||= new MonsterModel();
			if (data.hasOwnProperty("id"))
				model.id = data["id"];
			if (data.hasOwnProperty("confID"))
				model.confID = data["confID"];
			if (data.hasOwnProperty("hp"))
				model.hp = data["hp"];
			if (data.hasOwnProperty("level"))
				model.level = data["level"];
			if (data.hasOwnProperty("rank"))
				model.rank = data["rank"];
			if (data.hasOwnProperty("attackDamage"))
				model.attackDamage = data["attackDamage"];
			if (data.hasOwnProperty("attackArmor"))
				model.attackArmor = data["attackArmor"];
			if (data.hasOwnProperty("abilityPower"))
				model.abilityPower = data["abilityPower"];
			if (data.hasOwnProperty("abilityArmor"))
				model.abilityArmor = data["abilityArmor"];
			if (data.hasOwnProperty("speed"))
				model.speed = data["speed"];
			if (data.hasOwnProperty("skills")) {
				var skills:Array = [];
				for each (var skillData:Object in data["skills"]) {
					skills.push(decodeSkill(skillData));
				}
				model.skills = skills;
			}
			if (data.hasOwnProperty("fomat")) {
				if (data["fomat"])
					model.fomat = new Point(data["fomat"]["x"], data["fomat"]["y"]);
				else
					model.fomat = null;
			}
			if (data.hasOwnProperty("mapPosition")) {
				if (data["mapPosition"])
					model.mapPosition = new Point(data["mapPosition"]["x"], data["mapPosition"]["y"]);
				else
					model.mapPosition = null;
			}
			if (data.hasOwnProperty("follow"))
				model.follow = data["follow"];
			return model;
		}
		
		protected function decodeSkill(data:Object, model:SkillModel = null):SkillModel {
			model ||= new SkillModel();
			if (data.hasOwnProperty("id"))
				model.id = data["id"];
			if (data.hasOwnProperty("confID"))
				model.confID = data["confID"];
			if (data.hasOwnProperty("exp"))
				model.exp = data["exp"];
			return model;
		}
		
		protected function decodeBag(data:Object, model:SkillBookModel = null):SkillBookModel {
			model ||= new SkillBookModel();
			if (data.hasOwnProperty("id"))
				model.id = data["id"];
			if (data.hasOwnProperty("confID"))
				model.confID = data["confID"];
			if (data.hasOwnProperty("num"))
				model.num = data["num"];
			return model;
		}
	}
}
