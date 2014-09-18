package com.gearbrother.mushroomWar.conf {

	/**
	 * @author lifeng
	 * @create on 2014-3-5
	 */
	public class SkillConf {
		static public const confs:Object = {};
		
		public static function decodeConfigFile(configFile:Array):void {
			for each (var prototype:Object in configFile) {
				var conf:SkillConf = new SkillConf(prototype);
			}
		}

		public var name:String;
		
		public var growUp:Object;

		public function SkillConf(prototype:Object = null) {
			if (prototype) {
				name = prototype["name"];
				growUp = {};
				for (var key:String in prototype["growUp"]) {
					growUp[key] = new SkillLevelConf(prototype[key]);
				}
			}
		}
	}
}
