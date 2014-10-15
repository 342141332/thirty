package com.gearbrother.glash.display.layout.impl {
	import com.gearbrother.glash.common.geom.GDimension;
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.container.GContainer;


	/**
	 * A border layout lays out a container, arranging and resizing
	 * its components to fit in five regions:
	 * north, south, east, west, and center.
	 * Each region may contain no more than one component, and
	 * is identified by a corresponding constant:
	 * <code>NORTH</code>, <code>SOUTH</code>, <code>EAST</code>,
	 * <code>WEST</code>, and <code>CENTER</code>.  When adding a
	 * component to a container with a border layout, use one of these
	 * five constants, for example:
	 * <pre>
	 *    Panel p = new Panel();
	 *    p.setLayout(new BorderLayout());
	 *    p.add(new Button("Okay"), BorderLayout.SOUTH);
	 * </pre>
	 * For convenience, <code>BorderLayout</code> interprets the
	 * absence of a string specification the same as the constant
	 * <code>CENTER</code>:
	 * <pre>
	 *    Panel p2 = new Panel();
	 *    p2.setLayout(new BorderLayout());
	 *    p2.add(new TextArea());  // Same as p.add(new TextArea(), BorderLayout.CENTER);
	 * </pre>
	 *
	 * <p>
	 * The following image illustrate the way the borderLayout layout child component.
	 * <br></br>
	 * <img src="../../aswingImg/BorderLayout.JPG" ></img>
	 * </p>
	 */
	public class BorderLayout extends EmptyLayout {
		private var hgap:Number;

		private var vgap:Number;

		private var north:GNoScale;

		private var west:GNoScale;

		private var east:GNoScale;

		private var south:GNoScale;

		private var center:GNoScale;

		private var firstLine:GNoScale;

		private var lastLine:GNoScale;

		private var firstItem:GNoScale;

		private var lastItem:GNoScale;

		private var defaultConstraints:String;

		/**
		 * The north layout constraint (top of container).
		 */
		public static const NORTH:String = "North";

		/**
		 * The south layout constraint (bottom of container).
		 */
		public static const SOUTH:String = "South";

		/**
		 * The east layout constraint (right side of container).
		 */
		public static const EAST:String = "East";

		/**
		 * The west layout constraint (left side of container).
		 */
		public static const WEST:String = "West";

		/**
		 * The center layout constraint (middle of container).
		 */
		public static const CENTER:String = "Center";


		public static const BEFORE_FIRST_LINE:String = "First";


		public static const AFTER_LAST_LINE:String = "Last";


		public static const BEFORE_LINE_BEGINS:String = "Before";


		public static const AFTER_LINE_ENDS:String = "After";


		public static const PAGE_START:String = BEFORE_FIRST_LINE;


		public static const PAGE_END:String = AFTER_LAST_LINE;


		public static const LINE_START:String = BEFORE_LINE_BEGINS;


		public static const LINE_END:String = AFTER_LINE_ENDS;

		/**
		 * Constructs a border layout with the specified gaps
		 * between components.
		 * The horizontal gap is specified by <code>hgap</code>
		 * and the vertical gap is specified by <code>vgap</code>.
		 * @param   hgap   the horizontal gap.
		 * @param   vgap   the vertical gap.
		 */
		public function BorderLayout(hgap:int = 0, vgap:int = 0) {
			this.hgap = hgap;
			this.vgap = vgap;
			this.defaultConstraints = CENTER;
		}

		/**
		 *
		 */
		public function setDefaultConstraints(constraints:Object):void {
			defaultConstraints = constraints.toString();
		}

		public function getHgap():int {
			return hgap;
		}

		/**
		 * Set horizontal gap
		 */
		public function setHgap(hgap:int):void {
			this.hgap = hgap;
		}

		public function getVgap():int {
			return vgap;
		}

		/**
		 *  Set vertical gap
		 */
		public function setVgap(vgap:int):void {
			this.vgap = vgap;
		}

		/**
		 *
		 */
		override public function addLayoutComponent(comp:GNoScale, constraints:Object = null):void {
			var name:String = constraints != null ? constraints.toString() : null;
			addLayoutComponentByAlign(name, comp);
		}

		private function addLayoutComponentByAlign(name:String, comp:GNoScale):void {
			if (name == null) {
				name = defaultConstraints;
			}

			if (CENTER == name) {
				center = comp;
			} else if (NORTH == name) {
				north = comp;
			} else if (SOUTH == name) {
				south = comp;
			} else if (EAST == name) {
				east = comp;
			} else if (WEST == name) {
				west = comp;
			} else if (BEFORE_FIRST_LINE == name) {
				firstLine = comp;
			} else if (AFTER_LAST_LINE == name) {
				lastLine = comp;
			} else if (BEFORE_LINE_BEGINS == name) {
				firstItem = comp;
			} else if (AFTER_LINE_ENDS == name) {
				lastItem = comp;
			} else {
				//defaut center
				center = comp;
			}
		}

		/**
		 *
		 */
		override public function removeLayoutComponent(comp:GNoScale):void {
			if (comp == center) {
				center = null;
			} else if (comp == north) {
				north = null;
			} else if (comp == south) {
				south = null;
			} else if (comp == east) {
				east = null;
			} else if (comp == west) {
				west = null;
			}
			if (comp == firstLine) {
				firstLine = null;
			} else if (comp == lastLine) {
				lastLine = null;
			} else if (comp == firstItem) {
				firstItem = null;
			} else if (comp == lastItem) {
				lastItem = null;
			}
		}

		/**
		 *
		 */
		override public function minimumLayoutSize(target:GContainer):GDimension {
			return new GDimension(target.width, target.height);
		}

		/**
		 *
		 */
		override public function preferredLayoutSize(target:GContainer):GDimension {
			var dim:GDimension = new GDimension(0, 0);
			var ltr:Boolean = true;
			var c:GNoScale = null;

			var d:GDimension;
			if ((c = getChild(EAST, ltr)) != null) {
				d = c.preferredSize;
				dim.width += d.width + hgap;
				dim.height = Math.max(d.height, dim.height);
			}
			if ((c = getChild(WEST, ltr)) != null) {
				d = c.preferredSize;
				dim.width += d.width + hgap;
				dim.height = Math.max(d.height, dim.height);
			}
			if ((c = getChild(CENTER, ltr)) != null) {
				d = c.preferredSize;
				dim.width += d.width;
				dim.height = Math.max(d.height, dim.height);
			}
			if ((c = getChild(NORTH, ltr)) != null) {
				d = c.preferredSize;
				dim.width = Math.max(d.width, dim.width);
				dim.height += d.height + vgap;
			}
			if ((c = getChild(SOUTH, ltr)) != null) {
				d = c.preferredSize;
				dim.width = Math.max(d.width, dim.width);
				dim.height += d.height + vgap;
			}

			return dim;
		}

		/**
		 * <p>
		 * Lays out the container argument using this border layout.
		 * </p>
		 * <p>
		 * This method actually reshapes the components in the specified
		 * container in order to satisfy the constraints of this
		 * <code>BorderLayout</code> object. The <code>NORTH</code>
		 * and <code>SOUTH</code> components, if any, are placed at
		 * the top and bottom of the container, respectively. The
		 * <code>WEST</code> and <code>EAST</code> components are
		 * then placed on the left and right, respectively. Finally,
		 * the <code>CENTER</code> object is placed in any remaining
		 * space in the middle.
		 * </p>
		 * <p>
		 * Most applications do not call this method directly. This method
		 * is called when a container calls its <code>doLayout</code> method.
		 * </p>
		 * @param   target   the container in which to do the layout.
		 * @see     GContainer
		 * @see     GContainer#doLayout()
		 */
		override public function layoutContainer(target:GContainer):void {
			var td:GDimension = new GDimension(target.width, target.height);
			var top:int = 0;
			var bottom:int = td.height;
			var left:int = 0;
			var right:int = td.width;
			var ltr:Boolean = true;
			var c:GNoScale = null;

			var d:GDimension;
			if ((c = getChild(NORTH, ltr)) != null) {
				d = c.preferredSize;
				c.x = left;
				c.y = top;
				c.width = right - left;
				c.height = d.height;
				top += d.height + vgap;
			}
			if ((c = getChild(SOUTH, ltr)) != null) {
				d = c.preferredSize;
				c.x = left;
				c.y = bottom - d.height;
				c.width = right - left;
				c.height = d.height;
				bottom -= d.height + vgap;
			}
			if ((c = getChild(EAST, ltr)) != null) {
				d = c.preferredSize;
				c.x = right - d.width;
				c.y = top;
				c.width = d.width;
				c.height = bottom - top;
				right -= d.width + hgap;
			}
			if ((c = getChild(WEST, ltr)) != null) {
				d = c.preferredSize;
				c.x = left;
				c.y = top;
				c.width = d.width;
				c.height = bottom - top;
				left += d.width + hgap;
			}
			if ((c = getChild(CENTER, ltr)) != null) {
				c.x = left;
				c.y = top;
				c.width = right - left;
				c.height = bottom - top;
			}
		}

		/**
		 * Get the component that corresponds to the given constraint location
		 *
		 * @param   key     The desired absolute position,
		 *                  either NORTH, SOUTH, EAST, or WEST.
		 * @param   ltr     Is the component line direction left-to-right?
		 */
		private function getChild(key:String, ltr:Boolean):GNoScale {
			var result:GNoScale = null;

			if (key == NORTH) {
				result = (firstLine != null) ? firstLine : north;
			} else if (key == SOUTH) {
				result = (lastLine != null) ? lastLine : south;
			} else if (key == WEST) {
				result = ltr ? firstItem : lastItem;
				if (result == null) {
					result = west;
				}
			} else if (key == EAST) {
				result = ltr ? lastItem : firstItem;
				if (result == null) {
					result = east;
				}
			} else if (key == CENTER) {
				result = center;
			}
			return result;
		}

		public function toString():String {
			return "BorderLayout[hgap=" + hgap + ",vgap=" + vgap + "]";
		}
	}
}
