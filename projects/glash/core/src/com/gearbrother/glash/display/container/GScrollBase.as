package com.gearbrother.glash.display.container {
	import com.gearbrother.glash.common.algorithm.GBoxsGrid;
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.IGScrollable;
	import com.gearbrother.glash.display.event.GDisplayEvent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	[Event(name = "scroll", type = "com.gearbrother.glash.display.event.GDisplayEvent")]

	/**
	 * 滚动容器, 内部content来判断实际大小, 外部width,height来设置显示大小
	 *
	 * @author feng.lee
	 * create on 2013-2-7
	 */
	public class GScrollBase extends GNoScale implements IGScrollable {
		private var _minScrollH:int;

		public function get minScrollH():int {
			return _minScrollH;
		}

		public function set minScrollH(newValue:int):void {
			if (_minScrollH != newValue) {
				_minScrollH = newValue;
				dispatchEvent(new GDisplayEvent(GDisplayEvent.SCROLL_CHANGE));
			}
		}

		public function get maxScrollH():int {
			return Math.max(minScrollH, preferredSize.width - width);
		}

		public function get scrollH():int {
			return scrollRect ? scrollRect.x : 0;
		}

		public function set scrollH(newValue:int):void {
			newValue = Math.max(minScrollH, Math.min(maxScrollH, newValue));
			var viewPort:Rectangle = scrollRect || new Rectangle(minScrollH, minScrollV, scrollHPageSize, scrollVPageSize);
			if (viewPort.x != newValue) {
				viewPort.x = newValue;
				scrollRect = viewPort;
				dispatchEvent(new GDisplayEvent(GDisplayEvent.SCROLL_CHANGE));
			}
		}

		public function get scrollHPageSize():int {
			return width;
		}

		private var _minScrollV:int;

		public function get minScrollV():int {
			return _minScrollV;
		}

		public function set minScrollV(newValue:int):void {
			_minScrollV = newValue;
			dispatchEvent(new GDisplayEvent(GDisplayEvent.SCROLL_CHANGE));
		}
		
		public function get maxScrollV():int {
			return Math.max(minScrollV, preferredSize.height - height);
		}

		public function get scrollV():int {
			return scrollRect ? scrollRect.y : 0;
		}

		public function set scrollV(newValue:int):void {
			newValue = Math.max(minScrollV, Math.min(maxScrollV, newValue));
			var viewPort:Rectangle = scrollRect || new Rectangle(minScrollH, minScrollV, width, height);
			if (viewPort.y != newValue) {
				viewPort.y = newValue;
				scrollRect = viewPort;
				dispatchEvent(new GDisplayEvent(GDisplayEvent.SCROLL_CHANGE));
			}
		}

		public function get scrollVPageSize():int {
			return height;
		}

		override public function set width(newValue:Number):void {
			var viewPort:Rectangle = scrollRect || new Rectangle(0, 0, width, height);
			viewPort.width = newValue;
			scrollRect = viewPort;
			super.width = newValue;
		}

		override public function set height(newValue:Number):void {
			var viewPort:Rectangle = scrollRect || new Rectangle(0, 0, width, height);
			viewPort.height = newValue;
			scrollRect = viewPort;
			super.height = newValue;
		}
		
		public function set wheelScroll(newValue:Boolean):void {
			if (newValue)
				addEventListener(MouseEvent.MOUSE_WHEEL, _handleMouseEvent);
			else
				removeEventListener(MouseEvent.MOUSE_WHEEL, _handleMouseEvent);
		}
		
		private function _handleMouseEvent(event:Event):void {
			switch (event.type) {
				case MouseEvent.MOUSE_WHEEL:
					scrollV++;
					break;
			}
		}
		
		protected var _children:Array;
		
		/**
		 * 进行屏幕判断需要多判断的范围
		 */
		public var exScreenRect:int = 100;
		
		public var positionCache:GBoxsGrid;
		
		public var childrenDict:Dictionary;
		
		public var childrenInScreenDict:Dictionary;

		public function GScrollBase() {
			super();
			
			_children = [];
			childrenDict = new Dictionary();
			childrenInScreenDict = new Dictionary();
		}
		
		override public function addChild(child:DisplayObject):DisplayObject {
			if (_children.indexOf(child) == -1) {
				_children.push(child);
				if (positionCache) {
					positionCache.reinsert(child);
				} else {
					super.addChild(child);
					childrenInScreenDict[child] = true;
				}
				childrenDict[child] = true;
			}
			return child;
		}

		override public function addChildAt(child:DisplayObject, index:int):DisplayObject {
			throw new Error("todo");
		}

		override public function removeChild(child:DisplayObject):DisplayObject {
			var at:int = _children.indexOf(child);
			if (at != -1) {
				_children.splice(at, 1);
				if (positionCache) {
					positionCache.remove(child);
				} else {
					delete childrenInScreenDict[child];
					super.removeChild(child);
				}
				delete childrenDict[child];
			}
			return child;
		}
		
		override public function removeChildAt(index:int):DisplayObject {
			return removeChild(getChildAt(index));
		}
		
		override public function removeAllChildren():void {
			while (_children.length) {
				removeChild(_children[0]);
			}
		}

		override public function invalidateLayout():void {
			super.invalidateLayout();

			dispatchEvent(new GDisplayEvent(GDisplayEvent.SCROLL_CHANGE));
		}
		
		override protected function doValidateLayout():void {
			//set _boxsGrid to remove elements out of screen
			if (positionCache) {
				var screenRect:Rectangle = scrollRect;
				screenRect.inflate(exScreenRect, exScreenRect);
				
				var oldsInScreen:Dictionary = childrenInScreenDict;
				var newsInScreen:Dictionary = new Dictionary();
				var news:Array = positionCache.retrieve(screenRect);
				for each (var newObj:* in news) {
					newsInScreen[newObj] = true;
				}
				
				childrenInScreenDict = newsInScreen;
				
				var child:*;
				for (child in oldsInScreen) {
					if (!newsInScreen[child] && DisplayObject(child).parent == this)
						$removeChild(child);
				}
				for (child in newsInScreen) {
					if (!oldsInScreen[child])
						$addChild(child);
				}
			}
		}
	}
}
