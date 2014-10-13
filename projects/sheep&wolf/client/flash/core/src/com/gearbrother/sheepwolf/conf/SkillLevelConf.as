package com.gearbrother.sheepwolf.conf {
	import com.gearbrother.glash.common.oper.ext.GAliasFile;

	/**
	 * @author lifeng
	 * @create on 2014-3-7
	 */
	public class SkillLevelConf {
		public var ablityPower:Array;
		
		public var catoon:GAliasFile;
		
		public var coolDown:Number;
		
		public var select:Object;
		
		public function SkillLevelConf(prototype:Object = null) {
			if (prototype) {
				ablityPower = prototype["ablityPower"];
				catoon = new GAliasFile(prototype["catoon"]);
				coolDown = prototype["coolDown"];
				select = prototype["select"];
			}
		}
	}
}
