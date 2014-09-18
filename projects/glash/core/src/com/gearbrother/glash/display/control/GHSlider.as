package com.gearbrother.glash.display.control {
	import com.gearbrother.glash.skin.GHSilderSkin;
	import com.gearbrother.glash.display.GDisplayConst;
	
	import flash.display.DisplayObject;


	/**
	 * @author feng.lee
	 * create on 2013-1-22
	 */
	public class GHSlider extends GSlider {
		static public var DEFAULT_SKIN:Class = GHSilderSkin;
		
		public function GHSlider(skin:DisplayObject = null) {
			super(GDisplayConst.AXIS_X, skin || new DEFAULT_SKIN());
		}
	}
}
