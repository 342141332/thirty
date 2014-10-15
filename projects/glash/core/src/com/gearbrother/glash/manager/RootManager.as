package com.gearbrother.glash.manager {
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import com.gearbrother.glash.display.manager.GTick;

	/**
	 * 舞台对象相关扩展
	 *
	 * 主要功能为获取flashVars，直接使用getValue方法即可。不同的是，你可以使用setValue来设置parameters的值，模拟flashVars存在时的效果，
	 * 这样就可以在非网页环境进行测试。而当真正的flashVars存在时，与之冲突的设置值都会被忽略。
	 * 这样调试和发布就可以统一处理。
	 *
	 * 也不一定非要和flashVars关系上，你也可以把这里当成一个全局的数据容器
	 *
	 */
	public final class RootManager {
		private static var _root:Sprite;
		private static var _initialized:Boolean = false;

		private static var _parameters:Object = new Object();

		/**
		 * 普通模式
		 */
		static public const MODE_NORMAL:int = 0;
		/**
		 * 无缩放模式
		 */
		static public const MODE_NOSCALE:int = 1;

		/**
		 * 场景对象
		 * @return
		 *
		 */
		static public function get root():Sprite {
			if (!_root)
				throw new Error("请先使用RootManager.register()方法注册舞台");
			return _root;
		}

		static public function set root(v:Sprite):void {
			_root = v;
		}

		/**
		 * 舞台对象
		 * @return
		 *
		 */
		static public var _stage:Stage;
		static public function get stage():Stage {
			return _stage || root.stage;
		}

		/**
		 * 是否已经初始化
		 * @return
		 *
		 */
		static public function get initialized():Boolean {
			return _root != null;
		}

		/**
		 * 注册对象
		 *
		 * @param root	舞台
		 * @param mode	模式
		 * @param menuMode	菜单模式
		 *
		 */
		static public function register(root:Sprite, mode:int = 1, menuMode:int = 1):void {
			_root = root;

			setMode(mode);
			setMenuMode(menuMode);

			stage.stageFocusRect = false;
		}

		/**
		 * 增加一个跳转到URL的菜单项
		 * @param label
		 * @param url
		 *
		 */
		static public function addURLMenu(label:String, url:String = null):void {
			var item:ContextMenuItem = new ContextMenuItem(label);
			if (url)
				item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);

			var menu:ContextMenu = root.contextMenu;
			menu.customItems.push(item);
			root.contextMenu = menu;

			function menuItemSelectHandler(event:ContextMenuEvent):void {
				navigateToURL(new URLRequest(url), "_blank");
			}
		}

		/**
		 * 增加全局错误监听
		 * @param onUncaughtError
		 *
		 */
		static public function addUncaughtErrorListener(onUncaughtError:Function = null):void {
			if (onUncaughtError == null)
				onUncaughtError = function defaultUncaughtError(e:Event):void {
					e.preventDefault();
				};

			if (stage && stage.loaderInfo.hasOwnProperty("uncaughtErrorEvents"))
				stage.loaderInfo["uncaughtErrorEvents"].addEventListener("uncaughtError", onUncaughtError);
		}

		/**
		 * 设置缩放模式
		 * @param mode
		 *
		 */
		static public function setMode(mode:int):void {
			switch (mode) {
				case MODE_NORMAL:
					stage.scaleMode = StageScaleMode.EXACT_FIT;
					stage.align = StageAlign.TOP;
					break;
				case MODE_NOSCALE:
					stage.scaleMode = StageScaleMode.NO_SCALE;
					stage.align = StageAlign.TOP_LEFT;
					break;
			}
		}

		/**
		 * 设置菜单模式
		 * @param mode
		 *
		 */
		static public function setMenuMode(mode:int):void {
			var menu:ContextMenu = new ContextMenu();
			switch (mode) {
				case MODE_NORMAL:
					break;
				case MODE_NOSCALE:
					menu.hideBuiltInItems();
					break;
			}
			root.contextMenu = menu;
		}


		/**
		 * 读取FLASHVARS
		 *
		 * @param key
		 * @return
		 *
		 */
		static public function getValue(key:String):* {
			if (root.loaderInfo.parameters.hasOwnProperty(key))
				return root.loaderInfo.parameters[key];
			else
				return _parameters[key];
		}

		/**
		 * 设置测试用FLASHVARS
		 *
		 * @param key
		 * @param value
		 *
		 */
		static public function setValue(key:String, value:*):void {
			_parameters[key] = value;
		}
	}
}
