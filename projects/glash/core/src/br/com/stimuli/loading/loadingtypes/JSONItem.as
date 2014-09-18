package br.com.stimuli.loading.loadingtypes {

	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;

	/** @private */
	public class JSONItem extends BinaryItem {
		public function JSONItem(url:URLRequest, type:String, uid:String) {
			super(url, type, uid);
		}
		
		override public function onCompleteHandler(evt:Event):void {
			super.onCompleteHandler(evt);
			
			var bytes:ByteArray = loader.data;
			_content = JSON.parse(bytes.readMultiByte(bytes.length, "utf-8"));
		}
	}
}
