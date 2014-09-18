package com.gearbrother.mushroomWar.rpc.event {
	import flash.events.Event;

	/**
	 * @author lifeng
	 * @create on 2013-11-3
	 */
	public class RpcEvent extends Event {
		static public const DATA:String = "data";

		public var response:Object;

		public function RpcEvent(response:Object) {
			super(DATA);

			this.response = response;
		}
	}
}
