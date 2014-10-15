package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;


	/**
	 * 
	 * @author feng.lee
	 * create on 2012-5-17 下午6:50:30
	 */
	[SWF(frameRate="24")]
	public class GAvmTimerCase extends Sprite {
		public function GAvmTimerCase() {
			super();
			
			new Clock("A");
			new Clock("B");
			new Clock("C");
			new Clock("D");
			new Clock("E");
			new Clock("F");
			new Clock("G");
		}
	}
}
import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Timer;
import flash.utils.getTimer;

class Clock {
	private var __id:String;
	public function Clock(id:String) {
		__id = id;
		
		var timer:Timer = new Timer(0, int.MAX_VALUE);
		timer.addEventListener(TimerEvent.TIMER, __onTimer);
		timer.start();
	}
	
	private var _elapse:int = 0;
	private var _delay:int = 0;
	
	private function __onTimer(e:Event):void {
		var prevTime:int = getTimer();
		while (getTimer() - prevTime < 10) {
			
		}
		var __thisTime:int = getTimer();
		_delay = __thisTime - _elapse;
		trace(__id, ' _elapse:', _elapse, ',_delay:', _delay, ',getTimer:', getTimer());
		_elapse = __thisTime;
	}
}