package com.gearbrother.glash.display.control {

	import com.gearbrother.glash.common.utils.GClassFactory;
	import com.gearbrother.glash.display.GDisplayConst;
	import com.gearbrother.glash.display.GSprite;
	import com.gearbrother.glash.display.IGScrollable;
	import com.gearbrother.glash.display.control.GSlider;
	import com.gearbrother.glash.display.event.GDisplayEvent;
	import com.gearbrother.glash.display.propertyHandler.GPropertyEventHandler;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;


	/**
	 *
	 * @author feng.lee
	 *
	 */
	public class GScrollBar extends GSlider {
		private var _eventHandler:GPropertyEventHandler;
		public function get scrollTarget():IGScrollable {
			return _eventHandler ? _eventHandler.value : null;
		}
		public function set scrollTarget(newValue:IGScrollable):void {
			_eventHandler = new GPropertyEventHandler(GDisplayEvent.SCROLL_CHANGE
				, function():void {
					repaint();
				}
				, this);
			_eventHandler.value = newValue;
		}

		override public function set value(newValue:Number):void {
			if (super.value != newValue) {
				if (scrollTarget) {
					switch (direction) {
						case GDisplayConst.AXIS_X:
							scrollTarget.scrollH = newValue;
							break;
						case GDisplayConst.AXIS_Y:
							scrollTarget.scrollV = newValue;
							break;
					}
				}
				super.value = newValue;
			}
		}

		public function GScrollBar(direction:int, skin:DisplayObject) {
			super(direction, skin);
		}
		
		override public function paintNow():void {
			switch (direction) {
				case GDisplayConst.AXIS_X:
					minValue = scrollTarget.minScrollH;
					maxValue = scrollTarget.maxScrollH;
					value = scrollTarget.scrollH;
					pageSize = scrollTarget.width;
					break;
				case GDisplayConst.AXIS_Y:
					minValue = scrollTarget.minScrollV;
					maxValue = scrollTarget.maxScrollV;
					value = scrollTarget.scrollV;
					pageSize = scrollTarget.height;
					break;
			}
			
			super.paintNow();
		}
	}
}
