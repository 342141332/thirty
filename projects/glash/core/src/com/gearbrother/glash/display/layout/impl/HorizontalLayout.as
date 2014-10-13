package com.gearbrother.glash.display.layout.impl {
	import com.gearbrother.glash.common.algorithm.GBoxsGrid;
	import com.gearbrother.glash.common.geom.GDimension;
	import com.gearbrother.glash.display.GDisplayConst;
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.container.GContainer;
	
	import flash.geom.Rectangle;

	public class HorizontalLayout extends EmptyLayout {
		public var alignment:int;

		public var padding:int;

		public function HorizontalLayout(alignment:int, padding:int = 5) {
			this.alignment = alignment;
			this.padding = padding;
		}

		override public function preferredLayoutSize(target:GContainer):GDimension {
			var maxHeight:int;
			var width:int;
			for (var i:int = 0; i < _children.length; i++) {
				var child:GNoScale = _children[i] as GNoScale;
				maxHeight = Math.max(maxHeight, child.preferredSize.height);
				width += child.preferredSize.width;
			}
			width += Math.max(0, target.numChildren - 1) * padding;
			return new GDimension(width, maxHeight);
		}

		override public function layoutContainer(target:GContainer):void {
			var rect:Rectangle = new Rectangle(0, 0, target.width, target.height);
			var x:int = 0;
			for (var i:int = 0; i < _children.length; i++) {
				var child:GNoScale = _children[i] as GNoScale;
				child.x = x;
				x += child.preferredSize.width + padding;
				if (alignment == GDisplayConst.ALIGN_TOP)
					child.y = 0;
				else if (alignment == GDisplayConst.ALIGN_CENTER)
					child.y = (rect.height - child.preferredSize.height) >> 1;
				else if (alignment == GDisplayConst.ALIGN_BOTTOM)
					child.y = rect.height - child.preferredSize.height;
				child.width = child.preferredSize.width;
				child.height = child.preferredSize.height;
			}
		}
	}
}
