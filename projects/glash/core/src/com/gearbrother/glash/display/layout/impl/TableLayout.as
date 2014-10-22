package com.gearbrother.glash.display.layout.impl {
	import com.adobe.utils.ArrayUtil;
	import com.gearbrother.glash.common.algorithm.GBoxsGrid;
	import com.gearbrother.glash.common.geom.GDimension;
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.container.GContainer;
	import com.gearbrother.glash.display.layout.impl.EmptyLayout;
	import com.gearbrother.glash.util.lang.ArrayUtil;
	import com.gearbrother.glash.util.math.GMathUtil;
	
	import flash.geom.Rectangle;
	
	import org.as3commons.collections.utils.ArrayUtils;
	import org.as3commons.lang.ArrayUtils;


	/**
	 * @author feynixs(Cai Rong)
	 */
	public class TableLayout extends EmptyLayout {
		/**
		 * This is the horizontal gap (in pixels) which specifies the space
		 * between columns.  They can be changed at any time.
		 * This should be a non-negative integer.
		 *
		 * @see #getHgap()
		 * @see #setHgap(hgap:int)
		 */
		private var hgap:int;
		/**
		 * This is the vertical gap (in pixels) which specifies the space
		 * between rows.  They can be changed at any time.
		 * This should be a non negative integer.
		 *
		 * @see #getVgap()
		 * @see #setVgap(vgap:int)
		 */
		private var vgap:int;
		/**
		 * This is the number of columns specified for the grid.  The number
		 * of columns can be changed at any time.
		 * This should be a non negative integer, where '0' means
		 * 'any number' meaning that the number of Columns in that
		 * dimension depends on the other dimension.
		 *
		 * @see #getColumns()
		 * @see #setColumns(cols:int)
		 */
		private var cols:int;



		/**
		 * <p>
		 * Creates a grid layout with the specified number of rows and
		 * columns. All components in the layout are given equal size.
		 * </p>
		 * <p>
		 * In addition, the horizontal and vertical gaps are set to the
		 * specified values. Horizontal gaps are placed between each
		 * of the columns. Vertical gaps are placed between each of
		 * the rows.
		 * </p>
		 * <p>
		 * One, but not both, of <code>rows</code> and <code>cols</code> can
		 * be zero, which means that any number of objects can be placed in a
		 * row or in a column.
		 * </p>
		 * <p>
		 * All <code>GridLayout</code> constructors defer to this one.
		 * </p>
		 * @param     rows   the rows, with the value zero meaning
		 *                   any number of rows
		 * @param     cols   the columns, with the value zero meaning
		 *                   any number of columns
		 * @param     hgap   (optional)the horizontal gap, default 0
		 * @param     vgap   (optional)the vertical gap, default 0
		 * @throws ArgumentError  if the value of both
		 *			<code>rows</code> and <code>cols</code> is
		 *			set to zero
		 */
		public function TableLayout(cols:int = 0, hgap:int = 0, vgap:int = 0) {
			this.cols = cols;
			this.hgap = hgap;
			this.vgap = vgap;
		}

		/**
		 * Gets the number of columns in this layout.
		 * @return  the number of columns in this layout
		 *
		 */
		public function getColumns():int {
			return cols;
		}

		/**
		 * Sets the number of columns in this layout.
		 * Setting the number of columns has no effect on the layout
		 * if the number of rows specified by a constructor or by
		 * the <tt>setRows</tt> method is non-zero. In that case, the number
		 * of columns displayed in the layout is determined by the total
		 * number of components and the number of rows specified.
		 * @param        cols   the number of columns in this layout
		 *
		 */
		public function setColumns(cols:int):void {
			this.cols = cols;
		}

		/**
		 * Gets the horizontal gap between components.
		 * @return       the horizontal gap between components
		 *
		 */
		public function getHgap():int {
			return hgap;
		}

		/**
		 * Sets the horizontal gap between components to the specified value.
		 * @param    hgap   the horizontal gap between components
		 *
		 */
		public function setHgap(hgap:int):void {
			this.hgap = hgap;
		}

		/**
		 * Gets the vertical gap between components.
		 * @return       the vertical gap between components
		 *
		 */
		public function getVgap():int {
			return vgap;
		}

		/**
		 * Sets the vertical gap between components to the specified value.
		 * @param         vgap  the vertical gap between components
		 *
		 */
		public function setVgap(vgap:int):void {
			this.vgap = vgap;
		}

		override public function preferredLayoutSize(target:GContainer):GDimension {
			var ncomponents:int = _children.length;
			var ws:Array = [];
			var hs:Array = [];
			for (var i:int = 0; i < ncomponents; i++) {
				var child:GNoScale = _children[i] as GNoScale;
				var d:GDimension = child.preferredSize;
				ws[i % cols] = Math.max(int(ws[i % cols]), d.width);
				hs[int(i / cols)] = Math.max(int(hs[int(i / cols)]), d.height);
			}
			return new GDimension(GMathUtil.sum(ws) + (ws.length - 1) * hgap, GMathUtil.sum(hs) + (hs.length - 1) * vgap);
		}

		override public function minimumLayoutSize(target:GContainer):GDimension {
			return new GDimension(target.width, target.height);
		}

		/**
		 * return new IntDimension(1000000, 1000000);
		 */
		override public function maximumLayoutSize(target:GContainer):GDimension {
			return new GDimension(1000000, 1000000);
		}

		override public function layoutContainer(target:GContainer):void {
			var ncomponents:int = _children.length;
			var ws:Array = [];
			var hs:Array = [];
			for (var i:int = 0; i < ncomponents; i++) {
				var child:GNoScale = _children[i] as GNoScale;
				var d:GDimension = child.preferredSize;
				ws[i % cols] = Math.max(int(ws[i % cols]), d.width);
				hs[int(i / cols)] = Math.max(int(hs[int(i / cols)]), d.height);
			}
			var x:int = 0;
			var y:int = 0;
			for (i = 0; i < ncomponents; i++) {
				if (i % cols == 0) {
					x = 0;
					var row:int = i / cols;
					row--;
					if (row > -1)
						y += hs[row];
				}
				child = _children[i] as GNoScale;
				child.x = x;
				child.y = y;
				child.width = child.preferredSize.width;
				child.height = child.preferredSize.height;
				x += ws[i % cols];
			}
		}

		public function toString():String {
			return "TableLayout";
		}
	}
}