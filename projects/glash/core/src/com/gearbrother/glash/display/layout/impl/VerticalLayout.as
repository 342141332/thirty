package com.gearbrother.glash.display.layout.impl {
	import com.gearbrother.glash.common.algorithm.GBoxsGrid;
	import com.gearbrother.glash.common.geom.GDimension;
	import com.gearbrother.glash.display.GDisplayConst;
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.container.GContainer;
	
	import flash.geom.Rectangle;

	public class VerticalLayout extends EmptyLayout {
		public var alignment:int;

		public var padding:int;

		public function VerticalLayout(alignment:int, padding:int = 5) {
			this.alignment = alignment;
			this.padding = padding;
		}

		override public function preferredLayoutSize(target:GContainer):GDimension {
			var maxWidth:int;
			var height:int;
			for (var i:int = 0; i < _children.length; i++) {
				var child:GNoScale = _children[i] as GNoScale;
				maxWidth = Math.max(maxWidth, child.preferredSize.width);
				height += child.preferredSize.height;
			}
			height += Math.max(0, _children.length - 1) * padding;
			return new GDimension(maxWidth, height);
		}
		
		override public function layoutContainer(target:GContainer):void {
			var rect:Rectangle = new Rectangle(0, 0, target.width, target.height);
			var y:int = 0;
			for (var i:int = 0; i < _children.length; i++) {
				var child:GNoScale = _children[i] as GNoScale;
				if (alignment == GDisplayConst.ALIGN_LEFT)
					child.x = 0;
				else if (alignment == GDisplayConst.ALIGN_CENTER)
					child.x = (rect.width - child.preferredSize.width) >> 1;
				else if (alignment == GDisplayConst.ALIGN_BOTTOM)
					child.x = rect.width - child.preferredSize.width;
				child.y = y;
				y += child.preferredSize.height + padding;
				child.width = child.preferredSize.width;
				child.height = child.preferredSize.height;
			}
		}
	}
}
