package com.gearbrother.monsterHunter.flash.model {
	import com.gearbrother.glash.common.resource.type.GBmdDefinition;
	import com.gearbrother.glash.common.resource.type.GFile;
	import com.gearbrother.glash.util.math.GRandomUtil;

	/**
	 *
	 * @author feng.lee
	 *
	 */
	public class SkillModelConf {
		static public const confs:Object = {};

		public var name:String;

		public var descript:String;

		public var icon:GFile;

		/**
		 * 释放者是否需要靠近被释放者
		 */
		public var needClose:Boolean;

		public var movieDefinition:GBmdDefinition;

		/**
		 * 释放技能者动画ID, 0为action0, 1为action1
		 */
		public var actorMovieID:int;
		
		public var isDamage:Boolean;
		
		public var levelExps:Array;
		
		public var isMulti:Boolean;

		public function SkillModelConf() {
			actorMovieID = GRandomUtil.choose([0, 1]);
		}
	}
}
