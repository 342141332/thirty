package com.gearbrother.monsterHunter.flash.service {
	import com.gearbrother.glash.common.utils.GHandler;
	import com.gearbrother.glash.util.lang.UUID;
	import com.gearbrother.glash.util.math.GRandomUtil;
	import com.gearbrother.monsterHunter.flash.model.ExploreMapModel;
	import com.gearbrother.monsterHunter.flash.model.HunterModel;
	import com.gearbrother.monsterHunter.flash.model.MonsterModel;
	import com.gearbrother.monsterHunter.flash.model.ReplayModel;
	import com.gearbrother.monsterHunter.flash.model.ReplaySignalModel;
	import com.gearbrother.monsterHunter.flash.model.SkillBookModel;
	import com.gearbrother.monsterHunter.flash.model.SkillModel;
	import com.gearbrother.monsterHunter.flash.protocal.GameResponseDomain;
	
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;



	/**
	 * @author 		lifeng
	 * @version 	1.0.0
	 * create on	2012-12-9 上午12:28:49
	 */
	public class DebugServiceImpl extends ServiceImpl {
		static public const logger:ILogger = getLogger(DebugServiceImpl);
		
		static public const DELAY_RETURN:int = 700;

		private var _db:Database;
		
		private var _delayHander:Array;
		
		private var _timer:Timer;
		
		private var _loginedUser:HunterModel;
		
		private var _replay:ReplayModel;

		public function DebugServiceImpl() {
			super();

			_db = new Database();
			_delayHander = [];
			_timer = new Timer(DELAY_RETURN);
			_timer.addEventListener(TimerEvent.TIMER, _flushResponse);
			_timer.start();
		}

		private function _flushResponse(event:TimerEvent):void {
			var handler:GHandler = _delayHander.shift();
			if (handler)
				handler.call();
		}
		
		private function buildResponse():Object {
			var res:Object = {};
			res["status"] = 0;
			res["body"] = {};
			res["body"][GameResponseDomain.BODY_TIME] = new Date().time;
			return res;
		}

		override public function login(callback:Function):void {
			_loginedUser = _db.newHunter("唐僧洗头爱霸王");
			_loginedUser.mapID = 0;
			var res:Object = buildResponse();
			res.body[GameResponseDomain.BODY_ME] = encodeHunter(_loginedUser);
			_delayHander.push(new GHandler(callback, [res]));
		}
		
		override public function getMonsters(callback:Function):void {
			var res:Object = buildResponse();
			var ar:Array = [];
			for each (var monster:MonsterModel in _loginedUser.monsters) {
				ar.push(encodeMonster(monster));
			}
			res.body[GameResponseDomain.HUNTER_MONSTERS] = ar;
			_delayHander.push(new GHandler(callback, [res]));
		}
		
		override public function getMonsterFomat(callback:Function):void {
			var res:Object = buildResponse();
			var ar:Array = [];
			for each (var monster:MonsterModel in _loginedUser.fomats) {
				ar.push(encodeMonster(monster));
			}
			_delayHander.push(new GHandler(callback, [res]));
		}
		
		override public function setMonsterFomat(monsters:Array, callback:Function):void {
			var fomatedMonsterIDs:Dictionary = new Dictionary;
			var monster:MonsterModel;
			for each (monster in monsters) {
				fomatedMonsterIDs[monster.id] = monster;
			}
			function filterFomated(d:MonsterModel, index:int, array:Array):Boolean {
				return fomatedMonsterIDs.hasOwnProperty(d.id);
			}
			for each (monster in _loginedUser.monsters) {
				if (fomatedMonsterIDs.hasOwnProperty(monster.id))
					monster.fomat = (fomatedMonsterIDs[monster.id] as MonsterModel).fomat.clone();
				else
					monster.fomat = null;
			}
			_loginedUser.fomats = _loginedUser.monsters.filter(filterFomated);
			var res:Object = buildResponse();
			res.body[GameResponseDomain.BODY_ME] = encodeHunter(_loginedUser);
			_delayHander.push(new GHandler(callback, [res]));
		}
		
		override public function combineMonsterSkill(monster:MonsterModel, skillIndex:int, book:SkillBookModel, callback:Function):void {
			function filterFomated(d:MonsterModel, index:int, array:Array):Boolean {
				return monster.id == d.id;
			}
			monster = _loginedUser.monsters.filter(filterFomated)[0];
			var skill:SkillModel = monster.skills[skillIndex];
			function filterBook(d:*, index:int, array:Array):Boolean {
				return d is SkillBookModel && (d as SkillBookModel).id == book.id;
			}
			book = _loginedUser.bagItems.filter(filterBook)[0];
			if (--book.num == 0)
				_loginedUser.bagItems.splice(_loginedUser.bagItems.indexOf(book), 1);
			if (skill && skill.confID == book.skillConfID) {
				skill.exp += book.equalExp;
			} else {
				skill = new SkillModel();
				skill.confID = book.skillConfID;
				monster.skills[skillIndex] = skill;
			}
			var res:Object = buildResponse();
			res.body["private"] = encodeSkill(skill);
			_delayHander.push(new GHandler(callback, [res]));
		}
		
		override public function getBagItems(callback:Function):void {
			var res:Object = buildResponse();
			_delayHander.push(new GHandler(callback, [res]));
		}
		
		override public function enterExploreMap(mapID:*, callback:Function):void {
			var res:Object = buildResponse();
			res.body[GameResponseDomain.SCENE] = encodeExploreMap(_db.getTable(ExploreMapModel)[mapID]);
			_loginedUser.mapID = mapID;
			_delayHander.push(new GHandler(callback, [res]));
		}
		
		override public function hunt(mapID:*, monsterID:*, callback:Function):void {
			var map:ExploreMapModel = _db.getTable(ExploreMapModel)[mapID];
			function filterFomated(d:*, index:int, array:Array):Boolean {
				return monsterID == d.id;
			}
			var monster:MonsterModel = map.monsters.filter(filterFomated)[0];
			var res:Object = buildResponse();
			var replay:ReplayModel = fight(_loginedUser.fomats, [monster]);
			replay.hunterA = _loginedUser;
			res.body[GameResponseDomain.REPLAY] = encodeReplay(replay);
			//catch Monster
			if (replay.winner) {
				monster = monster.clone();
				monster.fomat = null;
				monster.id = UUID.getUUID();
				_loginedUser.monsters.push(monster);
				res.body[GameResponseDomain.BODY_ME] = encodeHunter(_loginedUser);
			}
			_replay = replay;
			_delayHander.push(new GHandler(callback, [res]));
		}
		
		override public function fightHunter(hunterID:*, callback:Function):void {
			var res:Object = buildResponse();
			var hunterB:HunterModel = _db.getTable(HunterModel)[hunterID] as HunterModel;
			var replay:ReplayModel = fight(_loginedUser.fomats, hunterB.fomats);
			replay.hunterA = _loginedUser;
			replay.hunterB = hunterB;
			res.body[GameResponseDomain.REPLAY] = encodeReplay(replay);
			_delayHander.push(new GHandler(callback, [res]));
		}
		
		private function fight(monstersASource:Array, monstersBSource:Array):ReplayModel {
			var replay:ReplayModel = new ReplayModel();
			replay.monstersA = monstersASource;
			replay.monstersB = monstersBSource;
			var monstersA:Array = [];
			var fomat:MonsterModel;
			for each (fomat in monstersASource) {
				monstersA.push(fomat.clone());
			}
			var monstersB:Array = [];
			for each (fomat in monstersBSource) {
				monstersB.push(fomat.clone());
			}
			var comparePosition:Function = function (a:MonsterModel, b:MonsterModel):int {
				if (a.hp <= 0)
					return 1;
				if (a.fomat.x > b.fomat.x)
					return 1;
				else if (a.fomat.x == b.fomat.x)
					return a.fomat.y - b.fomat.y;
				else if (a.fomat.x < b.fomat.x)
					return -1;
				else
					return 0;
			};
			var monsters:Array = monstersA.concat(monstersB);
			point:for (var j:int = 0; j < 100; j++) {
				var actor:MonsterModel = monsters[j % monsters.length];
				if (actor.hp <= 0)
					continue;
				for each (var armedSkill:SkillModel in actor.skills) {
					var enemies:Array = monstersA.indexOf(actor) == -1 ? monstersA : monstersB;
					enemies.sort(comparePosition);
					var pickedActors:Array = [enemies[0]];
					var signal:ReplaySignalModel = new ReplaySignalModel();
					signal.actor = actor;
					signal.skill = armedSkill;
					for each (var resultActor:MonsterModel in pickedActors) {
						var result:MonsterModel = resultActor;
						result.hp -= Math.max(1, actor.attackDamage * (armedSkill.level * .5 + 1) - result.attackArmor);
						signal.results.push(result.clone());
					}
					signal.round = j;
					replay.signals.push(signal);
					
					var isAllDead:Boolean = true;
					for each (var enemy:MonsterModel in enemies) {
						isAllDead = isAllDead && enemy.hp <= 0;
					}
					if (isAllDead) {
						replay.winner = monstersA.indexOf(actor) != -1;
						break point;
					}
				}
			}
			return replay;
		}
		
		override public function catchMonster(replayID:*, monsterID:*, callback:Function):void {
			var res:Object = buildResponse();
			function filterMonster(d:*, index:int, array:Array):Boolean {
				return monsterID == d.id;
			}
			var monster:MonsterModel = _replay.monstersB.filter(filterMonster)[0];
			monster = monster.clone();
			monster.id = UUID.getUUID();
			_loginedUser.monsters.push(monster);
			res.body[GameResponseDomain.PRIVATE] = encodeMonster(monster);
			_delayHander.push(new GHandler(callback, [res]));
		}
		
		private function encodeHunter(model:HunterModel):Object {
			var monsters:Array = [];
			for each (var monster:MonsterModel in model.monsters) {
				monsters.push(encodeMonster(monster));
			}
			var bags:Array = [];
			for each (var bag:SkillBookModel in model.bagItems) {
				bags.push(encodeSkillBook(bag));
			}
			var body:Object = {};
			body[GameResponseDomain.HUNTER_ID] = model.id;
			body[GameResponseDomain.HUNTER_NAME] = model.name;
			body[GameResponseDomain.HUNTER_COIN] = {};
			body[GameResponseDomain.HUNTER_COIN][GameResponseDomain.HUNTER_COIN_GOLD] = model.gold;
			body[GameResponseDomain.HUNTER_COIN][GameResponseDomain.HUNTER_COIN_SILVER] = model.silver;
			body[GameResponseDomain.HUNTER_COIN] = model.actionPoint;
			body[GameResponseDomain.HUNTER_MONSTERS] = monsters;
			body[GameResponseDomain.HUNTER_BAGS] = bags;
			if (model.mapID != undefined)
				body[GameResponseDomain.HUNTER_MAP_ID] = model.mapID;
			return body;
		}
		
		private function encodeMonster(model:MonsterModel):Object {
			var skills:Array = [];
			for each (var skill:SkillModel in model.skills) {
				skills.push(encodeSkill(skill));
			}
			return {id: model.id, confID: model.confID, rank: model.rank, hp: model.hp
				, level: model.level
				, attackDamage: model.attackDamage, attackArmor: model.attackArmor
				, abilityPower: model.abilityPower, abilityArmor: model.abilityArmor, speed: model.speed, skills: skills, mapPosition: model.mapPosition, fomat: model.fomat, follow: model.follow};
		}
		
		private function encodeSkill(model:SkillModel):Object {
			return {id: model.id, exp: model.exp, confID: model.confID};
		}
		
		private function encodeSkillBook(model:SkillBookModel):Object {
			return {id: model.id, confID: model.confID, num: model.num};
		}
		
		private function encodeExploreMap(model:ExploreMapModel):Object {
			var hunters:Array = [];
			for each (var hunter:HunterModel in model.hunters) {
				hunters.push(encodeHunter(hunter));
			}
			var monsters:Array = [];
			for each (var monster:MonsterModel in model.monsters) {
				monsters.push(encodeMonster(monster));
			}
			return {id: model.id, name: model.name, hunters: hunters, monsters: monsters};
		}
		
		private function encodeReplay(model:ReplayModel):Object {
			var monstersA:Array = [];
			var d:MonsterModel;
			for each (d in model.monstersA) {
				monstersA.push(encodeMonster(d));
			}
			var monstersB:Array = [];
			for each (d in model.monstersB) {
				monstersB.push(encodeMonster(d));
			}
			var signals:Array = [];
			for each (var signal:ReplaySignalModel in model.signals) {
				var results:Array = [];
				for each (d in signal.results) {
					results.push(encodeMonster(d));
				}
				signals.push({round: signal.round, monsterID: signal.actor.id, skillID: signal.skill.id, results: results});
			}
			return {id: model.id, hunterA: encodeHunter(model.hunterA), monstersA: monstersA, hunterB: model.hunterB ? encodeHunter(model.hunterB) : null, monstersB: monstersB, signals: signals, winner: model.winner};
		}
	}
}
import com.gearbrother.glash.common.resource.type.GAliasFile;
import com.gearbrother.glash.common.resource.type.GBmdDefinition;
import com.gearbrother.glash.common.resource.type.GDefinition;
import com.gearbrother.glash.util.lang.UUID;
import com.gearbrother.glash.util.math.GRandomUtil;
import com.gearbrother.monsterHunter.flash.model.ExploreMapModel;
import com.gearbrother.monsterHunter.flash.model.HunterModel;
import com.gearbrother.monsterHunter.flash.model.MonsterModel;
import com.gearbrother.monsterHunter.flash.model.MonsterModelConf;
import com.gearbrother.monsterHunter.flash.model.SkillBookModel;
import com.gearbrother.monsterHunter.flash.model.SkillModel;
import com.gearbrother.monsterHunter.flash.model.SkillModelConf;
import com.gearbrother.monsterHunter.flash.service.DebugServiceImpl;

