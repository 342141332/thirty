package com.gearbrother.glash.display.layer {
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.container.GContainer;

	import flash.display.DisplayObject;


	/**
	 * @author feng.lee
	 * create on 2013-2-25
	 */
	public class GNofityLayer extends GContainer {
		/**
		 * 窗口队列，在没有窗口时显示队列头窗口 
		 */		
		protected var _queue:Array;
		
		public function GNofityLayer() {
			super();
			
			_queue = [];
		}
		
		/**
		 * 当没有窗口的时候显示窗口 
		 * @param window
		 * 
		 */		
		public function queueWindow(window:GNoScale):void {
			_queue.add(window);
		}
	}
}
