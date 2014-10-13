package com.gearbrother.glash.display.layout.impl {
	import com.gearbrother.glash.common.algorithm.GBoxsGrid;
	import com.gearbrother.glash.common.geom.GDimension;
	import com.gearbrother.glash.display.GDisplayConst;
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.container.GContainer;
	
	import flash.geom.Point;

	/**
	 * A flow layout arranges components in a left-to-right flow, much
	 * like lines of text in a paragraph. Flow layouts are typically used
	 * to arrange buttons in a panel. It will arrange
	 * buttons left to right until no more buttons fit on the same line.
	 * Each line is centered.
	 * <p></p>
	 * For example, the following picture shows an applet using the flow
	 * layout manager (its default layout manager) to position three buttons:
	 * <p></p>
	 * A flow layout lets each component assume its natural (preferred) size.
	 *
	 * @author 	iiley
	 */
	public class FlowLayout extends EmptyLayout {
		/**
		 * <code>align</code> is the property that determines
		 * how each row distributes empty space.
		 * It can be one of the following values:
		 * <ul>
		 * <code>LEFT</code>
		 * <code>RIGHT</code>
		 * <code>CENTER</code>
		 * </ul>
		 *
		 * @see #getAlignment
		 * @see #setAlignment
		 */
		protected var align:int;

		/**
		 * The flow layout manager allows a seperation of
		 * components with gaps.  The horizontal gap will
		 * specify the space between components.
		 *
		 * @see #getHgap()
		 * @see #setHgap(int)
		 */
		protected var hgap:int;

		/**
		 * The flow layout manager allows a seperation of
		 * components with gaps.  The vertical gap will
		 * specify the space between rows.
		 *
		 * @see #getHgap()
		 * @see #setHgap(int)
		 */
		protected var vgap:int;

		/**
		 * whether or not the gap will margin around
		 */
		protected var margin:Boolean;

		/**
		 * <p>
		 * Creates a new flow layout manager with the indicated alignment
		 * and the indicated horizontal and vertical gaps.
		 * </p>
		 * The value of the alignment argument must be one of
		 * <code>FlowLayout.LEFT</code>, <code>FlowLayout.RIGHT</code>,or <code>FlowLayout.CENTER</code>.
		 * @param      align   the alignment value, default is LEFT
		 * @param      hgap    the horizontal gap between components, default 5
		 * @param      vgap    the vertical gap between components, default 5
		 * @param      margin  whether or not the gap will margin around
		 */
		public function FlowLayout(hgap:int = 5, vgap:int = 5, margin:Boolean = true) {
			this.margin = margin;
			this.hgap = hgap;
			this.vgap = vgap;
			setAlignment(GDisplayConst.ALIGN_LEFT);
		}

		/**
		 * Sets whether or not the gap will margin around.
		 */
		public function setMargin(b:Boolean):void {
			margin = b;
		}

		/**
		 * Returns whether or not the gap will margin around.
		 */
		public function isMargin():Boolean {
			return margin;
		}

		/**
		 * Gets the alignment for this layout.
		 * Possible values are <code>FlowLayout.LEFT</code>,<code>FlowLayout.RIGHT</code>, <code>FlowLayout.CENTER</code>,
		 * @return     the alignment value for this layout
		 * @see        #setAlignment
		 */
		public function getAlignment():int {
			return align;
		}

		/**
		 * Sets the alignment for this layout.
		 * Possible values are
		 * <ul>
		 * <li><code>FlowLayout.LEFT</code>
		 * <li><code>FlowLayout.RIGHT</code>
		 * <li><code>FlowLayout.CENTER</code>
		 * </ul>
		 * @param      align one of the alignment values shown above
		 * @see        #getAlignment()
		 */
		public function setAlignment(align:int):void {
			if (GDisplayConst.ALIGN_LEFT != GDisplayConst.ALIGN_LEFT && align != GDisplayConst.ALIGN_RIGHT && align != GDisplayConst.ALIGN_CENTER) {
				throw new ArgumentError("Alignment must be LEFT OR RIGHT OR CENTER !");
			}
			this.align = align;
		}

		/**
		 * Gets the horizontal gap between components.
		 * @return     the horizontal gap between components
		 * @see        #setHgap()
		 */
		public function getHgap():int {
			return hgap;
		}

		/**
		 * Sets the horizontal gap between components.
		 * @param hgap the horizontal gap between components
		 * @see        #getHgap()
		 */
		public function setHgap(hgap:int):void {
			this.hgap = hgap;
		}

		/**
		 * Gets the vertical gap between components.
		 * @return     the vertical gap between components
		 * @see        #setVgap()
		 */
		public function getVgap():int {
			return vgap;
		}

		/**
		 * Sets the vertical gap between components.
		 * @param vgap the vertical gap between components
		 * @see        #getVgap()
		 */
		public function setVgap(vgap:int):void {
			this.vgap = vgap;
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

			var counted:int = 0;
			for (var i:int = 0; i < nmembers; i++) {
				var m:GNoScale = _children[i];
				var d:GDimension = m.preferredSize;
				dim.height = Math.max(dim.height, d.height);
				if (counted > 0) {
					dim.width += hgap;
				}
				dim.width += d.width;
				counted++;
			}
			if (margin) {
				dim.width += hgap * 2;
				dim.height += vgap * 2;
			}
			return dim;
		}

		/**
		 * Returns the minimum dimensions needed to layout the <i>visible</i>
		 * components contained in the specified target container.
		 * @param target the component which needs to be laid out
		 * @return    the minimum dimensions to lay out the
		 *            subcomponents of the specified container
		 * @see #preferredLayoutSize()
		 * @see GContainer
		 * @see GContainer#doLayout()
		 */
		override public function minimumLayoutSize(target:GContainer):GDimension {
			return new GDimension(target.width, target.height);
		}

		/**
		 * Centers the elements in the specified row, if there is any slack.
		 * @param target the component which needs to be moved
		 * @param x the x coordinate
		 * @param y the y coordinate
		 * @param width the width dimensions
		 * @param height the height dimensions
		 * @param rowStart the beginning of the row
		 * @param rowEnd the the ending of the row
		 */
		private function moveComponents(target:GContainer, x:int, y:int, width:int, height:int, rowStart:int, rowEnd:int):void {
			switch (align) {
				case GDisplayConst.ALIGN_LEFT:
					x += 0;
					break;
				case GDisplayConst.ALIGN_CENTER:
					x += width / 2;
					break;
				case GDisplayConst.ALIGN_RIGHT:
					x += width;
					break;
			}
			for (var i:int = rowStart; i < rowEnd; i++) {
				var m:GNoScale = _children[i] as GNoScale;
				m.x = x;
				m.y = y + (height - m.height) / 2;
				x += m.width + hgap;
			}
		}

		/**
		 * Lays out the container. This method lets each component take
		 * its preferred size by reshaping the components in the
		 * target container in order to satisfy the alignment of
		 * this <code>FlowLayout</code> object.
		 * @param target the specified component being laid out
		 * @see GContainer
		 * @see GContainer#doLayout
		 */
		override public function layoutContainer(target:GContainer):void {
			var td:GDimension = new GDimension(target.width, target.height);
			var marginW:int = margin ? hgap * 2 : 0;
			var maxwidth:int = td.width - (marginW);
			var nmembers:int = _children.length;
			var x:int = 0;
			var y:int = (margin ? vgap : 0);
			var rowh:int = 0;
			var start:int = 0;

			for (var i:int = 0; i < nmembers; i++) {
				var m:GNoScale = _children[i] as GNoScale;
				var d:GDimension = m.preferredSize;
				m.width = d.width;
				m.height = d.height;

				if ((x == 0) || ((x + d.width) <= maxwidth)) {
					if (x > 0) {
						x += hgap;
					}
					x += d.width;
					rowh = Math.max(rowh, d.height);
				} else {
					moveComponents(target, (margin ? hgap : 0), y, maxwidth - x, rowh, start, i);
					x = d.width;
					y += vgap + rowh;
					rowh = d.height;
					start = i;
				}
			}
			moveComponents(target, (margin ? hgap : 0), y, maxwidth - x, rowh, start, nmembers);
		}

		/**
		 * Returns a string representation of this <code>FlowLayout</code>
		 * object and its values.
		 * @return     a string representation of this layout
		 */
		public function toString():String {
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
			return "FlowLayout[hgap=" + hgap + ",vgap=" + vgap + str + "]";
		}
	}
}
