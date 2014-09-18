package {
	import com.gearbrother.glash.GMain;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;


	/**
	 * @author 		lifeng
	 * @E-mail		streetpoet.p@gmail.com
	 * @version 	1.0.0
	 * create on	2012-12-1 下午11:02:18
	 **/
	public class GAvmEventCase extends GMain {
		private var _parent:Sprite = new Sprite();
		private var _child:Sprite = new Sprite();

		public function GAvmEventCase() {
			super();
			
			_parent.name = "_parent";
			_parent.addEventListener(Event.ADDED, _handleEvent);
			_parent.addEventListener(Event.ADDED_TO_STAGE, _handleEvent);
			_parent.addEventListener(Event.REMOVED, _handleEvent);
			_parent.addEventListener(Event.REMOVED_FROM_STAGE, _handleEvent);
			_child.name = "_child";
			_child.addEventListener(Event.ADDED, _handleEvent);
			_child.addEventListener(Event.ADDED_TO_STAGE, _handleEvent);
			_child.addEventListener(Event.REMOVED, _handleEvent);
			_child.addEventListener(Event.REMOVED_FROM_STAGE, _handleEvent);
			_parent.addChild(_child);
			trace("------------------------------");
			stage.addChild(_parent);
			stage.addEventListener(MouseEvent.CLICK, _handleEvent);
		}
		
		private function _handleEvent(event:Event):void {
			switch (event.type) {
				case MouseEvent.CLICK:
//					_child.parent.removeChild(_child);
					_parent.parent.removeChild(_parent);
					break;
			}
			trace(event, event.target.name, event.currentTarget.name);
		}
	}
}