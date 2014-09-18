package com.gearbrother.glash.display.control.text {
	import com.gearbrother.glash.display.GNoScale;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.ui.MouseCursorData;


	/**
	 * @author neozhang
	 * @create on May 3, 2013
	 */
	public class GLink extends GText {
		public function GLink(skin:TextField = null) {
			super(skin);
			
			addEventListener(MouseEvent.MOUSE_OVER, _handleMouseEvent);
			addEventListener(MouseEvent.MOUSE_OUT, _handleMouseEvent);
			addEventListener(MouseEvent.MOUSE_MOVE, _handleMouseEvent);
			addEventListener(MouseEvent.MOUSE_DOWN, _handleMouseEvent);
		}

		private var _defaultCursor:String; //Mouse.cursor;

		private function _handleMouseEvent(event:Event):void {
			var target:TextField = event.target as TextField;
			switch (event.type) {
				case MouseEvent.MOUSE_OVER:
					_defaultCursor = Mouse.cursor;
					Mouse.cursor = MouseCursor.BUTTON;
					break;
				case MouseEvent.MOUSE_OUT:
					Mouse.cursor = _defaultCursor;
					break;
				/*case MouseEvent.MOUSE_MOVE:
					var index:int = target.getCharIndexAtPoint(target.mouseX, target.mouseY);
					var hoverFormat:TextFormat = target.getTextFormat(index);
					if (hoverFormat.url)
						Mouse.cursor = MouseCursor.BUTTON;
					else
						Mouse.cursor = _defaultCursor;
					break;*/
			}
		}
	}
}
