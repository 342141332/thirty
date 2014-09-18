package {
	import com.gearbrother.glash.GMain;
	import com.gearbrother.glash.util.lang.UUID;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;


	/**
	 * @author neozhang
	 * @create on Nov 4, 2013
	 */
	public class GAvmEventDispatcherCase extends GMain {
		private var _timer:Timer;
		
		private var _dispatcher:EventDispatcher;
		
		public function GAvmEventDispatcherCase(id:String = null) {
			super(id);
			
			_timer = new Timer(100);
			_timer.addEventListener(TimerEvent.TIMER, _handleTimerEvent);
			_timer.start();
			_dispatcher = new EventDispatcher();
		}
		
		private function _handleTimerEvent(event:TimerEvent):void {
			for (var i:int = 0; i < 1000; i++) {
				var uuid:String = UUID.getUUID();
				_dispatcher.addEventListener(uuid, _handleEvent);
				_dispatcher.dispatchEvent(new Event(uuid));
			}
		}
		
		private function _handleEvent(event:Event):void {
			_dispatcher.removeEventListener(event.type, _handleEvent);
			logger.debug(event.type);
		}
	}
}
