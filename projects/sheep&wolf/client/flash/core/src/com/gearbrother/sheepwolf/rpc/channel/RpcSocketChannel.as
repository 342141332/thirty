package com.gearbrother.sheepwolf.rpc.channel {
	import com.gearbrother.glash.net.GChannelEvent;
	import com.gearbrother.glash.net.GSocketChannel;
	import com.gearbrother.glash.net.GSocketDataAssembler;
	import com.gearbrother.sheepwolf.rpc.event.RpcEvent;
	import com.gearbrother.sheepwolf.rpc.protocol.RpcProtocol;
	
	import flash.utils.Endian;

	[Event(name="data", type="com.gearbrother.sheepwolf.rpc.event.RpcEvent")]

	/**
	 * @author lifeng
	 * @create on 2013-12-11
	 */
	public class RpcSocketChannel extends GSocketChannel {
		public function RpcSocketChannel() {
			super(Endian.BIG_ENDIAN, new GSocketDataAssembler(4, int.MAX_VALUE, false));
			
			addEventListener(GChannelEvent.RECIEVE_SUCCESS, _handleRecieveSuccess);
		}
		
		private function _handleRecieveSuccess(event:GChannelEvent):void {
			var protocol:* = RpcProtocol.prototype2Protocol(JSON.parse(event.data as String));
			dispatchEvent(new RpcEvent(protocol));
		}
	}
}
