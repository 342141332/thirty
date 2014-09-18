package com.gearbrother.glash.display.manager {
	import flash.events.EventDispatcher;
	import flash.text.Font;
	import flash.text.FontStyle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;

	/**
	 * 这个类用于保存字体样式以及帮助嵌入字体。
	 *
	 */
	public class GFontManager extends EventDispatcher {
		static public const instance:GFontManager = new GFontManager;

		private var _styles:Dictionary;

		private var _aliasFontNames:Object;

		public function GFontManager() {
			_styles = new Dictionary();
			_aliasFontNames = {};
		}

		/**
		 * 注册一个字体样式
		 *
		 * @param name	样式名称
		 * @param fontObj	字体属性对象
		 *
		 */
		public function registerStyle(name:String, fontObj:*):void {
			var textFormat:TextFormat;
			if (fontObj is TextFormat)
				textFormat = fontObj as TextFormat;
			else
				textFormat = fontObj;

			_styles[name] = textFormat;
		}

		/**
		 * 获取已注册的字体样式
		 *
		 * @param name	样式名称
		 * @return
		 *
		 */
		public function getTextFormat(name:String):TextFormat {
			return _styles[name];
		}

		public function registerEmbedFont(fontName:String, aliasFontName:String):void {
			_aliasFontNames[fontName] = aliasFontName;
		}

		/**
		 * 嵌入字体时需要注意的是swf中设置好的字体如果需要用全局嵌入字体,需要设置当前文本的字体为嵌入字体的"别名"
		 * 方法中不带参数 fontStyle, italic 所以嵌入的同一字体斜体或是粗体必须要编译在同一个class中
		 * @param fontName
		 * @return
		 * @private
		 *
		 */
		public function getEmbedFontName(sourceFontName:String):String {
			return _aliasFontNames[sourceFontName];
		}

		/**
		 * 按名称获得字体
		 *
		 * @param name	字体名
		 * @param fontStyle	字体类型
		 * @param deviceFont	是否包括设备字体
		 * @return
		 *
		 */
		public function getFontByName(name:String, fontStyle:String = "regular", deviceFont:Boolean = false):Font {
			var arr:Array = Font.enumerateFonts(deviceFont);
			for (var i:int = 0; i < arr.length; i++) {
				var f:Font = arr[i] as Font;
				if (f.fontName == name && f.fontStyle == fontStyle)
					return f;
			}
			return null;
		}

		/**
		 * 从TextFormat中获得字体类型
		 *
		 * @param textFormat
		 * @return
		 *
		 */
		public function getFontStyle(textFormat:TextFormat):String {
			var bold:Boolean = textFormat.bold;
			var italic:Boolean = textFormat.italic;
			if (bold && italic)
				return FontStyle.BOLD_ITALIC;
			else if (bold)
				return FontStyle.BOLD;
			else if (italic)
				return FontStyle.ITALIC;
			else
				return FontStyle.REGULAR;

			return null;
		}

		/**
		 * 判断文本的字体是否已经嵌入
		 *
		 * @param text
		 *
		 */
		public function isEmbed(text:String, textFormat:TextFormat):Boolean {
			var font:Font = getFontByName(textFormat.font, getFontStyle(textFormat), false);
			return font && font.hasGlyphs(text)
		}

		/**
		 * 根据字体嵌入情况自动设置文本框的embedFonts属性，仅适用于使用defaultTextFormat的情况
		 * @param text
		 *
		 */
		public function autoEmbedFonts(textField:TextField):void {
			textField.embedFonts = isEmbed(textField.text, textField.defaultTextFormat);
		}
	}
}