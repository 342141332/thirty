package com.gearbrother.mushroomWar.view.common.ui {
	import com.gearbrother.glash.display.container.GAlert;
	import com.gearbrother.glash.display.container.GWindow;
	import com.gearbrother.glash.display.control.text.GText;
	import com.gearbrother.mushroomWar.GameMain;
	
	import flash.display.DisplayObject;
	import flash.filters.GlowFilter;


	/**
	 * @author lifeng
	 * @create on 2014-6-18
	 */
	public class TextAlert extends GAlert {
		public function TextAlert(message:String) {
			var text:GText = new GText();
			text.fontBold = true;
			text.fontColor = 0xffffff;
			text.fontSize = 17;
			text.filters = [new GlowFilter(0x000000, 1, 3, 3, 400)];
			text.text = message;
			text.validateLayoutNow();
			text.paintNow();

			super(GameMain.instance.alertLayer, text);
		}
	}
}
