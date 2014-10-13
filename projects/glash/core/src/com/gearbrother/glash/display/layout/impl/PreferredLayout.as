package com.gearbrother.glash.display.layout.impl {
	import com.gearbrother.glash.GMain;
	import com.gearbrother.glash.common.algorithm.GBoxsGrid;
	import com.gearbrother.glash.common.geom.GDimension;
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.container.GContainer;

	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;

	/**
	 * @author neozhang
	 * @create on Oct 18, 2013
	 */
	public class PreferredLayout extends EmptyLayout {
		static public const logger:ILogger = getLogger(PreferredLayout);

		public function PreferredLayout() {
			super();
		}

		override public function layoutContainer(target:GContainer):void {
			for (var k:int = 0; k < _children.length; k++) {
				var child:GNoScale = _children[k] as GNoScale;
				child.width = child.preferredSize.width;
				child.height = child.preferredSize.height;
				child.validateLayoutNow();
			}
		}
	}
}
