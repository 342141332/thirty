package com.gearbrother.glash.display.layer {
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.GSkinSprite;
	import com.gearbrother.glash.display.GSprite;
	import com.gearbrother.glash.display.IGCursorable;
	import com.gearbrother.glash.display.IGDisplay;
	import com.gearbrother.glash.display.filter.GFilter;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;


	/**
	 * Player 版本:
	 * Flash 10.2, AIR 2.6
	 * @author feng.lee
	 * create on 2012-10-17 下午10:01:01
	 */
	public class GCursorLayer extends GNoScale {
		private var _cursor:String;
		
		public function GCursorLayer() {
			super();

			mouseEnabled = mouseChildren = false;
		}

		override protected function doInit():void {
			stage.addEventListener(MouseEvent.MOUSE_OVER, _handleMouseEvent);
			stage.addEventListener(MouseEvent.MOUSE_OUT, _handleMouseEvent);
		}

		private function _handleMouseEvent(event:MouseEvent):void {
			switch (event.type) {
				case MouseEvent.MOUSE_OVER:
					if (event.target is IGCursorable) {
						var cursorable:IGCursorable = event.target as IGCursorable;
						if (cursorable.cursor) {
							_cursor = Mouse.cursor;
							var cursor:String = cursorable.cursor || MouseCursor.AUTO;
							Mouse.cursor = cursor;
						}
					} else if (_cursor) {
						Mouse.cursor = _cursor;
					}
					break;
				case MouseEvent.MOUSE_OUT:
					if (_cursor)
						Mouse.cursor = _cursor;
					break;
			}
		}

		override protected function doDispose():void {
			stage.removeEventListener(MouseEvent.MOUSE_OVER, _handleMouseEvent);
			stage.removeEventListener(MouseEvent.MOUSE_OUT, _handleMouseEvent);
		}
	}
}
