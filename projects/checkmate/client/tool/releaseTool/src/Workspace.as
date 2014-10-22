package {
	import com.gearbrother.glash.common.oper.GQueue;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;

	public class Workspace {
		public var sourcePath:String;
		
		public var outputPath:String;

		public function Workspace(proto:Object) {
			if (proto) {
				this.sourcePath = proto.sourcePath;
				this.outputPath = proto.outputPath;
			}
		}
		
		public function process():void {
			new FileOper(sourcePath, "", outputPath).commit(FileOper.queue);
		}
	}
}
import com.gearbrother.glash.codec.zip.CRC32;
import com.gearbrother.glash.common.oper.GOper;
import com.gearbrother.glash.common.oper.GQueue;

import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.net.URLRequest;

import org.as3commons.logging.api.ILogger;
import org.as3commons.logging.api.getLogger;

class FileOper extends GOper {
	static public const logger:ILogger = getLogger(FileOper);
	
	static public const acceptExtensions:Array = ["json", "txt", "jpg", "png", "swf"];
	
	static public const crc32:CRC32 = new CRC32();
	
	static public const queue:GQueue = new GQueue();
	
	public var sourcePrefix:String;
	
	public var relativePath:String;
	
	private var file:File;
	
	public var outputPrefix:String;
	
	public function FileOper(sourcePrefix:String, relativePath:String, outputPrefix:String) {
		super();

		this.sourcePrefix = sourcePrefix;
		this.relativePath = relativePath;
		this.file = new File(sourcePrefix + relativePath);
		this.outputPrefix = outputPrefix;
	}
	
	override public function execute():void {
		super.execute();

		logger.info("get {}", file.url);
		if (file.isDirectory) {
			var children:Array = file.getDirectoryListing();
			for each (var child:File in children) {
				if (child.isDirectory || acceptExtensions.indexOf(child.extension) > -1)
					new FileOper(sourcePrefix, child.url.substring(sourcePrefix.length, child.url.length), outputPrefix).commit(FileOper.queue);
				else
					logger.info("ignore {}", file.url);
			}
			notifyResult();
		} else {
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _handleLoaderEvent);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _handleLoaderEvent);
			loader.load(new URLRequest(file.url));
		}
	}

	private function _handleLoaderEvent(event:Event):void {
		switch (event.type) {
			case Event.COMPLETE:
				var loaderInfo:LoaderInfo = event.target as LoaderInfo;
				switch (file.extension.toLowerCase()) {
					//json
					case "json":
						break;
					case "txt":
						break;
					//image
					case "jpg":
					case "png":
						break;
					//swf
					case "swf":
						var stage:MovieClip = loaderInfo.content as MovieClip;
						if (stage.numChildren > 0)
							logger.warn("{} has some displayobject in stage. please remove it to avoid cpu.", file.parent);
						break;
				}
				crc32.reset();
				crc32.update(loaderInfo.bytes);
				var openStream:FileStream = new FileStream();
				var bakFile:File = new File(outputPrefix + "/" + relativePath.substring(0, relativePath.length - file.name.length) + file.name.substring(0, file.name.length - file.extension.length - ".".length) + "_" + crc32.getValue().toString(16) + "." + file.extension);
				logger.info("out {0}", bakFile.url);
				bakFile.parent.createDirectory();
				openStream.open(bakFile, FileMode.WRITE);
				openStream.writeBytes(loaderInfo.bytes);
				openStream.close();
				notifyResult();
				break;
			case IOErrorEvent.IO_ERROR:
				break;
		}
	}
}