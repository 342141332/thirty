package {
	import com.gearbrother.glash.display.manager.GFontManager;

	import flash.display.Sprite;
	import flash.text.Font;


	/**
	 * @author feng.lee
	 * create on 2013-1-8 下午1:42:15
	 */
	public class GDisplayControlTextFontCase extends Sprite {
		//Chalkduster	/*fontStyle="italic", fontWeight="bold", */
		[Embed(source = "../asset/font/Chalkduster.ttf", fontName = "_Chalkduster", embedAsCFF = "false", unicodeRange = "U+0030-U+0039, U+0041-U+007a, U+002e")]
		public var _Chalkduster:Class;

		[Embed(source = "../asset/font/MSYH.TTF", fontName = "_MSYH", fontWeight = "normal", embedAsCFF = "false", unicodeRange = "U+30-U+39, U+0041-U+007a, U+002e")]
		public var _MSYH:Class;

		[Embed(source = "../asset/font/MSYHBD.TTF", fontName = "_MSYH", fontWeight = "bold", embedAsCFF = "false", unicodeRange = "U+30-U+39, U+0041-U+007a, U+002e")]
		public var _MSYH_BOLD:Class;

		public function GDisplayControlTextFontCase() {
			super();

			Font.registerFont(_Chalkduster);
			Font.registerFont(_MSYH);
//			Font.registerFont(_MSYH_ITALIC);
			Font.registerFont(_MSYH_BOLD);
//			Font.registerFont(_MSYH_BOLD_ITALIC);
			GFontManager.instance.registerEmbedFont("Chalkduster", "_Chalkduster");
			GFontManager.instance.registerEmbedFont("MSYH", "_MSYH");
//			GFontManager.instance.registerEmbedFont("MSYHBD", "_MSYHBD");
		}
	}
}
