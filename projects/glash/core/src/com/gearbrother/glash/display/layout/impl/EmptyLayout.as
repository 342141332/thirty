package com.gearbrother.glash.display.layout.impl {
	import com.gearbrother.glash.common.geom.GDimension;
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.container.GContainer;
	import com.gearbrother.glash.display.layout.interfaces.IGLayoutManager;

	/**
	 * LayoutManager's empty implementation.
	 * @author iiley
	 */
	public class EmptyLayout implements IGLayoutManager {
		private var _hasUsed:Boolean;
		public function get hasUsed():Boolean {
			return _hasUsed;
		}
		public function set hasUsed(newValue:Boolean):void {
			_hasUsed ||= newValue;
		}
		
		protected var _children:Array;
		
		public function EmptyLayout() {
			_children = [];
		}

		/**
		 * Do nothing
		 * @inheritDoc
		 */
		public function addLayoutComponent(comp:GNoScale, constraints:Object = null):void {
			if (_children.indexOf(comp) == -1)
				_children.push(comp);
		}

		/**
		 * Do nothing
		 * @inheritDoc
		 */
		public function removeLayoutComponent(comp:GNoScale):void {
			var at:int = _children.indexOf(comp);
			if (at > -1)
				_children.splice(at, 1);
		}

		/**
		 * Simply return target.getSize();
		 */
		public function preferredLayoutSize(target:GContainer):GDimension {
			return new GDimension(target.width, target.height);
		}

		/**
		 * new IntDimension(0, 0);
		 */
		public function minimumLayoutSize(target:GContainer):GDimension {
			return new GDimension(0, 0);
		}

		/**
		 * return IntDimension.createBigDimension();
		 */
		public function maximumLayoutSize(target:GContainer):GDimension {
			return GDimension.createBigDimension();
		}

		/**
		 * do nothing
		 */
		public function layoutContainer(target:GContainer):void {
		}
	}
}
