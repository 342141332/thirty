package com.gearbrother.sheepwolf.rpc.protocol.bussiness {
	import com.gearbrother.sheepwolf.rpc.protocol.*;

	/**
	 * Don't modify manually
	 *
	 * @generated by tool
	 * @create on 2014-05-26 15:10:38
	 */
	public class BattleToolProtocol extends RpcProtocol {
		/**
		 * 等级
		 */
		static public const LEVEL:String = "level";

		/**
		 * get 等级
		 */
		public function get level():int {
			return getProperty(LEVEL);
		}

		/**
		 * set 等级
		 */
		public function set level(newValue:int):void {
			setProperty(LEVEL, newValue);
		}

		/**
		 * 冷却时间
		 */
		static public const COOL_DOWN:String = "coolDown";

		/**
		 * get 冷却时间
		 */
		public function get coolDown():Number {
			return getProperty(COOL_DOWN);
		}

		/**
		 * set 冷却时间
		 */
		public function set coolDown(newValue:Number):void {
			setProperty(COOL_DOWN, newValue);
		}

		/**
		 * 上一次使用时间
		 */
		static public const LAST_USE_TIME:String = "lastUseTime";

		/**
		 * get 上一次使用时间
		 */
		public function get lastUseTime():Number {
			return getProperty(LAST_USE_TIME);
		}

		/**
		 * set 上一次使用时间
		 */
		public function set lastUseTime(newValue:Number):void {
			setProperty(LAST_USE_TIME, newValue);
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

		public function BattleToolProtocol(prototype:Object = null) {
			super(prototype);

			if (prototype) {
			}
		}
	}
}
