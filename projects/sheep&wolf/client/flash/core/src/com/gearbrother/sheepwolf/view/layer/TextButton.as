package com.gearbrother.sheepwolf.view.layer
{
	import com.gearbrother.glash.display.control.text.GText;
	
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;

	/**
	 *
	 * @author 	Neo.Zhang
	 * @create 	2014-8-13 下午6:08:04
	 *
	 */
	public class TextButton extends GText {
		public function TextButton(text:String) {
			super();
			
			this.text = text;
			fontColor = 0xf0f0f0;
			fontSize = 15;
			filters = [new DropShadowFilter(0, 0, 0x000000, 1, 5, 5, 7)];
			font = "Impact";
		}
	}
}