package com.gearbrother.glash.display.layout.interfaces {
	import com.gearbrother.glash.common.algorithm.GBoxsGrid;
	import com.gearbrother.glash.common.geom.GDimension;
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.container.GContainer;


	/**
	 *
	 * @author feng.lee
	 *
	 */
	public interface IGLayoutManager {
		/**
		 * Adds the specified component to the layout, using the specified
		 * constraint object.
		 * @param comp the component to be added
		 * @param constraints  where/how the component is added to the layout.
		 */
		function addLayoutComponent(comp:GNoScale, constraints:Object = null):void;

		/**
		 * Removes the specified component from the layout.
		 * @param comp the component to be removed
		 */
		function removeLayoutComponent(comp:GNoScale):void;
		
		/**
		 * has been used for Container 
		 * 
		 */		
		function get hasUsed():Boolean;
		function set hasUsed(newValue:Boolean):void;

		/**
		 * Calculates the preferred size dimensions for the specified
		 * container, given the components it contains.
		 * @param target the container to be laid out
		 *
		 * @see #minimumLayoutSize
		 */
		function preferredLayoutSize(target:GContainer):GDimension;

		/**
		 * Calculates the minimum size dimensions for the specified
		 * container, given the components it contains.
		 * @param target the component to be laid out
		 * @see #preferredLayoutSize
		 */
		function minimumLayoutSize(target:GContainer):GDimension;

		/**
		 * Calculates the maximum size dimensions for the specified container,
		 * given the components it contains.
		 * @param target the component to be laid out
		 * @see #preferredLayoutSize
		 */
		function maximumLayoutSize(target:GContainer):GDimension;

		/**
		 * Lays out the specified container.
		 * @param target the container to be laid out
		 */
		function layoutContainer(target:GContainer):void;
	}
}
