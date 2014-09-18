package {
	import com.gearbrother.glash.display.manager.GFontManager;
	import com.gearbrother.mushroomWar.view.font.Fonts;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.Font;


	/**
	 * @author feng.lee
	 * create on 2012-10-9 下午2:44:47
	 */
	public class font extends Sprite {
		//Chalkduster	/*fontStyle="italic", fontWeight="bold", */
		[Embed(source = "../lib/IMPACT.TTF", fontName = "_IMPACT", embedAsCFF = "false", unicodeRange = "U+2d, U+0030-U+0039")]
		public var NumberFont:Class;

		[Embed(source = "../lib/ERASBD.TTF", fontName = "title", fontWeight = "bold", embedAsCFF = "false", unicodeRange = "U+2d, U+0030-U+0039")]
		public var NumberFont2:Class;

		public function font() {
			super();

			Font.registerFont(NumberFont);
//			Fonts.FONT_POPUP_HP = "_IMPACT";
//			GFontManager.instance.registerEmbedFont("Impact", Fonts.FONT_POPUP_HP);
			
			addEventListener(MouseEvent.CLICK, _handleMouseEvent);
		}
		
		private function _handleMouseEvent(event:MouseEvent):void {
			
		}
	}
}
