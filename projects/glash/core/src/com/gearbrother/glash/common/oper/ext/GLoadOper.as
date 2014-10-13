package com.gearbrother.glash.common.oper.ext {
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.loadingtypes.ImageItem;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	
	import com.gearbrother.glash.common.oper.GOper;
	import com.gearbrother.glash.common.oper.GQueue;
	
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;


	/**
	 * @author feng.lee
	 * create on 2012-7-4 下午2:26:19
	 */
	public class GLoadOper extends GOper {
		static public const logger:ILogger = getLogger(GLoadOper);

		static public const queue:GQueue = new GQueue(5);
		
		static public var _bulkloader:BulkLoader;
		static public function get bulkloader():BulkLoader {
			if (!_bulkloader) {
				var logLevel:int;
				if (logger.errorEnabled)
					logLevel = BulkLoader.LOG_ERRORS;
				if (logger.warnEnabled)
					logLevel = BulkLoader.LOG_WARNINGS;
				if (logger.infoEnabled)
					logLevel = BulkLoader.LOG_INFO;
				if (logger.debugEnabled)
					logLevel = BulkLoader.LOG_VERBOSE;
				_bulkloader = new BulkLoader("GAssetPool", 5/*numConnections*/, 0/*logLevel*/);
				_bulkloader.start();
			}
			return _bulkloader;
		}

		protected var _item:LoadingItem;

		public function get speed():Number {
			return _item ? BulkLoader.truncateNumber((_item.bytesLoaded / 1024) / (_item.startTime)) : 0;
		}
		
		override public function get progress():Number {
			return bytesLoaded / bytesTotal;
		}

		public function get bytesLoaded():int {
			return _item ? _item.bytesLoaded : 0;
		}

		public function get bytesTotal():int {
			return _item ? _item.bytesTotal : 0;
		}

		public function get content():* {
			if (state == GOper.STATE_END && resultType == GOper.RESULT_TYPE_SUCCESS) {
				return _item.content;
			} else {
				throw new Error("File is not loaded!");
			}
		}

		public function get nativeFrameRate():int {
			return (_item as ImageItem).loader.contentLoaderInfo.frameRate;
		}

		public function getDefinition(definitionName:String):Class {
			return (_item as ImageItem).getDefinitionByName(definitionName) as Class;
		}

		public function hasDefinition(definitionName:String):Boolean {
			return (_item as ImageItem).getDefinitionByName(definitionName) != null;
		}

		public function getInstance(definitionName:String):* {
			var clazz:Class = getDefinition(definitionName);
			return new clazz();
		}

		public function getBytes():ByteArray {
			return (_item as ImageItem).loader.contentLoaderInfo.bytes;
		}

		public function GLoadOper() {
			super(queue);
		}

		protected function _handleLoadEvent(event:Event):void {
			_item.removeEventListener(Event.COMPLETE, _handleLoadEvent);
			_item.removeEventListener(BulkLoader.ERROR, _handleLoadEvent);
			switch (event.type) {
				case Event.COMPLETE:
					notifyResult(_item.content);
					break;
				case BulkLoader.ERROR:
					logger.error("can't load {0}", [_item.url.url]);
					notifyFault(event);
					break;
			}
		}
		
		override public function dispose():void {
			_item.removeEventListener(Event.COMPLETE, _handleLoadEvent);
			_item.removeEventListener(BulkLoader.ERROR, _handleLoadEvent);
		}
	}
}
