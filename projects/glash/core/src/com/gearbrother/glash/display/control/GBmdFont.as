package com.gearbrother.glash.display.control {
	import flash.display.BitmapData;
	
	import com.gearbrother.glash.util.display.BitmapCharUtil;

	/**
	 * @author feng.lee
	 * create on 2012-12-26
	 */
	public class GBmdFont {

		/**
		 * 用作字体的BitmapData
		 */
		private var _fontsBmdGrid:BitmapData;
		private var _fontCharRange:String;
		private var _execfontCharRange:String;

		/**
		 * 字体表示的文本范围（0-9,a,U+80FF）
		 */
		public function get fontCharRange():String {
			return _fontCharRange;
		}

		public function set fontCharRange(value:String):void {
			_fontCharRange = value;
			_execfontCharRange = BitmapCharUtil.execCharRange(_fontCharRange);
		}

		/**
		 * 设置图形字体
		 *
		 * @param font	字体位图
		 * @param charRange	包含的字符集（0-9,a,U+80FF）
		 *
		 */
		public function registerFontGridBmd(fontBmdGrid:BitmapData, charRange:String = "0-9"):void {
			_fontsBmdGrid = fontBmdGrid;
			fontCharRange = charRange;
		}

		private var _fontBmdPool:Object;

		/**
		 * register single char's bitmap
		 * @param font
		 * @param char
		 *
		 */
		public function registerFontBmd(font:BitmapData, char:String):void {
			_fontBmdPool ||= {};
			_fontBmdPool[char] = font;
		}

		public function GBmdFont() {
		}
	}
}
