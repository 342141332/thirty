package {
	import flash.display.Sprite;


	/**
	 * @author neozhang
	 * @create on Aug 12, 2013
	 */
	public class GAvmEventTwiceCase extends Sprite {
		public function GAvmEventTwiceCase() {
			super();

			addChild(new Home());
		}
	}
}
import flash.display.Sprite;
import flash.events.Event;

class Home extends Sprite {
	public function Home() {
		trace("Home.Home()");
		//addChildren();
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}

	private var _videoPlayer:Player;

	private function onAddedToStage(event:Event):void {
		//removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		trace("Home addedToStage ");
		addChildren();
	}

	private function addChildren():void {
		trace("Home.addChildren(event)");
		_videoPlayer = new Player();
		this.addChild(_videoPlayer);
	}
}

class Player extends Sprite {
	public function Player() {
		trace("Player.Player() ");
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}

	private function onAddedToStage(event:Event):void {
		//removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		trace("Player ----addedToStage ");
	}
}
