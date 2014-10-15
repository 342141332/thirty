package com.gearbrother.glash.net {
	import flash.events.Event;
	import flash.utils.ByteArray;


	/**
	 * @author feng.lee
	 * create on 2012-8-23 下午8:39:04
	 */
	public class GChannelEvent extends Event {
		static public const CONNECT_SUCCESS:String = "connect_success";

		static public const CONNECT_CLOSE:String = "connect_close";

		static public const SEND_SUCCESS:String = "send_success";

		static public const RECIEVE_ERROR:String = "recieve_error";

		static public const RECIEVE_SUCCESS:String = "recieve_success";

		public var data:String;

		public function GChannelEvent(type:String, data:String = null, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);

			this.data = data;
		}
	}
}
