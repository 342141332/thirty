package {
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.display.BitmapData;
	import flash.events.Event;

	/**
	 * 测试在CPU高负载的时候Timer与EnterFrame的间隔
	 */
	[SWF(frameRate = 2)]
	public class GAvmRunCase extends Sprite {

		public function GAvmRunCase() {
			_timer = new Timer(50);
			_timer.addEventListener(TimerEvent.TIMER, handler_timer);
			_timer.start();
			this.stage.addEventListener(MouseEvent.CLICK, handler_click);
			this.stage.addEventListener(Event.ENTER_FRAME, handler_enterFrame);
		}

		private var _timer:Timer;
		private var _elapse:int = 0;
		private var _delay:int = 0;

		public function updateTime():void {
			var __thisTime:int = getTimer();
			_delay = __thisTime - _elapse;
			trace('_elapse:', _elapse, ',_delay:', _delay, ',getTimer:', getTimer());
			_elapse = __thisTime;
		}

		public function handler_timer($evt:TimerEvent):void {
			updateTime();
		}

		public function handler_enterFrame($evt:Event):void {
			updateTime();
		}

		public function handler_click($evt:MouseEvent):void {
			trace('draw');
			for (var i:int = 0; i < 1000; i++) {
				var __aaa:BitmapData = new BitmapData(550, 400);
				__aaa.draw(this);
			}
		}
	}
}
