package com.gearbrother.mushroomWar.conf {
	import com.gearbrother.glash.common.oper.ext.GAliasFile;
	import com.gearbrother.glash.common.oper.ext.GBmdDefinition;
	import com.gearbrother.glash.common.oper.ext.GDefinition;

	/**
	 * @author lifeng
	 * @create on 2014-1-6
	 */
	public class ExplorerConf {
		static public const confs:Object = {};
		
		static public function decodeConfigFile(configFile:Array):void {
			for each (var prototype:Object in configFile) {
				var conf:ExplorerConf = new ExplorerConf(prototype);
				confs[conf.uuid] = conf;
			}
		}

		public var uuid:String;
		public var name:String;
		public var headPortraint:GAliasFile;
		public var avatarWidth:int;
		public var avatarHeight:int;
		public var offsetX:int;
		public var offsetY:int;
		public var catoonStand:GBmdDefinition;
		public var catoonWalk:GBmdDefinition;
		public var catoonAttack:GBmdDefinition;
		public var catoonSkill:GBmdDefinition;
		public var growUp:Object;
		public var skills:Object;

		public function ExplorerConf(prototype:Object = null) {
			if (prototype) {
				if (prototype.hasOwnProperty("uuid"))
					uuid = prototype["uuid"];
				if (prototype.hasOwnProperty("name"))
					name = prototype["name"];
				if (prototype.hasOwnProperty("headPortraint"))
					headPortraint = new GAliasFile(prototype["headPortraint"]);
				if (prototype.hasOwnProperty("avatarWidth"))
					avatarWidth = prototype["avatarWidth"];
				if (prototype.hasOwnProperty("avatarHeight"))
					avatarHeight = prototype["avatarHeight"];
				if (prototype.hasOwnProperty("offsetX"))
					offsetX = prototype["offsetX"];
				if (prototype.hasOwnProperty("offsetY"))
					offsetX = prototype["offsetY"];
				if (prototype.hasOwnProperty("catoon")) {
					catoonStand = new GBmdDefinition(new GDefinition(new GAliasFile(prototype["catoon"]), "Stand"));
					catoonWalk = new GBmdDefinition(new GDefinition(new GAliasFile(prototype["catoon"]), "Walk"));
					catoonAttack = new GBmdDefinition(new GDefinition(new GAliasFile(prototype["catoon"]), "Attack"));
					catoonSkill = new GBmdDefinition(new GDefinition(new GAliasFile(prototype["catoon"]), "Skill"));
				}
				growUp = {};
				if (prototype.hasOwnProperty("growUp")) {
					var growUpPrototype:Object = prototype["growUp"];
					for (var key:String in growUpPrototype) {
						growUp[key] = new ModelLevelConf(growUpPrototype[key]);
					}
				}
				skills = {};
				if (prototype.hasOwnProperty("skills")) {
					var skillsPrototype:Object = prototype["skills"];
					for (key in skillsPrototype) {
						skills[key] = new SkillConf(skillsPrototype[key]);
					}
				}
			}
		}
	}
}
