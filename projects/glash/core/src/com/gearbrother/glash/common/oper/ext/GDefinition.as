package com.gearbrother.glash.common.oper.ext {
	import com.gearbrother.glash.GMain;
	import com.gearbrother.glash.common.collections.IGObject;
	import com.gearbrother.glash.common.oper.GOper;
	import com.gearbrother.glash.common.oper.GOperEvent;
	import com.gearbrother.glash.common.oper.GOperPool;
	import com.gearbrother.glash.common.oper.GQueue;
	
	import flash.display.BitmapData;



	/**
	 * @author feng.lee
	 * create on 2012-9-7 下午5:25:00
	 */
	public class GDefinition extends GOper implements IGObject {
		static public const queue:GQueue = new GQueue(-1);
		
		private var file:GFile;

		private var generator:String;

		private var _instance:BitmapData;

		private var properties:Object;

		private var params:Array;

		override public function get result():* {
			if (file.resultType == GOper.RESULT_TYPE_SUCCESS) {
				var b:Boolean = file.hasDefinition(generator);
				var clazz:Class = file.getDefinition(generator);
				if (_instance)
					return _instance;
				var instance:* = new clazz();
				for (var propertyKey:String in properties) {
					instance[propertyKey] = properties[propertyKey];
				}
				if (instance is BitmapData) {
					return _instance = instance;
				} else {
					return instance;
				}
			} else if (file.resultType == GOper.RESULT_TYPE_ERROR) {
				return file.result;
			}
		}

		public function GDefinition(file:GFile, generator:* = null, params:Array = null, properties:Object = null) {
			super(queue);
			
			this.file = file;
			this.generator = generator;
			this.params = params;
			this.properties = properties;
		}

		override public function execute():void {
			super.execute();

			file = GOperPool.instance.getInstance(file) as GFile;
			if (file.state == GOper.STATE_END)
				_handleFileEvent();
			else
				file.addEventListener(GOperEvent.OPERATION_COMPLETE, _handleFileEvent);
		}

		private function _handleFileEvent(event:GOperEvent = null):void {
			file.removeEventListener(GOperEvent.OPERATION_COMPLETE, _handleFileEvent);
			if (file.resultType == GOper.RESULT_TYPE_SUCCESS) {
				notifyResult();
			} else {
				notifyFault();
			}
		}

		public function equals(o:Object):Boolean {
			if (o is GDefinition) {
				var other:GDefinition = o as GDefinition;
				return file.equals(other.file) && generator == other.generator;
			} else {
				return false;
			}
		}

		public function hashCode():Object {
			return file.hashCode() + "#" + generator;
		}

		override public function dispose():void {
			GOperPool.instance.returnInstance(file);
			if (_instance)
				_instance.dispose();

			super.dispose();
		}
	}
}
