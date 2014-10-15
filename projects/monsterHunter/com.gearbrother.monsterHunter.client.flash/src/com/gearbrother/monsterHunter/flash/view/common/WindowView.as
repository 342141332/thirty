package com.gearbrother.monsterHunter.flash.view.common {
	import com.gearbrother.glash.display.container.GContainer;
	import com.gearbrother.glash.display.container.GWindow;
	
	import flash.display.DisplayObject;


	/**
	 * @author feng.lee
	 * create on 2013-1-4 下午4:53:56
	 */
	public class WindowView extends GWindow {
		public function WindowView(skin:DisplayObject = null) {
			super(skin);
			
			dragable = false;
		}
	}
}
