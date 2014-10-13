package com.gearbrother.monsterHunter.flash.protocal {

	/**
	 * @author feng.lee
	 * create on 2013-2-26
	 */
	public class GameResponse {
		static public const STATUS_SUCC:int = 0;
		static public const STATUS_FAIL:int = 1;

		public var status:int;
		
		public var body:Object;

		public function GameResponse(status:int, body:Object) {
			this.status = status;
			this.body = body;
		}
	}
}
