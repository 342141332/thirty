package {
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	import com.gearbrother.glash.GMain;


	/**
	 * @author feng.lee
	 * create on 2012-7-21 下午2:50:17
	 */
	public class GAvmEventSequenceCase extends GMain {
		public var loader:Loader;

		public function GAvmEventSequenceCase() {
			super();

			stage.frameRate = 2;
			stage.addEventListener(Event.ENTER_FRAME, handleEvent);
			stage.addEventListener(Event.RENDER, handleEvent);
			stage.addEventListener(MouseEvent.CLICK, handleEvent);

			var timer:Timer = new Timer(1);
			timer.start();
			timer.addEventListener(TimerEvent.TIMER, handleEvent);
		}

		private function handleEvent(event:Event):void {
			logger.debug(event);

			if (event.type == MouseEvent.CLICK) {
				loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleLoadEvent);
				loader.load(new URLRequest("http://pic.kaixin001.com.cn/pic/app/2/9/1088_166020996_repaste-news.jpeg?v=" + Math.random()));
				stage.invalidate();
			}
		}

		private function handleLoadEvent(event:Event):void {
			logger.debug(event);
		}
	}
}
