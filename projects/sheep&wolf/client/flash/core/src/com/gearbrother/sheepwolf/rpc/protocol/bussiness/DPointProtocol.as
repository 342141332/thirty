package com.gearbrother.sheepwolf.rpc.protocol.bussiness {
	import com.gearbrother.sheepwolf.rpc.protocol.*;

	/**
	 * Don't modify manually
	 *
	 * @generated by tool
	 * @create on 2014-05-26 15:10:38
	 */
	public class DPointProtocol extends RpcProtocol {
		/**
		 * x
		 */
		static public const X:String = "x";

		/**
		 * get x
		 */
		public function get x():Number {
			return getProperty(X);
		}

		/**
		 * set x
		 */
		public function set x(newValue:Number):void {
			setProperty(X, newValue);
		}

		/**
		 * y
		 */
		static public const Y:String = "y";

		/**
		 * get y
		 */
		public function get y():Number {
			return getProperty(Y);
		}

		/**
		 * set y
		 */
		public function set y(newValue:Number):void {
			setProperty(Y, newValue);
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

		public function DPointProtocol(prototype:Object = null) {
			super(prototype);

			if (prototype) {
			}
		}
	}
}
