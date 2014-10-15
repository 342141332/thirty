package com.gearbrother.glash.display.flixel {
	import com.gearbrother.glash.common.algorithm.GBoxsGrid;
	import com.gearbrother.glash.common.collections.ArrayList;
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.IGTickable;
	import com.gearbrother.glash.display.container.GScrollBase;
	import com.gearbrother.glash.display.flixel.sort.ISortManager;
	import com.gearbrother.glash.display.propertyHandler.GPropertyEventHandler;
	import com.gearbrother.glash.util.camera.Camera;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	public class GPaperLayer extends GScrollBase {
		private var _cameraHandler:GPropertyEventHandler;
		public function get camera():Camera {
			return _cameraHandler ? _cameraHandler.value : null;
		}
		public function set camera(newValue:Camera):void {
			_cameraHandler ||= new GPropertyEventHandler(Event.CHANGE, _handleCameraChanged, this);
			_cameraHandler.value = newValue;
		}
		private function _handleCameraChanged(event:Event = null):void {
			scrollRect = camera.screenRect;
		}

		public var sortManager:ISortManager;

		public function GPaperLayer(camera:Camera) {
			super();

			this.camera = camera;
//			_boxsGrid = new BoxsGrid2(paper.camera.bound, boxWidth, boxHeight);
		}

		override public function tick(interval:int):void {
			if (sortManager)
				sortManager.sortAll();

//			maxScrollH = Math.max(0, camera.bound.width - camera.screenRect.width);
//			maxScrollV = Math.max(0, camera.bound.height - camera.screenRect.height);
//			width = camera.screenRect.width;
//			height = camera.screenRect.height;
		}
	}
}
