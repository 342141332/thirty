package com.gearbrother.glash.net {
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;

	[Event(name = "connect_success", type = "com.gearbrother.glash.net.GChannelEvent")]
	[Event(name = "connect_close", type = "com.gearbrother.glash.net.GChannelEvent")]
	[Event(name = "send_error", type = "com.gearbrother.glash.net.GChannelEvent")]
	[Event(name = "send_success", type = "com.gearbrother.glash.net.GChannelEvent")]
	[Event(name = "recieve_error", type = "com.gearbrother.glash.net.GChannelEvent")]
	[Event(name = "recieve_success", type = "com.gearbrother.glash.net.GChannelEvent")]

	/**
	 * @author feng.lee
	 * @create on Jul 2, 2013
	 */
	public class GChannel extends EventDispatcher {
		public function GChannel(target:IEventDispatcher = null) {
			super(target);
		}

		public function call(bytes:ByteArray):void {
		}
	}
}
