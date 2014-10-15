package {
	import com.gearbrother.glash.display.control.text.GRichText;
	import com.gearbrother.glash.display.manager.GFontManager;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.text.Font;
	import flash.text.TextFormat;


	/**
	 * @author feng.lee
	 * create on 2012-6-12 上午10:57:05
	 */
	[SWF(width = "1000", height = "800")]
	public class GDisplayFontEmbedCase extends GCase {
		public function GDisplayFontEmbedCase() {
		}

		override protected function doInit():void {
			super.doInit();

//			new EnabledSWFScreen(stage);

			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleComplete);
			loader.load(new URLRequest("fonts.swf"));
		}
		
		public function handleComplete(e:Event):void {
			trace(Font.enumerateFonts(true));
			trace("==================");
			trace(Font.enumerateFonts(false));

			GFontManager.instance.registerEmbedFont("Arial", "NumberFont");
			GFontManager.instance.registerStyle("Arial", new TextFormat("NumberFont", 37, 0x000000, true, true, true));
			var text:GRichText = new GRichText();
			stage.addChild(text);
			text.font = "Arial";
			text.text = "12341234123412341234";
		}
	}
}
