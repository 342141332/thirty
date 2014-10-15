package com.gearbrother.mushroomWar.view.tip {
	import com.gearbrother.glash.common.oper.ext.GAliasFile;
	import com.gearbrother.glash.common.oper.ext.GFile;
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.container.GBackgroundContainer;
	import com.gearbrother.glash.display.control.text.GText;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;


	/**
	 * @author lifeng
	 * @create on 2014-1-14
	 */
	public class StringTip extends GBackgroundContainer {
		public function StringTip() {
			super();

			libs = [new GAliasFile("static/asset/skin/common.swf")];
			/*content = new GText(skin["label"]);
			(content as GText).autoSize = TextFieldAutoSize.LEFT;
			innerRectangle = new Rectangle(content.x, content.y, content.width, content.height);
			outerRectangle = new Rectangle(0, 0, skin.width, skin.height);*/
		}
		
		override protected function _handleLibsSuccess(res:*):void {
			var file:GFile = libsHandler.cachedOper[libs[0]];
			skin = file.getInstance("StringTipSkin");
			if (skin["background"]) {
				outerRectangle = skin["background"].getRect(skin);
				backgroundSkin = skin["background"];
			}
			if (skin["content"]) {
				innerRectangle = (skin["content"] as DisplayObject).getRect(skin);
				var text:GText = new GText(skin["content"]);
				content = text;
				text.fontBold = true;
				text.fontColor = 0xffffff;
				text.filters = [new GlowFilter(0x000000, 1, 3, 3, 300)];
			}
			revalidateBindData();
		}
		
		override public function handleModelChanged(events:Object=null):void {
			if (skin) {
				(content as GText).htmlText = bindData;
			}
		}
	}
}
