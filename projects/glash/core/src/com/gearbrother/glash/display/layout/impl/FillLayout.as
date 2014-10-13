package com.gearbrother.glash.display.layout.impl {
	import com.gearbrother.glash.common.geom.GDimension;
	import com.gearbrother.glash.display.container.GContainer;
	
	import flash.display.DisplayObject;

	/**
	 * @author feng.lee
	 * create on 2012-9-17 下午6:55:03
	 */
	public class FillLayout extends EmptyLayout {
		public function FillLayout() {
			super();
		}
		
		override public function layoutContainer(target:GContainer):void {
			var bounds:GDimension = new GDimension(target.width, target.height);
			for each (var child:DisplayObject in _children) {
				child.x = 0;
				child.y = 0;
				child.width = bounds.width;
				child.height = bounds.height;
			}
		}
	}
}
