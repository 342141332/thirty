package com.gearbrother.sheepwolf.model {
	import com.gearbrother.sheepwolf.rpc.protocol.bussiness.ApplicationProtocol;
	
	import flash.system.System;
	import flash.utils.getTimer;


	/**
	 * @author lifeng
	 * @create on 2013-12-11
	 */
	public class ApplicationModel extends ApplicationProtocol {
		public var _lastSetTimeMilliseconds:int;
		
		//TODO
		/*override public function set syntime(newValue:Number):void {
			super.syntime = newValue;
			
			_lastSetTimeMilliseconds = getTimer();
		}*/
		
		public function get serverTime():Number {
			var c:Number = syntime + getTimer() - _lastSetTimeMilliseconds;
			return c;
		}
		
		public function ApplicationModel(properties:Object = null) {
			super(properties);
		}
	}
}
