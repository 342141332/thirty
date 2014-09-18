package com.gearbrother.glash.display.layer {
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.IGDndable;
	import com.gearbrother.glash.display.container.GContainer;
	import com.gearbrother.glash.display.event.GDndEvent;
	import com.gearbrother.glash.display.filter.GFilter;
	import com.gearbrother.glash.display.mouseMode.GMouseMode;
	import com.gearbrother.glash.display.mouseMode.IGMouseDown;
	import com.gearbrother.glash.display.mouseMode.IGMouseMove;
	import com.gearbrother.glash.display.mouseMode.IGMouseUp;
	import com.gearbrother.glash.util.display.GDisplayUtil;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	[Event(name="change", type="flash.events.Event")]

	/**
	 * 拖拽层
	 * @author feng.lee
	 * create on 2012-12-30
	 * @see com.gearbrother.glash.display.IGDndable
	 */
	public class GDragLayer extends GNoScale {
		public var dragRender:Function = function(dndData:*):DisplayObject {return null};

		private var _dragElement:DisplayObject;
		
		private var _trigger:DisplayObject;
		public function set trigger(newValue:DisplayObject):void {
			_trigger = newValue;
		}

		private var _dragData:*;
		public function get dragData():* {
			return _dragData;
		}
		public function set dragData(newValue:*):void {
			if (_dragData != newValue) {
				_dragData = newValue;
				dispatchEvent(new Event(Event.CHANGE));
				if (_dragData) {
					stage.addEventListener(MouseEvent.MOUSE_MOVE, _handleMouseEvent);
					stage.addEventListener(MouseEvent.MOUSE_OUT, _handleMouseEvent);
					stage.addEventListener(MouseEvent.MOUSE_OVER, _handleMouseEvent);
					stage.addEventListener(MouseEvent.MOUSE_UP, _handleMouseEvent);
				} else {
					stage.removeEventListener(MouseEvent.MOUSE_MOVE, _handleMouseEvent);
					stage.removeEventListener(MouseEvent.MOUSE_OUT, _handleMouseEvent);
					stage.removeEventListener(MouseEvent.MOUSE_OVER, _handleMouseEvent);
					stage.removeEventListener(MouseEvent.MOUSE_UP, _handleMouseEvent);
				}
			}
		}

		public function GDragLayer(skin:DisplayObject = null) {
			super(skin);
			
			mouseEnabled = mouseChildren = false;
		}
		
		override protected function doInit():void {
			super.doInit();
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, _handleMouseEvent);
		}

		private function _handleMouseEvent(event:MouseEvent):void {
			var target:DisplayObject = event.target as DisplayObject;
			switch (event.type) {
				case MouseEvent.MOUSE_DOWN:
					var d:*;
					while (target) {
						if (target is IGDndable && (target as IGDndable).dndable)
							d = (target as IGDndable).dndData;
						if (!d)
							target = target.parent;
						else
							break;
					}
					dragData = d;
					_trigger = target;
					break;
				case MouseEvent.MOUSE_MOVE:
					if (_dragElement == null) {
						_dragElement = dragRender(dragData) || new Bitmap(GDisplayUtil.grab(_trigger));
						GFilter.decolor.apply(_trigger as DisplayObject);
						addChild(_dragElement);
					}

					var bound:Rectangle = _dragElement.getBounds(_dragElement);
					_dragElement.x = mouseX;// - bound.center.x;
					_dragElement.y = mouseY;// - bound.center.y;
					target.dispatchEvent(new GDndEvent(GDndEvent.MOVE, dragData, _trigger));
					event.updateAfterEvent();
					break;
				case MouseEvent.MOUSE_UP:
					if (_dragElement == null) {
					} else {
						_dragElement.parent.removeChild(_dragElement);
						if (_dragElement is Bitmap) {
							(_dragElement as Bitmap).bitmapData.dispose();
						}
						_dragElement = null;
					}
					GFilter.decolor.unapply(_trigger as DisplayObject);
					target.dispatchEvent(new GDndEvent(GDndEvent.Drop, dragData, _trigger));
					dragData = null;
					break;
				case MouseEvent.MOUSE_OVER:
					target.dispatchEvent(new GDndEvent(GDndEvent.OVER, dragData, _trigger));
					break;
				case MouseEvent.MOUSE_OUT:
					target.dispatchEvent(new GDndEvent(GDndEvent.OUT, dragData, _trigger));
					break;
			}
		}
	}
}
