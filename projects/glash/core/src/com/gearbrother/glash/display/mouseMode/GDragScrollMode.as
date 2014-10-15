package com.gearbrother.glash.display.mouseMode {
	import com.gearbrother.glash.display.IGScrollable;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 鼠标拖动
	 * @author feng.lee
	 * 
	 */
	public class GDragScrollMode extends GMouseMode implements IGMouseDown {
		private var _dragItemFrom:Point;

		private var _mouseStageDown:Point;

		private function get _scrollTarget():IGScrollable {
			return _trigger as IGScrollable;
		}

		public function GDragScrollMode(dispatcher:IGScrollable, applyNow:Boolean = true) {
			super(dispatcher as InteractiveObject, applyNow);
		}

		public function mouseDown(e:MouseEvent):void {
			var target:InteractiveObject = e.target as InteractiveObject;
			target.stage.addEventListener(MouseEvent.MOUSE_MOVE, _handleMouseEvent);
			target.stage.addEventListener(MouseEvent.MOUSE_UP, _handleMouseEvent);
			_mouseStageDown = new Point(target.stage.mouseX, target.stage.mouseY);
			_dragItemFrom = new Point(_scrollTarget.scrollH, _scrollTarget.scrollV);
		}

		private function _handleMouseEvent(e:MouseEvent):void {
			switch (e.type) {
				case MouseEvent.MOUSE_UP:
					(e.currentTarget as Stage).removeEventListener(MouseEvent.MOUSE_MOVE, _handleMouseEvent);
					(e.currentTarget as Stage).removeEventListener(MouseEvent.MOUSE_UP, _handleMouseEvent);
					break;
				case MouseEvent.MOUSE_MOVE:
					_scrollTarget.scrollH = _dragItemFrom.x + _mouseStageDown.x - e.stageX;
					_scrollTarget.scrollV = _dragItemFrom.y + _mouseStageDown.y - e.stageY;
					e.updateAfterEvent();
					break;
			}
		}
	}
}
