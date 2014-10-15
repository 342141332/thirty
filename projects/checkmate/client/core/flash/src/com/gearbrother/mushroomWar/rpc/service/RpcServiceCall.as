package com.gearbrother.mushroomWar.rpc.service {

	/**
	 * @author lifeng
	 * @create on 2013-11-14
	 */
	public class RpcServiceCall {
		public var handles:Object;

		public var uuid:String;

		public function RpcServiceCall(handles:Object, uuid:String) {
			this.handles = handles;
			this.uuid = uuid;
		}

		public function close():void {
			delete handles[uuid];
		}
	}
}
