package com.gearbrother.glash.common.oper.ext {
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.loadingtypes.BinaryItem;
	import br.com.stimuli.loading.loadingtypes.CompressedItem;
	import br.com.stimuli.loading.loadingtypes.JSONItem;
	import br.com.stimuli.loading.loadingtypes.LanguageItem;
	
	import com.adobe.net.URI;
	import com.gearbrother.glash.GMain;
	import com.gearbrother.glash.common.collections.IGObject;
	import com.gearbrother.glash.common.oper.GQueue;
	import com.gearbrother.glash.manager.browser.BrowerManager;
	
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.utils.getQualifiedClassName;
	
	import org.as3commons.lang.StringUtils;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;

	/**
	 * @author feng.lee
	 * create on 2012-9-11 下午7:38:29
	 */
	public class GFile extends GLoadOper implements IGObject {
		static public const logger:ILogger = getLogger(GFile);
		{
			BulkLoader.registerNewType(".json", "json", JSONItem);
			BulkLoader.registerNewType(".csv", "csv", BinaryItem);
			BulkLoader.registerNewType(".db", "db", CompressedItem);
			BulkLoader.registerNewType(".pak", "pak", BinaryItem);
			BulkLoader.registerNewType(".lang", "lang", LanguageItem);
		}

		static public const TYPE_BINARY:String = BulkLoader.TYPE_BINARY;
		static public const TYPE_IMAGE:String = BulkLoader.TYPE_IMAGE;
		static public const TYPE_MOVIECLIP:String = BulkLoader.TYPE_MOVIECLIP;
		static public const TYPE_SOUND:String = BulkLoader.TYPE_SOUND;
		static public const TYPE_TEXT:String = BulkLoader.TYPE_TEXT;
		static public const TYPE_XML:String = BulkLoader.TYPE_XML;
		static public const TYPE_VIDEO:String = BulkLoader.TYPE_VIDEO;

		private var _type:String;
		public function get type():String {
//			if (_type)
				return _type;
//			else
//				return BulkLoader.guessType(fullPath);
		}

		private var _src:String;
		public function get src():String {
			return _src;
		}
		
		public function get url():URLRequest {
			return new URLRequest(_src);
		}

		public function GFile(src:String, type:String) {
			super();

			_src = src;
			_type = type;
		}
		
		override public function execute():void {
			super.execute();

			var props:Object = {id: src};
			if (type)
				props.type = type;
			_item = bulkloader.add(src, props);
			if (_item.isLoaded)
				notifyResult(_item.content);
			else {
				_item.addEventListener(Event.COMPLETE, _handleLoadEvent);
				_item.addEventListener(BulkLoader.ERROR, _handleLoadEvent);
			}
		}

		public function equals(o:Object):Boolean {
			var other:GFile = o as GFile;
			if (other)
				return other.type == type && other.src == src;
			else
				return false;
		}

		public function hashCode():Object {
			return this.src;
		}
		
		override public function dispose():void {
			bulkloader.remove(src);

			super.dispose();
		}
		
		override public function toString():String {
			return "[" + getQualifiedClassName(GFile) + ", fullPath = " + src + "]";
		}
	}
}
