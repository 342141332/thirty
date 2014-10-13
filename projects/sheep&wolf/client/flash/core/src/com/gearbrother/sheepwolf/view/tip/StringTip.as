package com.gearbrother.sheepwolf.view.tip {
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.container.GBackgroundContainer;
	import com.gearbrother.glash.display.control.text.GText;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;


	/**
	 * @author lifeng
	 * @create on 2014-1-14
	 */
	public class StringTip extends GBackgroundContainer {
		public function StringTip() {
			var skin:DisplayObjectContainer;
			super(skin = new TipStringSkin());
			
			content = new GText(skin["label"]);
			(content as GText).autoSize = TextFieldAutoSize.LEFT;
			innerRectangle = new Rectangle(content.x, content.y, content.width, content.height);
			outerRectangle = new Rectangle(0, 0, skin.width, skin.height);
		}
		
		override public function handleModelChanged(events:Object=null):void {
			(content as GText).text = bindData;
		}
	}
}
