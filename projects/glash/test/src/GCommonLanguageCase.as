package {
	import com.gearbrother.glash.GMain;
	
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	

	/**
	 * 国际化测试
	 * 
	 * @author feng.lee
	 * create on 2012-5-23 下午10:22:02
	 */
	public class GCommonLanguageCase extends GMain {
		[Embed(source="../asset/lang/zh-cn.properties", mimeType="application/octet-stream")]
		public var clazz:Class;
		
		public function GCommonLanguageCase() {
			super();

			language.register(new String(new clazz()));
			trace(language.getValue("ok"));
			trace(language.getValue("module1.ok"));
			trace(language.getValue("bagDialog.ok"));
			trace(language.getValue2("welcome", {name: "李风"}));
		}
	}
}
