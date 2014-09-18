package com.gearbrother.glash.util.lang {
	import flash.utils.ByteArray;

	final public class GTextUtil {
		/**
		 * 从右侧截取固定长度字符串
		 *
		 * @param str	字符串
		 * @param len	长度
		 * @return
		 *
		 */
		static public function right(str:String, len:int):String {
			return str.slice(str.length - len);
		}

		/**
		 * 删除两侧空格
		 * @param str
		 * @return
		 *
		 */
		static public function trim(str:String):String {
			return str.replace(/^\s+/, "").replace(/\s+$/, "");
		}

		/**
		 * 忽略掉标签截取特定长度htmlText的文字
		 *
		 * @param htmlText	HTML格式文本
		 * @param startIndex	起始
		 * @param len	长度
		 * @return
		 *
		 */
		static public function subHtmlStr(htmlText:String, startIndex:Number = 0, len:Number = 0x7fffffff):String {
			if ((/<.*?>/).test(htmlText)) {
				var i:int = startIndex;
				var n:int = 0;
				while (n < len && i < htmlText.length) {
					var result:Array = htmlText.substr(i).match(/^<([\/\w]+).*?>/);
					if (result != null) {
						i += result[0].length;
					} else {
						i++;
						n++;
					}
				}
				return htmlText.substr(startIndex, i);
			} else {
				return htmlText.substr(startIndex, len);
			}
		}

		/**
		 * 删除HTML标签
		 *
		 * @param htmlText
		 * @return
		 *
		 */
		static public function removeHTMLTag(htmlText:String):String {
			return htmlText.replace(/<.*?>/g, "");
		}

		/**
		 * 删除所有的\r
		 * @param text
		 *
		 */
		static public function removeR(text:String):String {
			return text.replace(/\r/g, "");
		}

		/**
		 * 删除所有换行
		 * @param text
		 * @return
		 *
		 */
		static public function removeBR(text:String, includeBR:Boolean = true):String {
			return includeBR ? text.replace(/\r|\n|<br>/g, "") : text.replace(/\r|\n/g, "");
		}

		/**
		 * 删除UTF文件头
		 * @param text
		 * @return
		 *
		 */
		static public function removeBOM(text:String):String {
			if (text.charCodeAt(0) == 65279)
				text = text.slice(1);

			return text;
		}

		/**
		 * 在将换行回车转换为标准的\r\n以便文本编辑器可以正常读取
		 * @param text
		 *
		 */
		static public function turnToRN(text:String):String {
			return text.replace(/(?<=[^\r])\n|\r(?=[^\n])/g, "\r\n");
		}

		/**
		 * 在将换行回车转换为\n避免TextField显示为两行
		 * @param text
		 *
		 */
		static public function turnToN(text:String):String {
			return text.replace(/\r\n/g, "\n");
			;
		}



		/**
		 * 插入换行符使得字体可以竖排
		 *
		 * @param str
		 * @return
		 *
		 */
		static public function vertical(str:String):String {
			var result:String = "";
			for (var i:int = 0; i < str.length; i++) {
				result += str.charAt(i);
				if (i < str.length - 1)
					result += "\r";
			}
			return result;
		}

		/**
		 * 获得ANSI长度（中文按两个字符计算）
		 * @param data
		 * @return
		 *
		 */
		static public function getANSILength(data:String):int {
			var byte:ByteArray = new ByteArray();
			byte.writeMultiByte(data, "gb2312");
			return byte.length;
		}

	}
}