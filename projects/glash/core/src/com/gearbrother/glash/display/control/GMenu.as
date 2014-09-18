package com.gearbrother.glash.display.control {
	import com.gearbrother.glash.display.GSkinSprite;
	import com.gearbrother.glash.display.GNoScale;

	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;


	/**
	 * @author feng.lee
	 * @create on 2013-5-6
	 */
	public class GMenu extends GSkinSprite {

		public function GMenu(skin:DisplayObject = null) {
			super(skin);
		}

		override protected function doInit():void {
			super.doInit();

			stage.addEventListener(MouseEvent.MOUSE_DOWN, _handleStageEvent);
		}

		private function _handleStageEvent(event:Event):void {
			remove();
		}

		override protected function doDispose():void {
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, _handleStageEvent);

			super.doDispose();
		}
	}
}