import flash.geom.Point;
import flash.utils.Dictionary;

import org.as3commons.lang.ObjectUtils;
import org.as3commons.logging.api.ILogger;
import org.as3commons.logging.api.getLogger;

class Database {
	static public const logger:ILogger = getLogger(Database);
	
	static public const NAMES:Array = ["北莲", "紫翠", "雨寒", "易烟", "如萱", "若南", "寻真", "晓亦", "背珊", "慕灵", "以蕊", "映易", "雪柳", "海云", "凝天", "沛珊", "寒云", "冰旋", "宛儿"];
	
	public var skills:Array;

	public var monsterConfKeys:Array;
	
	private var _tables:Dictionary;
	
	public function newHunter(name:String = null):HunterModel {
		var hunter:HunterModel = new HunterModel();
		hunter.id = UUID.getUUID();
		hunter.name = name || GRandomUtil.pickRandom(NAMES);
		hunter.gold = 7;
		hunter.silver = 37;
		hunter.actionPoint = 10;
		getTable(HunterModel)[hunter.id] = hunter;
		hunter.monsters = [];
		var i:int;
		for (i = 0; i < GRandomUtil.integer(2, 3); i++) {
			hunter.monsters.push(newMonster(hunter, GRandomUtil.pickRandom(monsterConfKeys)));
		}
		hunter.monsters[0].fomat = new Point(4, 4);
		hunter.monsters[1].fomat = new Point(3, 3);
		hunter.fomats = [hunter.monsters[0], hunter.monsters[1]];
		hunter.followMonster = hunter.monsters[GRandomUtil.integer(0, hunter.monsters.length - 1)];
		hunter.followMonster.follow = true;
		hunter.bagItems = [];
		for (i = 0; i < 3; i++) {
			var book:SkillBookModel = newSkillBook(i);
			book.num = 20;
			hunter.bagItems.push(book);
		}
		return hunter;
	}
	
