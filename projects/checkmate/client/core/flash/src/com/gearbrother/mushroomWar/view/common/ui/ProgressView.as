package com.gearbrother.mushroomWar.view.common.ui {
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.GSkinSprite;
	import com.gearbrother.glash.display.control.GProgress;
	import com.gearbrother.glash.display.control.text.GText;
	
	import flash.display.DisplayObject;


	/**
	 *
	 * @author 	Neo.Zhang
	 * @create 	2014-8-29 下午3:19:23
	 *
	 */
	public class ProgressView extends GNoScale {
		public var textLabel:GText;
		
		public var pipe:GProgress;

		override public function set skin(newValue:DisplayObject):void {
			super.skin = newValue;
			
			textLabel = new GText(newValue["textLabel"]);
			pipe = new GProgress(skin["pipe"]);
		}
		
		public function ProgressView(skin:DisplayObject = null) {
			super(skin);
		}
	}
}
