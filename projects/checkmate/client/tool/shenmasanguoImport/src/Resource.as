package
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.loadingtypes.BinaryItem;
	import br.com.stimuli.loading.loadingtypes.ImageItem;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	
	import com.adobe.utils.StringUtil;
	
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	
	/**
	 *
	 * @author 	Neo.Zhang
	 * @create 	2014-9-17 下午2:42:51
	 *
	 */
	public class Resource {
		public static function writeFile(file:File, bytes:ByteArray):void {
			file.parent.createDirectory();
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeBytes(bytes);
			stream.close();
		}
		
		public static const ALL:Object = {};
		
		public static const loader:BulkLoader = new BulkLoader("22");
		
		public static var decode:Object;
		
		public static var localRoot:String;
		
		public var parent:Resource;
		
		public var children:Vector.<Resource>;
		
		public var remoteUrl:String;
		
		public var orginalPath:String;
		
		public var path:String;
		
		public var item:LoadingItem;
		
		public var content:*;
		
		public function Resource(path:String, version:String, parent:Resource = null) {
			ALL[path] = this;
			orginalPath = path;
			var dotAt:int = path.lastIndexOf(".");
			path = path.slice(0, dotAt) + "_" + version + path.slice(dotAt, path.length);
			if (StringUtil.endsWith(path, ".xml")) {
				path = path.slice(0, path.length - ".xml".length) + ".dat";
			}
			this.remoteUrl = "http://app22804.static.kingnet.com/" + path;
			this.path = path;
			this.parent = parent;
			var item:LoadingItem = loader.add(new URLRequest(remoteUrl));
			item.addEventListener(Event.COMPLETE, _handleLoaderEvent);
			this.item = item;
			//		if (url.indexOf("config/hero_v") > -1)
			//			trace();
		}
		
		private function _handleLoaderEvent(event:Event):void {
			var item:LoadingItem = event.target as LoadingItem;
			var file:File = new File(localRoot + this.orginalPath);
			file.parent.createDirectory();
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			if (StringUtil.endsWith(this.path, ".dat")) {
				var bytes:ByteArray = item.content;
				var d:* = decode.divdi4(bytes);
				bytes.uncompress();
				var utf:String = bytes.readUTFBytes(bytes.bytesAvailable);
				children = new Vector.<Resource>();
				if (utf.charAt(0) == "<") {
					var content:XML = new XML(utf);
					this.content = content;
					stream.writeMultiByte(content.toString(), "utf-8");
					for each (var fileXml:XML in content.file) {
						childrenPath = fileXml.@url;
						var version:String = fileXml.@v;
						children.push(new Resource(childrenPath, version, this));
					}
					for each (fileXml in content.s) {
						var childrenPath:String = fileXml.valueOf();
						version = fileXml.@v;
						children.push(new Resource(childrenPath, version, this));
					}
				} else {
					var obj:Object = JSON.parse(utf);
					this.content = obj;
					stream.writeMultiByte(JSON.stringify(obj, null, "\t"), "utf-8");
					if (path.indexOf("hero_v") > -1) {
						for each (var heroFile:String in obj) {
							var spliterAt:int = heroFile.indexOf("|");
							children.push(new Resource("config/hero/" + heroFile.slice(0, spliterAt), heroFile.slice(spliterAt + 1, heroFile.length), this));
						}
					}
				}
			} else if (StringUtil.endsWith(this.path, ".swf")) {
				stream.writeBytes((item as ImageItem).loader.contentLoaderInfo.bytes);
			} else {
				stream.writeBytes((item as BinaryItem).loader.data);
			}
			stream.close();
			
			for each (var config:Resource in ALL) {
				if (!config.item.status)
					return;
			}
			new AnalyzeAvatar();
		}
	}
}