	public function newSkill(id:*, confID:*):SkillModel {
		var skillA:SkillModel = new SkillModel();
		skillA.id = UUID.getUUID();
		skillA.confID = confID;
		return skillA;
	}
	
	public function newSkillBook(confID:*):SkillBookModel {
		var skillA:SkillBookModel = new SkillBookModel();
		skillA.id = UUID.getUUID();
		skillA.confID = confID;
		skillA.equalExp = 50;
		return skillA;
	}
	
	public function newMonster(hunter:HunterModel, confID:int, skills:Array = null):MonsterModel {
		var actorModel:MonsterModel = new MonsterModel();
		actorModel.id = UUID.getUUID();
		actorModel.user = hunter;
		actorModel.confID = confID;
		actorModel.rank = GRandomUtil.integer(1, 4);
		actorModel.level = GRandomUtil.integer(1, 10);
		/*actorModel.armedSkills = */actorModel.skills = skills || GRandomUtil.pickRandomNum(this.skills, actorModel.rank < 3 ? 1 : 2);
		actorModel.hp = GRandomUtil.integer(40, 70);
		actorModel.attackDamage = GRandomUtil.integer(10, 20);
		actorModel.attackArmor = GRandomUtil.integer(1, 7) * actorModel.attackDamage / 20;
		actorModel.abilityPower = GRandomUtil.integer(1, 5);
		actorModel.abilityArmor = GRandomUtil.integer(1, 3);
		return actorModel;
	}
	
