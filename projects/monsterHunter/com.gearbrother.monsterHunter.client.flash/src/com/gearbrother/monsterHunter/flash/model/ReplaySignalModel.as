package com.gearbrother.monsterHunter.flash.model {
	import com.gearbrother.glash.mvc.model.GBean;

	/**
	 * @author feng.lee
	 * create on 2012-12-7 下午4:03:54
	 */
	public class ReplaySignalModel extends GBean {
		public var round:uint;
		
		public var actor:MonsterModel;
		
		public var skill:SkillModel;

		/**
		 * array of ReplaySignalResult
		 */
		public var results:Array;

		public function ReplaySignalModel() {
			results = [];
		}
	}
}
