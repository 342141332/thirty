package com.gearbrother.glash.common.oper {
	import com.gearbrother.glash.common.collections.HashMap;
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;

	/**
	 * @author feng.lee
	 * create on 2012-9-10 下午5:37:39
	 */
	public class GOperPool {
		static public const logger:ILogger = getLogger(GOperPool);
		
		static public const instance:GOperPool = new GOperPool();
		
		public var remainMilliseconds:int;

		protected var _keyToRecord:HashMap;

		public function GOperPool(remainMilliseconds:int = 7700) {
			if (instance)
				throw new Error("call instance.");

			this.remainMilliseconds = remainMilliseconds;
			_keyToRecord = new HashMap;
		}

		public function getInstance(oper:GOper):GOper {
			var record:GPoolRecord = _keyToRecord.grab(oper);
			if (record) {
				record.referenceNum++;
				record.lastActiveTime = getTimer();
			} else {
				//TODO should clone key
				record = new GPoolRecord(oper);
				_keyToRecord.put(oper, record);
				record.key = oper;
				record.lastActiveTime = getTimer();
				record.referenceNum++;
				oper.commit();
			}
			return record.key;
		}

		//TODO If some BmpCacheOper is not started when record is zero already, It's better to kill the Oper to avoid unneccessary CPU
		public function returnInstance(key:GOper):int {
			var item:GPoolRecord = _keyToRecord.grab(key);
			item.referenceNum--;
			if (item.referenceNum < 0) {
				if (logger.debugEnabled)
					throw new Error("ilegal reference value!");
				logger.error("ilegal reference value!");
			}
			item.lastActiveTime = getTimer();
			return item.referenceNum;
		}

		public function clean(force:Boolean = false):void {
			var now:int = getTimer();
			var keys:Array = _keyToRecord.keys();
			for each (var factory:* in keys) {
				var record:GPoolRecord = _keyToRecord.grab(factory);
				if (force == false) {
					if (now - record.lastActiveTime < remainMilliseconds) {
						continue;
					}
				}
				if (record.referenceNum == 0) {
					record.key.dispose();
					_keyToRecord.remove(factory);
				} else if (record.referenceNum < 0)
					throw new Error("ilegal reference value!");
			}
		}
	}
}
import com.gearbrother.glash.common.oper.GOper;
import com.gearbrother.glash.common.utils.GClassFactory;

import org.as3commons.lang.IDisposable;

/**
 * @author feng.lee
 * create on 2012-10-31 下午1:53:33
 */
class GPoolRecord {
	public var key:GOper;
	
	public var referenceNum:int;
	
	public var lastActiveTime:int;
	
	public function get isDisposed():Boolean {
		return false;
	}
	
	public function GPoolRecord(key:GOper) {
		this.key = key;
	}
}