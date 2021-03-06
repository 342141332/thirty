package com.gearbrother.sheepwolf.rpc.protocol.bussiness {
	import com.gearbrother.sheepwolf.rpc.protocol.*;

	/**
	 * Don't modify manually
	 *
	 * @generated by tool
	 * @create on 2014-05-26 15:10:38
	 */
	public class BattleProtocol extends RpcProtocol {
		/**
		 * 身份唯一ID
		 */
		static public const UUID:String = "uuid";

		/**
		 * get 身份唯一ID
		 */
		public function get uuid():String {
			return getProperty(UUID);
		}

		/**
		 * set 身份唯一ID
		 */
		public function set uuid(newValue:String):void {
			setProperty(UUID, newValue);
		}

		/**
		 * 地图配置ID
		 */
		static public const CONF_ID:String = "confId";

		/**
		 * get 地图配置ID
		 */
		public function get confId():String {
			return getProperty(CONF_ID);
		}

		/**
		 * set 地图配置ID
		 */
		public function set confId(newValue:String):void {
			setProperty(CONF_ID, newValue);
		}

		/**
		 * 开始时间
		 */
		static public const START_TIME:String = "startTime";

		/**
		 * get 开始时间
		 */
		public function get startTime():Number {
			return getProperty(START_TIME);
		}

		/**
		 * set 开始时间
		 */
		public function set startTime(newValue:Number):void {
			setProperty(START_TIME, newValue);
		}

		/**
		 * 羊开始时间
		 */
		static public const SHEEP_SLEEP_AT:String = "sheepSleepAt";

		/**
		 * get 羊开始时间
		 */
		public function get sheepSleepAt():Number {
			return getProperty(SHEEP_SLEEP_AT);
		}

		/**
		 * set 羊开始时间
		 */
		public function set sheepSleepAt(newValue:Number):void {
			setProperty(SHEEP_SLEEP_AT, newValue);
		}

		/**
		 * 狼开始时间
		 */
		static public const WOLF_SLEEP_AT:String = "wolfSleepAt";

		/**
		 * get 狼开始时间
		 */
		public function get wolfSleepAt():Number {
			return getProperty(WOLF_SLEEP_AT);
		}

		/**
		 * set 狼开始时间
		 */
		public function set wolfSleepAt(newValue:Number):void {
			setProperty(WOLF_SLEEP_AT, newValue);
		}

		/**
		 * 玩家
		 */
		static public const USERS:String = "users";

		/**
		 * get 玩家
		 */
		public function get users():Object {
			return getProperty(USERS);
		}

		/**
		 * set 玩家
		 */
		public function set users(newValue:Object):void {
			setProperty(USERS, newValue);
		}

		/**
		 * 
		 */
		static public const $CLASS:String = "$class";

		/**
		 * get 
		 */
		public function get $class():String {
			return getProperty($CLASS);
		}

		/**
		 * set 
		 */
		public function set $class(newValue:String):void {
			setProperty($CLASS, newValue);
		}

		public function BattleProtocol(prototype:Object = null) {
			super(prototype);

			if (prototype) {
				if (prototype[USERS])
					prototype[USERS] = prototype2Protocol(prototype[USERS]);
			}
		}
	}
}
