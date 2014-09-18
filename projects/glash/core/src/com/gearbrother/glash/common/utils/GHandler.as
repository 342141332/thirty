package com.gearbrother.glash.common.utils {
	/**
	 * 
	 * @author feng.lee
	 * 
	 */
	public class GHandler {
		public var handler:Function;
		public var caller:*;
		public var params:Array;
		private var _toFunction:Function;

		public function GHandler(handler:Function, params:Array = null, caller:* = null) {
			this.handler = handler;
			this.params = params;
			this.caller = caller;
		}

		public function call(... params):* {
			var h:Function = handler;

			if (params && params.length > 0)
				return h.apply(caller, params);
			else
				return h.apply(caller, this.params);
		}

		public function toFunction():Function {
			if (_toFunction == null)
				_toFunction = function(... parameters):* {
					return call()
				};
			return _toFunction;
		}

		public function destory():void {
			_toFunction = null;
		}
	}
}