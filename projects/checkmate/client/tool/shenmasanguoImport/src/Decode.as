package {
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.loadingtypes.BinaryItem;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.utils.ByteArray;

	/**
	 *
	 * @author 	Neo.Zhang
	 * @create 	2014-9-15 下午3:31:05
	 * http://app22804.static.kingnet.com/config/plot/background_3k6rg19.dat
	 * http://app22804.static.kingnet.com/config/hero/hero081_10gsr6e.dat
	 *
	 */
	public class Decode extends Sprite{
		[Embed(source="main.swf", mimeType="application/octet-stream")]
		public var clazz:Class;
		
		public function Decode() {
			Resource.localRoot = "D:/neo/mine/shenmasanguo/";
			BulkLoader.SOUND_EXTENSIONS = [];
			BulkLoader.registerNewType(".mp3", ".mp3", BinaryItem);
			BulkLoader.registerNewType(".dat", "dat", BinaryItem);
			Resource.loader.start(5);
			Resource.loader.logLevel = BulkLoader.LOG_INFO;
			Resource.loader.addEventListener(ErrorEvent.ERROR, _handleError);
			var loader:Loader = new Loader();
			var loaderContext:LoaderContext = new LoaderContext();
			loaderContext.allowCodeImport = true;
			loader.loadBytes(new clazz(), loaderContext);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _handleComplete);
		}
		
		private function _handleError(event:ErrorEvent):void {
			trace(event);
		}
		
		private function _handleComplete(event:Event):void {
			var loader:LoaderInfo = event.target as LoaderInfo;
			var ar:* = loader.applicationDomain.getDefinition("com.kingnet.common.models.AbstractResourceModel");
			var clazz:* = new ar(null);
			Resource.decode = ar["method"];
			new Resource("config.dat", "oevocb")
		}
	}
}
