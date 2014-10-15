package com.gearbrother.monsterHunter.flash.model {
	import com.gearbrother.glash.common.resource.type.GAliasFile;
	import com.gearbrother.glash.common.resource.type.GBmdDefinition;
	import com.gearbrother.glash.common.resource.type.GFile;
	import com.gearbrother.glash.mvc.model.GBean;
	import com.gearbrother.glash.util.math.GRandomUtil;
	
	import flash.geom.Point;

	/**
	 * @author 		lifeng
	 * @version 	1.0.0
	 * create on	2012-12-8 下午1:40:45
	 */
	public class GameModel extends GBean {
		static public const instance:GameModel = new GameModel();

		public var argument:Argument;
		
		public var serverTime:int;

		private var _loginedUser:HunterModel;
		public function get loginedUser():HunterModel {
			return _loginedUser;
		}

		public function GameModel() {
			if (instance)
				throw new Error("Duplicate Root");
			
			_loginedUser = new HunterModel;
		}
	}
}
