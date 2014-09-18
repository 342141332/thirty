package com.gearbrother.glash.display.mouseMode {
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;


	/**
	 * 点击连续触发, 如滚动条的导向按钮
	 * @author feng.lee
	 * create on 2012-12-29
	 */
	public class GIncessancyClick extends GMouseMode {
		/**
		 * 连续点击的延迟响应时间
		 */
		public var incessancyDelay:int = 500;

		/**
		 * 连续点击的响应间隔
		 */
		public var incessancyInterval:int = 100;

		private var mouseDownTimer:Timer;

		private var mouseDownDelayTimer:int;

		private var _mouseDown:Boolean;

		public function GIncessancyClick(dispatcher:InteractiveObject, applyNow:Boolean = true) {
			super(dispatcher, applyNow);

			dispatcher.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			dispatcher.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			dispatcher.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
		}

		public function mouseDown(e:MouseEvent):void {
			_mouseDown = true;
			mouseDownDelayTimer = setTimeout(enabledIncessancyHandler, incessancyDelay);
			_trigger.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp, false, 0, true);
		}

		public function mouseOver(e:MouseEvent):void {
			if (_mouseDown)
				enabledIncessancy = true;
		}

		public function mouseOut(e:MouseEvent):void {
			if (_mouseDown)
				enabledIncessancy = false;
		}

		public function mouseUp(e:MouseEvent):void {
			_mouseDown = enabledIncessancy = false;

			_trigger.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}

		private function enabledIncessancyHandler():void {
			enabledIncessancy = true;
		}

		//激活连续点击
		private function set enabledIncessancy(value:Boolean):void {
			if (mouseDownTimer) {
				mouseDownTimer.stop();
				mouseDownTimer.removeEventListener(TimerEvent.TIMER, incessancyHandler);
				mouseDownTimer = null;
			}
			if (value) {
				mouseDownTimer = new Timer(incessancyInterval, int.MAX_VALUE);
				mouseDownTimer.addEventListener(TimerEvent.TIMER, incessancyHandler);
				mouseDownTimer.start();
			} else {
				clearTimeout(mouseDownDelayTimer);
			}
		}

		/**
		 * 连续点击事件
		 * @param event
		 *
		 */
		protected function incessancyHandler(event:TimerEvent):void {
			_trigger.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
	}
}
