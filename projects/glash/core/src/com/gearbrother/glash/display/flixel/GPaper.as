package com.gearbrother.glash.display.flixel {
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.IGScrollable;
	import com.gearbrother.glash.display.IGTickable;
	import com.gearbrother.glash.display.container.GContainer;
	import com.gearbrother.glash.display.container.GScrollBase;
	import com.gearbrother.glash.display.layout.impl.FillLayout;
	import com.gearbrother.glash.util.camera.Camera;
	
	import flash.display.DisplayObject;


	/**
	 *
	 * @author neo.lee
	 *
	 */
	public class GPaper extends GNoScale implements IGScrollable {
		public function get minScrollH():int {
			return _camera.bound.left;
		}

		public function get minScrollV():int {
			return _camera.bound.top;
		}

		public function get maxScrollH():int {
			return Math.max(minScrollH, _camera.bound.width - scrollHPageSize);
		}

		public function get maxScrollV():int {
			return Math.max(minScrollV, _camera.bound.height - scrollVPageSize);
		}

		public function get scrollH():int {
			return _camera.screenRect.x;
		}

		public function set scrollH(newValue:int):void {
			_camera.screenRect.x = newValue;
		}

		public function get scrollV():int {
			return _camera.screenRect.y;
		}

		public function set scrollV(newValue:int):void {
			_camera.screenRect.y = newValue;
		}

		public function get scrollHPageSize():int {
			return width;
		}

		public function get scrollVPageSize():int {
			return height;
		}

		protected var _camera:Camera;

		public function get camera():Camera {
			return _camera;
		}
		
		public function GPaper() {
			super();

			_camera = new Camera();
		}

		override public function tick(interval:int):void {
			//if replaying
			
			//else updateInput
			
			//recording
			
			//step in tick loop(collision, update object)
			
			//draw
			for (var i:int = 0; i < numChildren; i++) {
				var child:DisplayObject = getChildAt(i);
				if (child is IGTickable)
					(child as IGTickable).tick(interval);
			}
		}

		override protected function doValidateLayout():void {
			super.doValidateLayout();

			_camera.screenRect.width = width;
			_camera.screenRect.height = height;
			_camera.setChanged();
			this.graphics.clear();
			this.graphics.beginFill(0x000000, .0);
			this.graphics.drawRect(0, 0, width, height);
			this.graphics.endFill();
		}
	}
}
