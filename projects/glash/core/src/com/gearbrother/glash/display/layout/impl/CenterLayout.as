package com.gearbrother.glash.display.layout.impl {
	import com.gearbrother.glash.common.geom.GDimension;
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.container.GContainer;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;

	/**
	 * Simple <code>LayoutManager</code> aligned the single contained component by the container's center.
	 *
	 */
	public class CenterLayout extends EmptyLayout {
		static public const logger:ILogger = getLogger(CenterLayout);
		
		public function CenterLayout() {
			super();
		}

		/**
		 * Calculates preferred layout size for the given container.
		 */
		override public function preferredLayoutSize(target:GContainer):GDimension {
			return ((target.numChildren > 0) ? (target.getChildAt(0) as GNoScale).preferredSize : new GDimension(target.width, target.height));
		}

		/**
		 * Layouts component by center inside the given container.
		 *
		 * @param target the container to lay out
		 */
		override public function layoutContainer(target:GContainer):void {
			if (target.numChildren > 0) {
				var rd:GDimension = new GDimension(target.width, target.height);
				var length:int = _children.length;
				for (var i:int = 0; i < length; i++) {
					var child:GNoScale = _children[i] as GNoScale;
					var preferredSize:GDimension = child.preferredSize;
					child.x = (rd.width - preferredSize.width) >> 1;
					child.y = (rd.height - preferredSize.height) >> 1;
					child.width = preferredSize.width;
					child.height = preferredSize.height;
				}
			}
		}
	}
}
