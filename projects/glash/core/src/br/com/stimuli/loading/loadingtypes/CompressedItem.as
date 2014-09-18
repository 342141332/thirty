package br.com.stimuli.loading.loadingtypes {
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;

	public class CompressedItem extends LoadingItem {
		public var loader:URLLoader;

		public function CompressedItem(url:URLRequest, type:String, uid:String) {
			super(url, type, uid);
		}

		override public function _parseOptions(props:Object):Array {
			return super._parseOptions(props);
		}

		override public function load():void {
			super.load();
			loader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(ProgressEvent.PROGRESS, onProgressHandler, false, 0, true);
			loader.addEventListener(Event.COMPLETE, onCompleteHandler, false, 0, true);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false, 0, true);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, super.onHttpStatusHandler, false, 0, true);
			loader.addEventListener(Event.OPEN, onStartedHandler, false, 0, true);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, super.onSecurityErrorHandler, false, 0, true);
			try {
				// TODO: test for security error thown.
				loader.load(url);
			} catch (e:SecurityError) {
				onSecurityErrorHandler(_createErrorEvent(e));

			}
		}

		override public function onErrorHandler(evt:ErrorEvent):void {
			super.onErrorHandler(evt);
		}

		override public function onStartedHandler(evt:Event):void {
			super.onStartedHandler(evt);
		}

		override public function onCompleteHandler(evt:Event):void {
			var bytes:ByteArray = evt.target.data;
			bytes.uncompress();
			_content = bytes.readObject();
			super.onCompleteHandler(evt);
		}

		override public function stop():void {
			try {
				if (loader) {
					loader.close();
				}
			} catch (e:Error) {

			}
			super.stop();
		}

		override public function cleanListeners():void {
			if (loader) {
				loader.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler, false);
				loader.removeEventListener(Event.COMPLETE, onCompleteHandler, false);
				loader.removeEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false);
				loader.removeEventListener(BulkLoader.OPEN, onStartedHandler, false);
				loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, super.onHttpStatusHandler, false);
				loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, super.onSecurityErrorHandler, false);
			}
		}

		override public function destroy():void {
			stop();
			cleanListeners();
			_content = null;
			loader = null;
		}
	}
}
