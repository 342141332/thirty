package br.com.stimuli.loading.loadingtypes {
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;


	/**
	 *
	 * @author 	Neo.Zhang
	 * @create 	2014-9-12 上午11:19:27
	 *
	 */
	public class TextItem extends BinaryItem {
		public function TextItem(url:URLRequest, type:String, uid:String) {
			super(url, type, uid);
		}
		
		override public function onCompleteHandler(evt:Event):void {
			super.onCompleteHandler(evt);
			
			var bytes:ByteArray = loader.data;
			_content = bytes.readMultiByte(bytes.length, "utf-8");
		}
	}
}
