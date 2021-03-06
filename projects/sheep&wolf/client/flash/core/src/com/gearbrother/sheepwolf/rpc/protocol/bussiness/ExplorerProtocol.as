package com.gearbrother.sheepwolf.rpc.protocol.bussiness {
	import com.gearbrother.sheepwolf.rpc.protocol.*;

	/**
	 * Don't modify manually
	 *
	 * @generated by tool
	 * @create on 2014-05-26 15:10:38
	 */
	public class ExplorerProtocol extends RpcProtocol {
		/**
		 * 唯一身份Id
		 */
		static public const UUID:String = "uuid";

		/**
		 * get 唯一身份Id
		 */
		public function get uuid():String {
			return getProperty(UUID);
		}

		/**
		 * set 唯一身份Id
		 */
		public function set uuid(newValue:String):void {
			setProperty(UUID, newValue);
		}

		/**
		 * 模型id
		 */
		static public const CATOON_ID:String = "catoonId";

		/**
		 * get 模型id
		 */
		public function get catoonId():String {
			return getProperty(CATOON_ID);
		}

		/**
		 * set 模型id
		 */
		public function set catoonId(newValue:String):void {
			setProperty(CATOON_ID, newValue);
		}

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
		 * 血量
		 */
		static public const HP:String = "hp";

		/**
		 * get 血量
		 */
		public function get hp():int {
			return getProperty(HP);
		}

		/**
		 * set 血量
		 */
		public function set hp(newValue:int):void {
			setProperty(HP, newValue);
		}

		/**
		 * max血量
		 */
		static public const MAX_HP:String = "maxHp";

		/**
		 * get max血量
		 */
		public function get maxHp():int {
			return getProperty(MAX_HP);
		}

		/**
		 * set max血量
		 */
		public function set maxHp(newValue:int):void {
			setProperty(MAX_HP, newValue);
		}

		/**
		 * 状态
		 */
		static public const BUFF:String = "buff";

		/**
		 * get 状态
		 */
		public function get buff():Object {
			return getProperty(BUFF);
		}

		/**
		 * set 状态
		 */
		public function set buff(newValue:Object):void {
			setProperty(BUFF, newValue);
		}

		/**
		 * 
		 */
		static public const CURRENT_ACTION:String = "currentAction";

		/**
		 * get 
		 */
		public function get currentAction():Object {
			return getProperty(CURRENT_ACTION);
		}

		/**
		 * set 
		 */
		public function set currentAction(newValue:Object):void {
			setProperty(CURRENT_ACTION, newValue);
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

		public function ExplorerProtocol(prototype:Object = null) {
			super(prototype);

			if (prototype) {
				if (prototype[BUFF])
					prototype[BUFF] = prototype2Protocol(prototype[BUFF]);
				if (prototype[CURRENT_ACTION])
					prototype[CURRENT_ACTION] = prototype2Protocol(prototype[CURRENT_ACTION]);
			}
		}
	}
}
