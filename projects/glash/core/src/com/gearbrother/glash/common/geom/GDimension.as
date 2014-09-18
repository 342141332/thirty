/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package com.gearbrother.glash.common.geom {
	import flash.geom.Rectangle;

	/**
	 * The Dimension class encapsulates the width and height of a componentin a single object.<br>
	 * Note this Class use <b>Number</b> as its parameters on purpose to avoid problems that happended in aswing before.
	 * @author iiley
	 */
	public class GDimension {

		public var width:Number = 0;
		public var height:Number = 0;

		/**
		 * Creates a dimension.
		 */
		public function GDimension(width:Number = 0, height:Number = 0) {
			this.width = width;
			this.height = height;
		}

		/**
		 * Sets the size as same as the dim.
		 */
		public function setSize(dim:GDimension):void {
			this.width = dim.width;
			this.height = dim.height;
		}

		/**
		 * Sets the size with width and height.
		 */
		public function setSizeWH(width:Number, height:Number):void {
			this.width = width;
			this.height = height;
		}

		/**
		 * Increases the size by s and return its self(<code>this</code>).
		 * @return <code>this</code>.
		 */
		public function increaseSize(s:GDimension):GDimension {
			width += s.width;
			height += s.height;
			return this;
		}

		/**
		 * Decreases the size by s and return its self(<code>this</code>).
		 * @return <code>this</code>.
		 */
		public function decreaseSize(s:GDimension):GDimension {
			width -= s.width;
			height -= s.height;
			return this;
		}

		/**
		 * modify the size and return itself.
		 */
		public function change(deltaW:Number, deltaH:Number):GDimension {
			width += deltaW;
			height += deltaH;
			return this;
		}

		/**
		 * return a new size with this size with a change.
		 */
		public function changedSize(deltaW:Number, deltaH:Number):GDimension {
			var s:GDimension = new GDimension(deltaW, deltaH);
			return s;
		}

		/**
		 * Combines current and specified dimensions by getting max sizes
		 * and puts result Numbero itself.
		 * @return the combined dimension itself.
		 */
		public function combine(d:GDimension):GDimension {
			this.width = Math.max(this.width, d.width);
			this.height = Math.max(this.height, d.height);
			return this;
		}

		/**
		 * Combines current and specified dimensions by getting max sizes
		 * and returns new NumberDimension object
		 * @return a new dimension with combined size.
		 */
		public function combineSize(d:GDimension):GDimension {
			return clone().combine(d);
		}

		/**
		 * return a new bounds with this size with a location.
		 * @param x the location x.
		 * @prame y the location y.
		 * @return the bounds.
		 */
		public function getBounds(x:Number = 0, y:Number = 0):Rectangle {
			return new Rectangle(x, y, width, height);
		}

		/**
		 * Returns whether or not the passing o is an same value NumberDimension.
		 */
		public function equals(o:Object):Boolean {
			var d:GDimension = o as GDimension;
			if (d == null)
				return false;
			return width === d.width && height === d.height;
		}

		/**
		 * Duplicates current instance.
		 * @return copy of the current instance.
		 */
		public function clone():GDimension {
			return new GDimension(width, height);
		}

		/**
		 * Create a big dimension for component.
		 * @return a NumberDimension(100000, 100000)
		 */
		public static function createBigDimension():GDimension {
			return new GDimension(100000, 100000);
		}

		public function toString():String {
			return "[" + width + "," + height + "]";
		}
	}

}
