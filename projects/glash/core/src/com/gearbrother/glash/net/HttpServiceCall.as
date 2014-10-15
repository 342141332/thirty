package com.gearbrother.glash.net {
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLStream;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;

	/**
	 *
	 * @author 	Neo.Zhang
	 * @create 	2014-7-8 下午4:12:29
	 *
	 */
	public class HttpServiceCall implements IServiceCall {
		static public const logger:ILogger = getLogger(HttpServiceCall);
		
		static public function decodeUtf8(bytes:ByteArray):* {
			bytes.position = 0;
			return bytes.readMultiByte(bytes.length, "utf-8");
		}
		
		static public var debugPrint:Function;

		private var _successCall:Function;

		private var _failedCall:Function;

		private var _stream:URLStream;
		
		private var _request:URLRequest;
		
		private var _decoder:Function;
		
		public function HttpServiceCall(decoder:Function, successCall:Function, failedCall:Function, url:String, urlVariables:Object = null, method:String = URLRequestMethod.POST, heads:Array = null) {
			_decoder = decoder;
			_successCall = successCall;
			_failedCall = failedCall;
			_request = new URLRequest(url);
			if (urlVariables) {
				var vars:URLVariables = new URLVariables();
				for (var key:String in urlVariables) {
					vars[key] = urlVariables[key];
				}
				_request.data = vars;
			}
			_request.method = method;
			if (heads)
				_request.requestHeaders = heads;
			/*var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.load(_request);
			loader.addEventListener(Event.COMPLETE, _handleLoaderEvent);
			function _handleLoaderEvent(event:Event):void {
				var p:Object = JSON.parse(loader.data);
				trace("f");
			}
			return;*/
			_stream = new URLStream();
			_stream.addEventListener(Event.CLOSE, _handleStreamEvent);
			_stream.addEventListener(IOErrorEvent.IO_ERROR, _handleStreamEvent);
			_stream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _handleStreamEvent);
			_stream.addEventListener(ProgressEvent.PROGRESS, _handleStreamEvent);
			_stream.addEventListener(HTTPStatusEvent.HTTP_STATUS, _handleStreamEvent);
			_stream.addEventListener(Event.COMPLETE, _handleStreamEvent);
			_stream.load(_request);
			if (logger.debugEnabled) {
				logger.debug("[{0}>>]{1}{2}", [_request.method, _request.url, JSON.stringify(urlVariables)]);
			}
		}

		protected function _handleStreamEvent(event:Event):void {
			var stream:URLStream = event.target as URLStream;
			switch (event.type) {
				case Event.CLOSE:
				case IOErrorEvent.IO_ERROR:
				case SecurityErrorEvent.SECURITY_ERROR:
					_failedCall(event);
					close();
					break;
				case ProgressEvent.PROGRESS:
				case HTTPStatusEvent.HTTP_STATUS:
					break;
				case Event.COMPLETE:
					var bytes:ByteArray = new ByteArray();
					_stream.readBytes(bytes, 0, _stream.bytesAvailable);
					if (logger.debugEnabled && debugPrint != null) {
						logger.debug("[{0}<<]{1}{2}\n{3}", [_request.method, _request.url, JSON.stringify(_request.data), debugPrint(bytes)]);
					}
					if (_successCall != null) {
						_successCall(_decoder(bytes));
					}
					close();
					break;
			}
		}

		public function close():void {
			_stream.removeEventListener(Event.CLOSE, _handleStreamEvent);
			_stream.removeEventListener(IOErrorEvent.IO_ERROR, _handleStreamEvent);
			_stream.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _handleStreamEvent);
			_stream.removeEventListener(ProgressEvent.PROGRESS, _handleStreamEvent);
			_stream.removeEventListener(HTTPStatusEvent.HTTP_STATUS, _handleStreamEvent);
			_stream.removeEventListener(Event.COMPLETE, _handleStreamEvent);
		}
	}
}
