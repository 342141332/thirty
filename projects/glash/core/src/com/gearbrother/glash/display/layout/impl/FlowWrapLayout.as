package com.gearbrother.glash.display.layout.impl {
	import com.gearbrother.glash.common.geom.GDimension;
	import com.gearbrother.glash.display.GDisplayConst;
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.container.GContainer;
	import com.gearbrother.glash.util.display.GDisplayUtil;

	/**
	 * FlowWrapLayout wrap layout is extended FlowLayout,
	 * the only different is that it has a prefer width, the prefer width means that when count the preffered size,
	 * it assume to let chilren arrange to a line when one reach the prefer width, then wrap next to next line.
	 * FlowLayout is different, when counting the preferred size, FlowLayout assumes all children should be arrange to one line.
	 *
	 * @author 	iiley
	 */
	public class FlowWrapLayout extends FlowLayout {
		private var preferWidth:int;

		/**
		 * <p>
		 * Creates a new flow wrap layout manager with the indicated prefer width, alignment
		 * and the indicated horizontal and vertical gaps.
		 * </p>
		 * The value of the alignment argument must be one of
		 * <code>FlowWrapLayout.LEFT</code>, <code>FlowWrapLayout.RIGHT</code>,or <code>FlowWrapLayout.CENTER</code>.
		 * @param      preferWidth the width that when component need to wrap to second line
		 * @param      align   the alignment value, default is LEFT
		 * @param      hgap    the horizontal gap between components, default 5
		 * @param      vgap    the vertical gap between components, default 5
		 * @param      margin  whether or not the gap will margin around
		 */
		public function FlowWrapLayout(preferWidth:int = 200, hgap:int = 5, vgap:int = 5, margin:Boolean = true) {
			super(hgap, vgap, margin);
			this.preferWidth = preferWidth;
		}

		/**
		 * Sets the prefer width for all should should arranged.
		 * @param preferWidth the prefer width for all should should arranged.
		 */
		public function setPreferWidth(preferWidth:int):void {
			this.preferWidth = preferWidth;
		}

		/**
		 * Returns the prefer width for all should should arranged.
		 * @return the prefer width for all should should arranged.
		 */
		public function getPreferWidth():int {
			return preferWidth;
		}

		/**
		 * Returns the preferred dimensions for this layout given the
		 * <i>visible</i> components in the specified target container.
		 * @param target the component which needs to be laid out
		 * @return    the preferred dimensions to lay out the
		 *            subcomponents of the specified container
		 * @see GContainer
		 * @see #doLayout()
		 */
		override public function preferredLayoutSize(target:GContainer):GDimension {
			var dim:GDimension = new GDimension(0, 0);
			var nmembers:int = _children.length;
			var x:int = 0;
			var rowHeight:int = 0;
			var visibleNum:int = 0;
			var count:int = 0;

			for (var i:int = 0; i < nmembers; i++) {
				if (GDisplayUtil.getStageVisible(_children[i])) {
					visibleNum++;
				}
			}
			for (i = 0; i < nmembers; i++) {
				var m:GNoScale = _children[i] as GNoScale;
				count++;
				var d:GDimension = m.preferredSize;
				rowHeight = Math.max(rowHeight, d.height);
				if (x > 0) {
					x += hgap;
				}
				x += d.width;
				if (x >= preferWidth || count == visibleNum) {
					dim.width = Math.max(dim.width, x);
					dim.height += rowHeight;
					if (count != visibleNum) {
						dim.height += vgap;
					}
					x = 0;
				}
			}
			if (margin) {
				dim.width += hgap * 2;
				dim.height += vgap * 2;
			}
			return dim;
		}

		/**
		 * Returns a string representation of this <code>FlowWrapLayout</code>
		 * object and its values.
		 * @return     a string representation of this layout
		 */
		override public function toString():String {
			var str:String = "";
			switch (align) {
				case GDisplayConst.ALIGN_LEFT:
					str = ",align=left";
					break;
				case GDisplayConst.ALIGN_CENTER:
					str = ",align=center";
					break;
				case GDisplayConst.ALIGN_RIGHT:
					str = ",align=right";
					break;
			}
			return "FlowWrapLayout[hgap=" + hgap + ",vgap=" + vgap + str + "]";
		}
	}
}
