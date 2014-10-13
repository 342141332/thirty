package com.gearbrother.sheepwolf.rpc.service {
	import com.gearbrother.glash.util.lang.UUID;
	import com.gearbrother.sheepwolf.rpc.channel.RpcSocketChannel;
	import com.gearbrother.sheepwolf.rpc.event.RpcEvent;
	import com.gearbrother.sheepwolf.rpc.protocol.bussiness.RpcCallResponseProtocol;
	
	import flash.utils.ByteArray;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;

	/**
	 * @author neozhang
	 * @create on Nov 1, 2013
	 */
	public class RpcService {
		static public const logger:ILogger = getLogger(RpcService);

		private var _handles:Object = {};

		private var _channel:RpcSocketChannel;

		public function RpcService(channel:RpcSocketChannel) {
			_channel = channel;
			_channel.addEventListener(RpcEvent.DATA, _handleRecieveSuccess);
		}

		private function _handleRecieveSuccess(event:RpcEvent):void {
			var protocol:* = event.response;
			if (protocol is RpcCallResponseProtocol) {
				var response:RpcCallResponseProtocol = protocol;
				if (response.uuid) {
					if (_handles.hasOwnProperty(response.uuid)) {
						var handles:Array = _handles[response.uuid];
						delete _handles[response.uuid];
						if (!response.isFailed) {
							if (handles[0] != null)
								handles[0](response.result);
						} else {
							if (handles[1] != null)
								handles[1](response.result);
							//TODO
//							GameMain.instance.notelayer.showNode(response.result as String);
						}
					}
				} else {
					throw new Error("RpcResponseProtocol should have id");
				}
			}
		}

		/**
		 * send data to server, auto remove listener when data return from server.
		 * @param method
		 * @param argus
		 * @param successCallback
		 * @param errorCallback
		 * @return
		 *
		 */
		protected function call(method:String, argus:Array, successCallback:Function = null, errorCallback:Function = null):RpcServiceCall {
			var messageID:String = UUID.getUUID();
			var message:String = JSON.stringify({"id": messageID, "version": 1.0, "method": method, "argus": argus});
			var messageContent:ByteArray = new ByteArray();
			messageContent.writeMultiByte(message, "utf-8");
			var content:ByteArray = new ByteArray();
			content.writeInt(messageContent.length);
			content.writeBytes(messageContent);
			_channel.call(content);
			logger.info("send {0}", [message]);
			_handles[messageID] = [successCallback, errorCallback];
			return new RpcServiceCall(_handles, messageID);
		}
	}
}
