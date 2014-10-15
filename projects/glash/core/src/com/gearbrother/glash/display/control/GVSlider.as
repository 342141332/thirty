package com.gearbrother.glash.display.control {
	import com.gearbrother.glash.skin.GVSilderSkin;
	import com.gearbrother.glash.display.GDisplayConst;

	import flash.display.DisplayObject;


	/**
	 * @author feng.lee
	 * create on 2013-1-22
	 */
	public class GVSlider extends GSlider {
		static public var DEFAULT_SKIN:Class = GVSilderSkin;

		public function GVSlider(skin:DisplayObject = null) {
			super(GDisplayConst.AXIS_Y, skin || new DEFAULT_SKIN());
		}
	}
}
