package com.gearbrother.mushroomWar.model {

	/**
	 * @author lifeng
	 * @create on 2014-1-6
	 */
	public class GameModel {
		static public const instance:GameModel = new GameModel();

		public var application:ApplicationModel;

		public var loginedUser:UserModel;

		public function GameModel() {
		}
	}
}
