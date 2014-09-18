package {
	import com.gearbrother.glash.display.manager.GFontManager;
	import com.gearbrother.monsterHunter.flash.view.skin.Fonts;

	import flash.display.Sprite;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;


	/**
	 * @author feng.lee
	 * create on 2012-10-9 下午2:44:47
	 */
	public class font extends Sprite {
		//Chalkduster	/*fontStyle="italic", fontWeight="bold", */
		[Embed(source = "IMPACT.TTF", fontName = "_IMPACT", embedAsCFF = "false", unicodeRange = "U+2d, U+0030-U+0039")]
		public var NumberFont:Class;

		[Embed(source = "ERASBD.TTF", fontName = "title", fontWeight = "bold", embedAsCFF = "false", unicodeRange = "U+2d, U+0030-U+0039")]
		public var NumberFont2:Class;

		public function font() {
			super();

			Font.registerFont(NumberFont);
			GFontManager.instance.registerEmbedFont("Impact", Fonts.FONT_POPUP_HP);
		}
	}
}
