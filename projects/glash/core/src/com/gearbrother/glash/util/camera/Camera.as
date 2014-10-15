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
				_refreshCenter();
				setChanged();
			}
		}
		
		public function get screenRect():Rectangle {
			return _screenRect;
		}
		
		private var _center:Point;
		public function set center(centerTo:Point):void {
			if (!center || center.equals(centerTo) == false) {
				_center = centerTo;
			}
		}
		
		public function _refreshCenter():void {
			var clone:Rectangle = screenRect.clone();
			clone.x = _center.x - (clone.width >> 1);
			clone.y = _center.y - (clone.height >> 1);
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
			_refreshCenter();
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
