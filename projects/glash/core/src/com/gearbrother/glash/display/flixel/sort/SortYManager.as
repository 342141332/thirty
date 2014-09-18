package com.gearbrother.glash.display.flixel.sort {
	import com.gearbrother.glash.display.flixel.GPaperLayer;

	/**
	 * 根据对象的y属性排序
	 *
	 */
	public class SortYManager extends SortPriorityManager {
		public function SortYManager(layer:GPaperLayer) {
			super(layer, "y");
		}
	}
}
