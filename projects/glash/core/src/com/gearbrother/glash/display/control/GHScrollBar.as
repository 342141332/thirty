package com.gearbrother.glash.display.control {
	import com.gearbrother.glash.skin.GHScrollBarSkin;
	import com.gearbrother.glash.display.GDisplayConst;
	
	import flash.display.DisplayObject;


	/**
	 * @author feng.lee
	 * create on 2013-1-24
	 */
	public class GHScrollBar extends GScrollBar {
		static public var defaultSkin:Class = GHScrollBarSkin;
		
		public function GHScrollBar(skin:DisplayObject = null) {
			super(GDisplayConst.AXIS_X, skin ||= new defaultSkin());
		}
	}
}
