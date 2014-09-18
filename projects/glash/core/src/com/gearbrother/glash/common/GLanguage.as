package com.gearbrother.glash.common {
	import com.gearbrother.glash.util.lang.GStringUtils;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.text.TextField;
	
	import org.as3commons.lang.StringUtils;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;

	/**
	 * 多语言支持
	 * @author yi.zhang
	 *
	 */
	public class GLanguage extends EventDispatcher {
		static public const logger:ILogger = getLogger(GLanguage);
		
		static public const instance:GLanguage = new GLanguage();

		/**
		 * 自定义转换器，键为{}内部的文字，值为文字属性或者函数。
		 * 当字符串以#开头时，会将其余部分作为ReflectManager.evel()的参数传入，获得其返回值。
		 * 这样一来，就可以方便地进行扩展。最普通的例子，就是自动转换玩家用户名以及性别的显示。
		 */
		public var customConversion:Object = new Object();

		private var _properies:Object = new Object();

		public function GLanguage():void {
			if (instance)
				throw new Error("call instance");
		}

		/**
		 * 增加多语言文本
		 * 可以用[Embed(source="xxx.properties",mimeType="application/octet-stream"))]这类方式嵌入到SWF中
		 * 加载语言包。properties文件的格式和FLEX的多语言相同，主要为了利用IDE的代码分色。详情请参考FLEX帮助。
		 *
		 * @param textType	类别
		 * @param text	内容
		 *
		 */
		public function register(text:String):void {
			//消除文件头
			if (text.charCodeAt(0) == 65279)
				text = text.slice(1);

			var texts:Array = text.split(/\r?\n/);
			var key:String;
			for (var i:int = 0; i < texts.length; i++) {
				var textLine:String = texts[i] as String;
				if (textLine && textLine.substr(0, 2) != "//") {
					if (/^\S+=.*/.test(textLine)) {
						var pos:int = textLine.indexOf("=");

						key = textLine.slice(0, pos);
						var value:String = textLine.slice(pos + 1);
						if (_properies[key])
							logger.warn("already has language's key \"{0}\"", [key]);
						_properies[key] = value;
					} else if (key && textLine.length > 0) {
						_properies[key] += "\n" + textLine; //没有=则是上一行的继续
					}
				}
			}
		}

		/**
		 * 获得未经转换的多语言文本
		 *
		 * @param res	文本标示，格式为...domainA.domainB.key。
		 * 可以使用继承结构的文字key,例如 dialog.ok.label 系统会查找 dialog.ok.label若找不到则查找 ok.label，如果没有同样继续查找label
		 * 这样做的好处是可以为语言制作模块特殊化.
		 * @return
		 *
		 */
		public function getOriginalString(key:String):String {
			var bundle:Object;
			var result:String;

			//validate
			if (key.charAt(0) == "@")
				key = key.slice(1);
			if (key.charAt(key.length - 1) == "\r")
				key = key.slice(0, key.length - 1);

			var properties:Object = _properies;
			var handleKey:String = key;
			do {
				var content:String = properties[handleKey];
				if (content) {
					return StringUtils.escape(content);
				} else {
					var dotAt:int = handleKey.indexOf(".");
					if (dotAt == -1)
						handleKey = null;
					else
						handleKey = key.slice(dotAt + 1);
				}
			} while (handleKey)
			return key;
		}

		/**
		 * 获得经过转换的文本
		 *
		 * @param res	文本标示，格式为@文件名.标签名
		 * @param parms	替换参数，将会按顺序替换文本里的{0},{1},{2}
		 * @param args 	附加参数，会传到customConversion的函数参数内
		 * @return
		 *
		 */
		public function getValue(key:String, parms:Array = null, args:Array = null):String {
			var result:String = getOriginalString(key);

			if (result == null)
				return null;
			else
				return result.replace(/\{(.+?)\}/g, replaceFun);

			function replaceFun(matchedSubstring:String, capturedMatch:String, index:int, str:String):String {
				var n:Number = parseFloat(capturedMatch);
				if (!isNaN(n)) {
					if (parms && n < parms.length)
						return parms[n];
				} else {
					if (customConversion && customConversion.hasOwnProperty(capturedMatch)) {
						var text:String;
						if (customConversion[capturedMatch] is Function)
							text = (customConversion[capturedMatch] as Function).apply(null, args);
						else
							text = customConversion[capturedMatch];

//						if (text.charAt(0) == "#")
//							text = ReflectUtil.eval(text.slice(1));

						return text;
					} else {
						return getValue(capturedMatch, null, args);
					}
				}
				return capturedMatch;
			}
		}

		/**
		 * example:
		 * 	trace(StringUtils.substitute("${name}: ${say}", {name: "peter", say: "hello"}));
		 * 	output: peter: hello
		 * 
		 * @param str
		 * @param replaceMap
		 * @return 
		 * 
		 */		
		public function getValue2(key:String, values:Object = null):String {
			return GStringUtils.substitute(getOriginalString(key), values || {});
		}
	}
}