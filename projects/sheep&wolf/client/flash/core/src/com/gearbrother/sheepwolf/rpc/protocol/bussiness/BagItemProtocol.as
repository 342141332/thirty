package com.gearbrother.sheepwolf.rpc.protocol.bussiness {
	import com.gearbrother.sheepwolf.rpc.protocol.*;

	/**
	 * Don't modify manually
	 *
	 * @generated by tool
	 * @create on 2014-05-26 15:10:38
	 */
	public class BagItemProtocol extends RpcProtocol {
		/**
		 * 唯一id
		 */
		static public const UUID:String = "uuid";

		/**
		 * get 唯一id
		 */
		public function get uuid():String {
			return getProperty(UUID);
		}

		/**
		 * set 唯一id
		 */
		public function set uuid(newValue:String):void {
			setProperty(UUID, newValue);
		}

		/**
		 * 配置描述ID
		 */
		static public const CONF_I_D:String = "confID";

		/**
		 * get 配置描述ID
		 */
		public function get confID():String {
			return getProperty(CONF_I_D);
		}

		/**
		 * set 配置描述ID
		 */
		public function set confID(newValue:String):void {
			setProperty(CONF_I_D, newValue);
		}

		/**
		 * 数量
		 */
		static public const COUNT:String = "count";

		/**
		 * get 数量
		 */
		public function get count():int {
			return getProperty(COUNT);
		}

		/**
		 * set 数量
		 */
		public function set count(newValue:int):void {
			setProperty(COUNT, newValue);
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

		public function BagItemProtocol(prototype:Object = null) {
			super(prototype);

			if (prototype) {
			}
		}
	}
}
