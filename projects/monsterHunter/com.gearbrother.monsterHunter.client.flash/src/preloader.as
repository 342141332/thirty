package {
	import com.gearbrother.glash.manager.browser.BrowerManager;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.System;
	import flash.text.*;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	[SWF(backgroundColor = 0x9c9c9c, width="1000", height="650")]
	public class preloader extends Sprite {
		static public const MAIN_LOAD_SUCCESS:String = "main:loaded";
		static public const MAIN_LOAD_ERROR:String = "main:load_error";

		static public const LANG_INIT:String = "游戏初始化";
		static public const LANG_ERROR:String = "游戏初始化失败";
		
		[Embed(source="lib.swf", symbol="MCLoading")]
		public var MCLoading:Class;

		public var notice:TextField;
		public var waitMovie:MovieClip;

		public var appXml:XML;

		public function preloader() {
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}

		private function addedToStage(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);

			Security.allowDomain("*");
			stage.tabChildren = false;
			stage.frameRate = 60;
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			notice = new TextField();
			notice.autoSize = TextFieldAutoSize.LEFT;
			notice.text = LANG_INIT;
			notice.textColor = 0xFFFFFF;
			notice.visible = false;
			notice.selectable = false;
			addChild(notice);

			waitMovie = new MCLoading();
			addChild(waitMovie);

			var confLoader:URLLoader = new URLLoader();
			confLoader.addEventListener(Event.COMPLETE, __onLibConfComplete);
			stage.addEventListener(Event.RESIZE, center);
			confLoader.load(new URLRequest(stage.loaderInfo.parameters["conf"] || "app.xml"));
			center();
		}

		private function __onLibConfComplete(e:Event):void {
			var confLoader:URLLoader = e.target as URLLoader;
			confLoader.removeEventListener(e.type, __onLibConfComplete);

			appXml = new XML(confLoader.data);
			var mainLoader:Loader = new Loader();
			mainLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, _onMainLoaded);
			if (CONFIG::debug) {
				BrowerManager.instance.alert(loaderInfo.loaderURL);
				appXml.locale = "zh-cn";
				appXml.api = "http://web.beta.com/index.php";
				var lastIndex:int = loaderInfo.loaderURL.lastIndexOf("/", loaderInfo.loaderURL.lastIndexOf("/") - 1);
				appXml.pathPrefix = loaderInfo.loaderURL.substring(0, lastIndex) + "/static";
				appXml.socket = "192.168.17.33:8087";
				mainLoader.load(new URLRequest("main.swf")/*, new LoaderContext(false, loaderInfo.applicationDomain)*/);
			} else {
				mainLoader.load(new URLRequest(appXml.pathPrefix + appXml.main.@src)/*, new LoaderContext(false, loaderInfo.applicationDomain)*/);
			}

			var contextMenuItem:ContextMenuItem = new ContextMenuItem(appXml.version[0], false);
			contextMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleContextMenuEvent);
			var contextMenu:ContextMenu = new ContextMenu();
			contextMenu.hideBuiltInItems();
			contextMenu.customItems.push(contextMenuItem);
			this.contextMenu = contextMenu;
		}

		private function _onMainLoaded(event:Event):void {
			var mainLoader:LoaderInfo = event.target as LoaderInfo;
			mainLoader.removeEventListener(Event.COMPLETE, _onMainLoaded);

			var mainClazz:Class = mainLoader.content["mainClazz"];
			var main:Sprite = new mainClazz(appXml);
			addChild(main);
			main.addEventListener(MAIN_LOAD_SUCCESS, handleMainEvent);
			main.addEventListener(MAIN_LOAD_ERROR, handleMainError);
			appXml = null;
		}
		
		private function handleMainEvent(event:Event):void {
			switch (event.type) {
				case MAIN_LOAD_SUCCESS:
					notice.parent.removeChild(notice);
					notice = null;
					waitMovie.parent.removeChild(waitMovie);
					waitMovie = null;
					break;
				case MAIN_LOAD_ERROR:
					notice.text = "LOAD ERROR";
					waitMovie.stop();
					break;
			}
			stage.removeEventListener(Event.RESIZE, center);
			var target:IEventDispatcher = event.target as IEventDispatcher;
			target.removeEventListener(MAIN_LOAD_SUCCESS, handleMainEvent);
			target.removeEventListener(MAIN_LOAD_ERROR, handleMainEvent);
		}
		
		private function handleMainError(e:Event):void {
			notice.text = LANG_ERROR;
		}

		private function center(event:Event = null):void {
			notice.x = (stage.stageWidth - notice.width) / 2;
			notice.y = (stage.stageHeight - notice.height) / 2;
			waitMovie.x = (stage.stageWidth - 40) / 2;
			waitMovie.y = notice.y - 40 - 5;
		}
		
		private function handleContextMenuEvent(event:Event):void {
			try {
				System.setClipboard(event.currentTarget["caption"]);
			} catch (e:Error) {}
		}
	}
}
