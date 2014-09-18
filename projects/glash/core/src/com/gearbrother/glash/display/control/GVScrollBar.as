package com.gearbrother.glash.display.control {
	import com.gearbrother.glash.skin.GVScrollBarSkin;
	import com.gearbrother.glash.display.GDisplayConst;
	
	import flash.display.DisplayObject;


	/**
	 * @author feng.lee
	 * create on 2013-1-24
	 */
	public class GVScrollBar extends GScrollBar {
		static public var defaultSkin:Class = GVScrollBarSkin;
		
		public function GVScrollBar(skin:DisplayObject = null) {
			super(GDisplayConst.AXIS_Y, skin ||= new defaultSkin());
		}
	}
}
