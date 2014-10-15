package com.gearbrother.glash.net {
	import com.gearbrother.glash.net.GDataAssembleResult;
	import com.gearbrother.glash.net.GSocketDataAssembler;
	
	import flash.errors.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;

	/**
	 *
	 * @author yi.zhang
	 *
	 */
	public class GSocketChannel extends GChannel {
		static public const logger:ILogger = getLogger(GSocketChannel);

		protected var _socketDataAssembler:IGSocketDataAssembler;

		public function set socketDataAssembler(assembler:IGSocketDataAssembler):void {
			_socketDataAssembler = assembler;
		}

		protected var _socket:Socket;

		protected var _host:String;

		protected var _port:uint;

		//socket to c++ sever, server default use little endian
		//flash default use big endian
		public function GSocketChannel(endian:String = Endian.LITTLE_ENDIAN, assembler:IGSocketDataAssembler = null) {
			_socket = new Socket();
			_socket.endian = endian;
			_socket.addEventListener(Event.CLOSE, _handleSocketEvent);
			_socket.addEventListener(Event.CONNECT, _handleSocketEvent);
			_socket.addEventListener(Event.COMPLETE, _handleSocketEvent);
			_socket.addEventListener(IOErrorEvent.IO_ERROR, _handleSocketEvent);
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _handleSocketEvent);
			_socket.addEventListener(ProgressEvent.PROGRESS, _handleSocketEvent);
			_socket.addEventListener(ProgressEvent.SOCKET_DATA, _handleSocketEvent);
			socketDataAssembler = assembler || new GSocketDataAssembler();
		}
		
		public function isConnected():Boolean {
			return _socket != null && _socket.connected;
		}

		public function connect(host:String, port:int):void {
			disconnect();
			_socket.connect(host, port);
		}

		protected function _handleSocketEvent(event:Event):void {
			switch (event.type) {
				case Event.CLOSE:
					dispatchEvent(new GChannelEvent(GChannelEvent.CONNECT_CLOSE));
					break;
				case Event.CONNECT:
					if (_socket.connected == true)
						dispatchEvent(new GChannelEvent(GChannelEvent.CONNECT_SUCCESS));
					break;
				case Event.COMPLETE:
					break;
				case IOErrorEvent.IO_ERROR:
					dispatchEvent(new GChannelEvent(GChannelEvent.RECIEVE_ERROR));
					break;
				case SecurityErrorEvent.SECURITY_ERROR:
					dispatchEvent(new GChannelEvent(GChannelEvent.RECIEVE_ERROR));
					break;
				case ProgressEvent.PROGRESS:
					break;
				case ProgressEvent.SOCKET_DATA:
					while (_socket.connected == true && _socket.bytesAvailable) {
						var result:int = _socketDataAssembler.assemble(_socket);
						if (GDataAssembleResult.RESULT_WAIT == result) {
							break;
							continue;
						}
						if (GDataAssembleResult.RESULT_OK == result) {
							var datas:ByteArray = _socketDataAssembler.getAssembledDatas();
							var data:String = datas.readMultiByte(datas.length, "utf-8");
							logger.info("get {0}", [data]);
							dispatchEvent(new GChannelEvent(GChannelEvent.RECIEVE_SUCCESS, data));
						}
						if (GDataAssembleResult.RESULT_FAILED == result) {
							dispatchEvent(new GChannelEvent(GChannelEvent.RECIEVE_ERROR));
						}
					}
					break;
			}
		}

		public function disconnect():void {
			if (_socket.connected == true) {
				_socket.close();
				dispatchEvent(new GChannelEvent(GChannelEvent.CONNECT_CLOSE));
			}
		}

		override public function call(bytes:ByteArray):void {
			_socket.writeBytes(bytes);
			_socket.flush();
		}

		public function destroy():void {
			disconnect();
			_socket.removeEventListener(Event.CLOSE, _handleSocketEvent);
			_socket.removeEventListener(Event.CONNECT, _handleSocketEvent);
			_socket.removeEventListener(Event.COMPLETE, _handleSocketEvent);
			_socket.removeEventListener(IOErrorEvent.IO_ERROR, _handleSocketEvent);
			_socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _handleSocketEvent);
			_socket.removeEventListener(ProgressEvent.PROGRESS, _handleSocketEvent);
			_socket.removeEventListener(ProgressEvent.SOCKET_DATA, _handleSocketEvent);
		}
	}
}
