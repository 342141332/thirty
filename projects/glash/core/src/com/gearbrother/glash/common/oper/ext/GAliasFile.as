package com.gearbrother.glash.common.oper.ext {
	import br.com.stimuli.loading.BulkLoader;
	
	import com.adobe.net.URI;
	
	import org.as3commons.lang.StringUtils;

	/**
	 * @author neozhang
	 * @create on Jul 5, 2013
	 */
	public class GAliasFile extends GFile {
		static private var _pathPrefix:String;

		static public function set pathPrefix(value:String):void {
			if (StringUtils.endsWith(value, "/")) {
				value = value.substring(0, value.length - 1);
			}
			_pathPrefix = value;
		}

		static public function get pathPrefix():String {
			return _pathPrefix;
		}

		/**
		 * 从资源配置表中获得资源并打上版本号
		 * @param relativeUrl 相对路径,在有版本号的系统中为配置文件的Key
		 * @return
		 *
		 */
		static public function getFullPath(path:String):String {
//			var uri:URI = new URI(path);
//			if (uri.isRelative()) {
				if (StringUtils.startsWith(path, "/"))
					path = path.substr(1, path.length);
				if (_pathPrefix)
					path = _pathPrefix + "/" + path;
				return path;
//			} else {
//				return path;
//			}
		}

		static public const fileInfo:Object = {};

		/**
		 * @param src
		 * @param type It's better to manual type
		 * @return
		 */
		public function GAliasFile(src:String, type:String = null) {
			var lib:Object = fileInfo[src];
			if (lib) {
				src = lib.src;
				var lastDotAt:int = src.lastIndexOf(".");
				if (lib.hasOwnProperty("v"))
					src = src.substring(0, lastDotAt) + "_" + lib.v + src.substring(lastDotAt, src.length);
			}
			src = getFullPath(src);
			super(src, type || BulkLoader.guessType(src));
		}
	}
}
