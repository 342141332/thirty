package com.gearbrother.glash.util.camera {
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	[Event(name = "change", type = "flash.events.Event")]
	public class Camera extends EventDispatcher {
		private var _zoom:Number;
		
		public function set zoom(v:Number):void {
			_zoom = v;
			setChanged();
		}
		
		public function get zoom():Number {
			return _zoom;
		}
		
		private var _screenRect:Rectangle;
		
		public function set screenRect(newValue:Rectangle):void {
			if (!_screenRect.equals(newValue)) {
				_screenRect = newValue;
				setChanged();
			}
		}
		
		public function get screenRect():Rectangle {
			return _screenRect;
		}
		
		public function set center(centerTo:Point):void {
			var clone:Rectangle = screenRect.clone();
			clone.x = centerTo.x - (clone.width >> 1);
			clone.y = centerTo.y - (clone.height >> 1);
			if (_bound) {
				if (clone.right > _bound.right)
					clone.x = _bound.right - clone.width;
				if (clone.bottom > _bound.bottom)
					clone.y = _bound.bottom - clone.height;
				if (clone.left < _bound.left)
					clone.x = _bound.left;
				if (clone.top < _bound.top)
					clone.y = _bound.top;
			}
			screenRect = clone;
		}
		
		public function get center():Point {
			return new Point(screenRect.x + screenRect.width / 2, screenRect.y + screenRect.height / 2);
		}
		
		//场景大小
		private var _bound:Rectangle;
		
		public function get bound():Rectangle {
			return _bound;
		}
		
		public function set bound(newValue:Rectangle):void {
			_bound = newValue;
		}
		
		public var focus:DisplayObject;
		
		public function focusTo():void {
			if (focus) {
				center = new Point(focus.x, focus.y);
				/*if (focus.x < screenRect.x + screenRect.width * .45) {
				x = focus.x - screenRect.width * .45;
				} else if (focus.x > screenRect.x + screenRect.width * .55) {
				x = focus.x - screenRect.width * .55;
				}
				if (focus.y < screenRect.y + screenRect.height * .45) {
				y = focus.y - screenRect.height * .45;
				} else if (focus.y > screenRect.y + screenRect.height * .55) {
				y = focus.y - screenRect.height * .55;
				}*/
			}
		}
		
		public function Camera() {
			_screenRect = new Rectangle();
			_bound = new Rectangle();
		}
		
		public function setChanged():void {
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * Returns whether panning to the specified location should use animation or
		 * not. The current implementation returns whether the current bounds and
		 * the resulting bounds intersect.
		 */
		/*public function shouldAnimateTo(newCenter:LatLng):Boolean {
		if (__map == null)
		return false;
		var projection:Projection = __map.getProjection();
		var zoom:int = mapLocationModel.getZoom();
		var currentPixelPt:IntPoint = projection.fromLatLngToPixel(mapLocationModel.getCenter(), zoom).move(temporaryOffset.x, temporaryOffset.y);
		var toPixelPt:IntPoint = projection.fromLatLngToPixel(newCenter, zoom);
		var distance:IntPoint = currentPixelPt.distancePoint(toPixelPt);
		var cameraRect:IntDimension = getMapSize();
		return (Math.abs(distance.x) < cameraRect.width) && (Math.abs(distance.y) < cameraRect.height);
		}*/
	}
}
