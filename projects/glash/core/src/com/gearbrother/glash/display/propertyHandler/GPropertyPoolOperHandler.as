package com.gearbrother.glash.display.propertyHandler {
	import com.gearbrother.glash.GMain;
	import com.gearbrother.glash.common.oper.GOper;
	import com.gearbrother.glash.common.oper.GOperEvent;
	import com.gearbrother.glash.common.oper.GOperPool;
	import com.gearbrother.glash.common.oper.GQueue;
	import com.gearbrother.glash.common.utils.GClassFactory;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.Dictionary;

	public class GPropertyPoolOperHandler extends GPropertyHandler {
		public var succHandler:Function;

		public var processHandler:Function;

		private var _caches:Dictionary;
		public function get cachedOper():Dictionary {
			return _caches;
		}

		protected var pool:GOperPool;
		
		private var _processListener:GPropertyPoolOperProcessingListener;

		public function GPropertyPoolOperHandler(processListener:GPropertyPoolOperProcessingListener, propertyOwner:DisplayObject, isValidateLater:Boolean = false) {
			super(propertyOwner, isValidateLater);

			_processListener = processListener;
			this.pool = GOperPool.instance;
			_caches = new Dictionary();
		}
		
		override public function set value(newValue:*):void {
			if (newValue is Array) {
				super.value = newValue;
			} else if (newValue == null) {
				super.value = null;
			} else {
				throw new Error("only accept Array or Null.");
			}
		}

		override protected function doValidate():void {
			_cleanOpers();
			for each (var key:* in value) {
				var newOper:GOper = key as GOper;
				var cachedOper:GOper = _caches[newOper] = pool.getInstance(newOper);
				if (cachedOper.state != GOper.STATE_END) {
					cachedOper.addEventListener(GOperEvent.OPERATION_COMPLETE, _handleOperEvent);
					if (_processListener)
						_processListener.addOper(newOper);
				}
			}
			_handleOperEvent();
		}
		
		private function _cleanOpers():void {
			for (var key:* in _caches) {
				var cachedOper:GOper = _caches[key];
				cachedOper.removeEventListener(GOperEvent.OPERATION_COMPLETE, _handleOperEvent);
				pool.returnInstance(cachedOper);
				if (_processListener)
					_processListener.removeOper(cachedOper);
				delete _caches[key];
			}
		}
		
		private function _handleOperEvent(event:Event = null):void {
			for (var key:* in _caches) {
				var cache:GOper = _caches[key];
				if (cache.state != GOper.STATE_END) {
					if (processHandler != null)
						processHandler(this);
					return;
				}
			}
			succHandler(this);
		}

		override public function dispose():void {
			_cleanOpers();
		}
	}
}