	public function Database() {
		_tables = new Dictionary();
		var i:int = 0;
		
		//=============== build "Skill Config" ===============//
		var skillConfDB:Array = [
			{id: 0, close: false, icon: new GAliasFile("asset/skill/1.png"), movie: "injured1.swf"}
			, {id: 1, close: false, icon: new GAliasFile("asset/skill/4.png"), movie: "4.swf"}
			, {id: 2, close: false, icon: new GAliasFile("asset/skill/5.png"), movie: "5.swf"}
			, {id: 3, close: false, icon: new GAliasFile("asset/skill/6.png"), movie: "6.swf"}
			, {id: 4, close: false, icon: new GAliasFile("asset/skill/7.png"), movie: "7.swf"}
			, {id: 5, close: false, icon: new GAliasFile("asset/skill/8.png"), movie: "8.swf"}
			, {id: 6, close: false, icon: new GAliasFile("asset/skill/9.png"), movie: "9.swf"}
			, {id: 7, close: false, icon: new GAliasFile("asset/skill/10.png"), movie: "10.swf"}
			, {id: 8, close: false, icon: new GAliasFile("asset/skill/11.png"), movie: "11.swf"}
			, {id: 9, close: false, icon: new GAliasFile("asset/skill/12.png"), movie: "12.swf"}
			, {id: 10, close: false, icon: new GAliasFile("asset/skill/13.png"), movie: "13.swf"}
			, {id: 11, close: false, icon: new GAliasFile("asset/skill/14.png"), movie: "14.swf"}
			, {id: 12, close: false, icon: new GAliasFile("asset/skill/15.png"), movie: "15.swf"}
			, {id: 13, close: false, icon: new GAliasFile("asset/skill/16.png"), movie: "16.swf"}
			, {id: 14, close: false, icon: new GAliasFile("asset/skill/17.png"), movie: "17.swf"}
		];
		for each (var row:Object in skillConfDB) {
			var skillConf:SkillModelConf = new SkillModelConf();
			skillConf.needClose = row["close"];
			skillConf.icon = row["icon"];
			skillConf.movieDefinition = new GBmdDefinition(new GDefinition(new GAliasFile("asset/skill/" + row["movie"]), "Main"));
			skillConf.levelExps = [];
			for (i = 0; i < 10; i++) {
				skillConf.levelExps.push(Math.sin(i / 10 * Math.PI / 2) * Math.sin(i / 10 * Math.PI / 2) * 1000);
			}
			SkillModelConf.confs[row["id"]] = skillConf;
		}
		
		//=============== build "Monster Config" ===============//
		var monsterConfDB:Array = [
			{id: 1, name: "福特犬", file: new GAliasFile("asset/avatar/1.swf")}
			, {id: 2, name: "加里猫", file: new GAliasFile("asset/avatar/2.swf")}
			, {id: 3, name: "吸血蝠", file: new GAliasFile("asset/avatar/3.swf")}
			, {id: 4, name: "哥布林", file: new GAliasFile("asset/avatar/4.swf")}
			, {id: 5, name: "狼蛛", file: new GAliasFile("asset/avatar/5.swf")}
			, {id: 6, name: "哥布林", file: new GAliasFile("asset/avatar/10001.swf")}
			, {id: 7, name: "北极狼", file: new GAliasFile("asset/avatar/10002.swf")}
			, {id: 8, name: "小恶魔", file: new GAliasFile("asset/avatar/10003.swf")}
			, {id: 9, name: "鹰女", file: new GAliasFile("asset/avatar/10004.swf")}
			, {id: 10, name: "雪妖", file: new GAliasFile("asset/avatar/10005.swf")}
			, {id: 11, name: "战熊", file: new GAliasFile("asset/avatar/10006.swf")}
			, {id: 12, name: "刺虫", file: new GAliasFile("asset/avatar/10007.swf")}
			, {id: 13, name: "蜘蛛", file: new GAliasFile("asset/avatar/10008.swf")}
			, {id: 14, name: "石头人", file: new GAliasFile("asset/avatar/10009.swf")}
			, {id: 15, name: "蝇", file: new GAliasFile("asset/avatar/10010.swf")}
			, {id: 16, name: "地狱犬", file: new GAliasFile("asset/avatar/10011.swf")}
			, {id: 17, name: "甲虫", file: new GAliasFile("asset/avatar/10012.swf")}
			, {id: 18, name: "双头龙", file: new GAliasFile("asset/avatar/10013.swf")}
			, {id: 19, name: "女人马", file: new GAliasFile("asset/avatar/10014.swf")}
			, {id: 20, name: "娜加海妖", file: new GAliasFile("asset/avatar/10015.swf")}
			, {id: 21, name: "牛头人", file: new GAliasFile("asset/avatar/10016.swf")}
			, {id: 22, name: "毒虫", file: new GAliasFile("asset/avatar/10017.swf")}
			, {id: 23, name: "狼人", file: new GAliasFile("asset/avatar/10018.swf")}
			, {id: 24, name: "熊", file: new GAliasFile("asset/avatar/10019.swf")}
			, {id: 25, name: "精灵", file: new GAliasFile("asset/avatar/10020.swf")}
			, {id: 26, name: "地精修补匠", file: new GAliasFile("asset/avatar/10021.swf")}
			, {id: 27, name: "地精矿工", file: new GAliasFile("asset/avatar/10022.swf")}
			, {id: 28, name: "树人", file: new GAliasFile("asset/avatar/10023.swf")}
			, {id: 29, name: "雷兽", file: new GAliasFile("asset/avatar/10024.swf")}
			, {id: 30, name: "豹", file: new GAliasFile("asset/avatar/10025.swf")}
			, {id: 31, name: "甲壳虫", file: new GAliasFile("asset/avatar/10026.swf")}
			, {id: 32, name: "地穴巨人", file: new GAliasFile("asset/avatar/10027.swf")}
//			, {id: 33, name: "蜘蛛", file: new GAliasFile("asset/avatar/50008.swf")}
//			, {id: 34, name: "蜘蛛", file: new GAliasFile("asset/avatar/50003.swf")}
			, {id: 35, name: "???", file: new GAliasFile("asset/avatar/50012.swf")}
		];
		for each (var row2:Object in monsterConfDB) {
			var monsterConf:MonsterModelConf = new MonsterModelConf();
			monsterConf.name = row2.name;
			monsterConf.definitionStand = new GBmdDefinition(new GDefinition(row2.file, "Stand"));
			monsterConf.definitionMove = new GBmdDefinition(new GDefinition(row2.file, "Walk"));
			monsterConf.definitionAttackMovie = new GBmdDefinition(new GDefinition(row2.file, "Attack"));
			monsterConf.definitionAttackMovie.signalChildrenNames = ["target"];
			monsterConf.definitionAbilityMovie = new GBmdDefinition(new GDefinition(row2.file, "Attack"));
			monsterConf.definitionAbilityMovie.signalChildrenNames = ["target"];
			MonsterModelConf.confs[row2["id"]] = monsterConf;
		}
		
		var monsterConfKeys:Array = ObjectUtils.getKeys(MonsterModelConf.confs);
		monsterConfKeys.splice(-1, 1);
		this.monsterConfKeys = monsterConfKeys;
		
		//=============== build "Skll Table" ===============//
		skills = [];
		var confs:Array = ObjectUtils.getKeys(SkillModelConf.confs);
		for (i = 0; i < confs.length; i++) {
			skills.unshift(newSkill(i, GRandomUtil.choose(confs)));
		}
		
		//=============== build "Hunter Table" ===============//
		
		
		//=============== build explore map ===============//
		for (var j:int = 0; j < 100; j++) {
			var map:ExploreMapModel = getTable(ExploreMapModel)[j] = new ExploreMapModel();
			map.id = j;
			map.name = "kalrLand";
			var pickedConfKeys:Array = GRandomUtil.pickRandomNum(monsterConfKeys, 2);
			for (i = 0; i < GRandomUtil.integer(5, 7); i++) {
				var monster:MonsterModel = newMonster(null, GRandomUtil.pickRandom(pickedConfKeys));
//				monster.hp *= 2;
//				monster.attackDamage *= 2;
//				monster.attackArmor *= 2;
				monster.mapPosition = new Point(GRandomUtil.integer(500, 2000), GRandomUtil.integer(400, 600));
				monster.fomat = new Point(0, 3);
				map.monsters.push(monster);
			}
			for (i = 0; i < GRandomUtil.integer(3, 10); i++) {
				map.hunters.push(newHunter());
			}
		}
		
		(getTable(ExploreMapModel)[4] as ExploreMapModel).monsters.splice(1, int.MAX_VALUE);
		var boss:MonsterModel = (getTable(ExploreMapModel)[4] as ExploreMapModel).monsters[0];
		boss.attackDamage *= 30;
		boss.confID = 35;
		boss.level = 999;
	}
	
	public function getTable(clazz:Class):Object {
		var table:Object;
		if (!(table = _tables[clazz]))
			table = _tables[clazz] = {};
		return table;
	}
}