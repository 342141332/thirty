package {
	import com.gearbrother.glash.GMain;
	import com.gearbrother.glash.display.container.GContainer;
	import com.gearbrother.glash.display.control.text.GText;
	import com.gearbrother.glash.display.manager.GFontManager;
	import com.gearbrother.glash.util.display.GColorUtil;
	import com.gearbrother.glash.util.math.GRandomUtil;
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Sine;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;


	/**
	 * @author feng.lee
	 * @create on 2013-4-2
	 */
	[SWF(width = "1000", height = "800", frameRate="60")]
	public class GDisplayFontBoomCase extends GMain {
		[Embed(source = "../asset/font/Chalkduster.ttf", fontName = "MyFont", unicodeRange = "U+0020-U+007e", embedAsCFF = "false")]
		public var fontClazz:Class;

		public function GDisplayFontBoomCase(id:String = null, skin:DisplayObject = null, owner:GContainer = null) {
			super(id, skin, owner);
			
			GFontManager.instance.registerEmbedFont("Arial Black", "MyFont");
			stage.addEventListener(MouseEvent.CLICK, _handleMouseEvent);
		}
		
		private function _handleMouseEvent(event:MouseEvent):void {
			switch (event.type) {
				case MouseEvent.CLICK:
					for (var i:int = 0; i < 1; i++) {
						var text:GText = new GText();
						text.font = "MyFont";
						text.cacheAsBitmap = true;
						text.text = "try.. + 1";
						text.fontColor = GColorUtil.RYB(GRandomUtil.integer(0, 255), GRandomUtil.integer(0, 255), GRandomUtil.integer(0, 255));
						text.textField.rotation = 90;
						text.textField.filters = [new GlowFilter(0x333333, 1, 3, 3, 100)];
						text.x = text.y = 400;
						stage.addChild(text);
						TweenMax.to(text
							, 3 + GRandomUtil.number(-1, 1)
							, {bezier:[{x:400, y:300}, {x:400 + GRandomUtil.integer(-150, 150), y:100 + GRandomUtil.integer(-50, 50)}], orientToBezier:true, ease:Sine.easeOut});
//						TweenMax.to(text, 3.75, {alpha: .0, ease:Cubic.easeOut});
					}
					break;
			}
		}
	}
}
