package com.gearbrother.mushroomWar {
	import com.gearbrother.glash.common.oper.GOperPool;
	import com.gearbrother.glash.common.oper.ext.GAliasFile;
	import com.gearbrother.glash.debug.FPStatus;
	import com.gearbrother.glash.display.container.GContainer;
	import com.gearbrother.glash.display.layer.GAlertLayer;
	import com.gearbrother.glash.display.layer.GCursorLayer;
	import com.gearbrother.glash.display.layer.GDragLayer;
	import com.gearbrother.glash.display.layer.GMenuLayer;
	import com.gearbrother.glash.display.layer.GMovieLayer;
	import com.gearbrother.glash.display.layer.GProcessingLayer;
	import com.gearbrother.glash.display.layer.GTipLayer;
	import com.gearbrother.glash.display.layer.GWindowLayer;
	import com.gearbrother.glash.display.layout.impl.BorderLayout;
	import com.gearbrother.glash.display.layout.impl.FillLayout;
	import com.gearbrother.glash.display.manager.GPaintManager;
	import com.gearbrother.glash.display.propertyHandler.GPropertyPoolOperHandler;
	import com.gearbrother.glash.manager.RootManager;
	import com.gearbrother.glash.manager.browser.BrowerManager;
	import com.gearbrother.glash.net.GChannelEvent;
	import com.gearbrother.mushroomWar.model.ApplicationModel;
	import com.gearbrother.mushroomWar.model.AvatarModel;
	import com.gearbrother.mushroomWar.model.GameModel;
	import com.gearbrother.mushroomWar.model.ModelRegister;
	import com.gearbrother.mushroomWar.rpc.channel.RpcSocketChannel;
	import com.gearbrother.mushroomWar.rpc.event.RpcEvent;
	import com.gearbrother.mushroomWar.rpc.service.bussiness.AvatarService;
	import com.gearbrother.mushroomWar.rpc.service.bussiness.BattleService;
	import com.gearbrother.mushroomWar.rpc.service.bussiness.RoomService;
	import com.gearbrother.mushroomWar.rpc.service.bussiness.UserService;
	import com.gearbrother.mushroomWar.view.layer.NoteLayer;
	import com.gearbrother.mushroomWar.view.layer.UiLayer;
	import com.gearbrother.mushroomWar.view.layer.scene.LoginSceneView;
	import com.gearbrother.mushroomWar.view.layer.scene.SceneLayer;
	import com.gearbrother.mushroomWar.view.tip.StringTip;
	import com.junkbyte.console.Cc;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.net.LocalConnection;
	import flash.system.Security;
	import flash.system.System;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.LOGGER_FACTORY;
	import org.as3commons.logging.api.getLogger;
	import org.as3commons.logging.setup.LevelTargetSetup;
	import org.as3commons.logging.setup.LogSetupLevel;
	import org.as3commons.logging.setup.target.GFlashConsoleTarget;
	import org.as3commons.logging.setup.target.GTraceTarget;
	import org.as3commons.logging.setup.target.mergeTargets;
	import org.as3commons.logging.util.captureUncaughtErrors;
	
	[SWF(backgroundColor = "0x383934", width = "1000", height = "500", frameRate="60")]
	
	/**
	 * @author neozhang
	 * @create on Sep 30, 2013
	 */
	public class GameMain extends GContainer {
		static public const logger:ILogger = getLogger(GameMain);
		
		static public var instance:GameMain;
		
		private var _id:String;

		private var _scenelayer:SceneLayer;
		public function get scenelayer():SceneLayer {
			return _scenelayer ||= new SceneLayer();
		}
		
		private var _uiLayer:UiLayer;
		public function get uilayer():UiLayer {
			return _uiLayer ||= new UiLayer();
		}
		
		private var _windowLayer:GWindowLayer;
		public function get windowLayer():GWindowLayer {
			return _windowLayer ||= new GWindowLayer();
		}
		
		private var _alertLayer:GAlertLayer;
		public function get alertLayer():GAlertLayer {
			return _alertLayer ||= new GAlertLayer();
		}
		
		private var _notelayer:NoteLayer;
		public function get notelayer():NoteLayer {
			return _notelayer ||= new NoteLayer();
		}
		
		private var _movieLayer:GMovieLayer;
		public function get movieLayer():GMovieLayer {
			return _movieLayer ||= new GMovieLayer();
		}
		
		private var _menuLayer:GMenuLayer;
		public function get menuLayer():GMenuLayer {
			return _menuLayer ||= new GMenuLayer();
		}
		
		private var _processLayer:GProcessingLayer;
		public function get processingLayer():GProcessingLayer {
			return _processLayer ||= new GProcessingLayer();
		}
		
		private var _tipLayer:GTipLayer;
		public function get tipLayer():GTipLayer {
			return _tipLayer ||= new GTipLayer();
		}
		
		private var _dragLayer:GDragLayer;
		public function get dragLayer():GDragLayer {
			return _dragLayer ||= new GDragLayer();
		}
		
		private var _cursorLayer:GCursorLayer;
		public function get cursorLayer():GCursorLayer {
			return _cursorLayer ||= new GCursorLayer();
		}
		
		public var gameChannel:RpcSocketChannel;
		
		public var userService:UserService;
		
		public var avatarService:AvatarService;
		
		public var battleService:BattleService;
		
		public var roomService:RoomService;
		
		private var _filesHandler:GPropertyPoolOperHandler;
		public function get files():Array {
			return _filesHandler ? _filesHandler.value : null;
		}
		public function set files(newValue:Array):void {
			_filesHandler ||= new GPropertyPoolOperHandler(processingLayer, this);
			_filesHandler.succHandler = _handleFiles;
			_filesHandler.value = newValue;
		}
		private function _handleFiles(res:*):void {
			//register models in RpcProcotol
			new ModelRegister();
			
			/*var soilderFile:GAliasFile = pool.getInstance(new GAliasFile("static/conf/explorer/explorer.json")) as GAliasFile;
			ExplorerConf.decodeConfigFile(soilderFile.content as Array);
			
			var toolFile:GAliasFile = pool.getInstance(new GAliasFile("static/conf/tool/tool.json")) as GAliasFile;
			ToolConf.decodeConfigFile(toolFile.content as Array);*/
			
			//			GButtonLite.clickSound = new URLRequest(new GAliasFile("static/sound/button.mp3").fullPath);
			//			new GameCommandMap();
			//install component style
			//GButton.DEFAULT_SKIN = ButtonBlueSkin;
		}

		public function GameMain(config:XML = null) {
			super();
			
			Security.allowDomain("*");
			if (!config) {
				var debugConfig:XML = 
					<app>
						<id>heroland</id>
						<main>main.swf</main>
						<version>DEMO_01</version>
						<debug>
							<level>debug</level>
							<target>
								<trace/>
								<console/>
							</target>
						</debug>
						<locale>zh-cn</locale>
						<api>http://web.beta.com/index.php</api>
						<socketPolicyFile>xmlsocket://localhost:8437</socketPolicyFile>
						<socket>localhost:8438</socket>
						<pathPrefix>http://localhost:8080/</pathPrefix>
						<libs>
							<lib src="bin-debug/font.swf" l="false"/>
						    <!-- 
							<lib src="static/asset/ui/avatar.swf" w="3240" l="false"/>
							<lib src="static/asset/ui/avatar_red.swf" w="3240" l="false"/>
							<lib src="static/asset/ui/ui_main2.swf" w="3240" l="false"/>
							<lib name="sound" src="sound/global.swf" w="3240" l="false"/>
						    <lib name="font" src="conf/zh_cn/font.swf" w="3240" l="false"/>
						    <lib name="lang" src="conf/zh_cn/language.lang" w="3240" l="false"/>
						    <lib name="main_map" src="asset/map/map.swf" w="3240" l="false"/>
						    <lib name="loader.asset" src="asset/widgets/loading3.swf" w="931" l="false"/>
						    <lib name="test1" src="http://down1.ps123.net/2011/chs_hanyi.rar" w="931" l="false"/>
						    <lib name="loader.asset.mini" src="asset/ui/common/loader_asset_mini.swf" w="931" l="false"/>
						    <lib name="loader.data" src="asset/ui/common/loader_data.swf" w="931" l="false"/>
						    <lib name="ui" src="asset/ui/common/ui.swf" w="3274" l="false"/>
						    <lib name="short" src="asset/ui/common/short.swf" w="3274" l="false"/>
						    <lib name="uiCommon" src="asset/ui/common/common.swf" w="3274" l="false"/>
						    <lib name="uiCommonTip" src="asset/ui/common/tip.swf" w="16688" l="false"/>
						    <lib name="uiCommonWidget" src="asset/ui/common/widget.swf" w="16688" l="false"/>
						    <lib name="uiMain" src="asset/ui/ui_main.swf" w="10741" l="false"/>
						    <lib name="uiDialogue" src="asset/ui/uidialogue.swf" w="824554" l="false"/>
						    <lib name="uiChat" src="asset/ui/chat_window2.swf" w="26301" l="false"/>
						    <lib name="uiFriend" src="asset/ui/friend.swf" w="832" l="false"/>
						    <lib name="uiTask" src="asset/ui/ui_task.swf" w="13761" l="false"/>
						    <lib name="uiOpenCard" src="asset/ui/open_card.swf" w="13761" l="false"/>
						    <lib name="database" src="conf/config2.cp" w="13761" l="false"/>
						    
						    <lib name="uiRegister" src="asset/ui/register.swf" w="40451" l="false"/>
						    <lib name="homeland" src="/asset/ui/ui_home.swf" w="13761" l="false"/>
						     -->
						</libs>
					</app>;
				var lastIndex:int = loaderInfo.loaderURL.lastIndexOf("/", loaderInfo.loaderURL.lastIndexOf("/") - 1);
				debugConfig.pathPrefix = loaderInfo.loaderURL.substring(0, lastIndex)/* + "/static"*/;//"http://10.10.2.83:8081/static";
				config = debugConfig;
			}
			
			//debug
			var debugNode:XML = config.debug[0];
			var debugLevel:String = debugNode.level[0].valueOf().toUpperCase();
			var levelSetup:LogSetupLevel;
			switch (debugLevel) {
				case "DEBUG":
					levelSetup = LogSetupLevel.DEBUG;
					break;
				case "INFO":
					levelSetup = LogSetupLevel.INFO;
					break;
				case "WARN":
					levelSetup = LogSetupLevel.WARN;
					break;
				case "ERROR":
					levelSetup = LogSetupLevel.ERROR;
					break;
				default:
					BrowerManager.instance.alert("unknown debug level \"" + debugLevel + "\"");
					break;
			}
			var logTargets:Array = [];
			for each (var targetXml:XML in (debugNode.target[0] as XML).children()) {
				var target:String = (targetXml.name() as QName).localName.toLowerCase();
				switch (target) {
					case "trace":
						logTargets.push(new GTraceTarget("{date} {time} [{logLevel}] [{name}] {message}"));
						break;
					case "console":
						logTargets.push(new GFlashConsoleTarget("{date} {time} [{logLevel}] [{name}] {message}"));
						break;
					default:
						BrowerManager.instance.alert("unknown debug target \"" + target + "\"");
						break;
				}
			}
			LOGGER_FACTORY.setup = new LevelTargetSetup(mergeTargets(logTargets), levelSetup);
			
			//file folder
			GAliasFile.pathPrefix = (config.pathPrefix[0] as XML).valueOf();
			if (logger.debugEnabled) {
				logger.info("GAliasFile.pathPrefix = {0}", [GAliasFile.pathPrefix]);
				BrowerManager.instance.alert(GAliasFile.pathPrefix);
			}
			
			//libs
			var libXmls:XMLList = config.libs.lib;
			var initializedLibs:Array = [];
			for each (var libXml:XML in libXmls) {
				var lib:Object = {
					name: String(libXml.@name)
					, src: String(libXml.@src)
					, weight: int(libXml.@w)
					, lazy: libXml.@l == "true"
					, language: String(libXml.@lang)
				};
				GAliasFile.fileInfo[lib.name] = lib;
				if (libXml.@l == false)
					initializedLibs.push(new GAliasFile(lib.src));
			}
			files = initializedLibs;

			//server info
			var socketPolicyFile:String = (config.socketPolicyFile[0] as XML).valueOf();
			Security.loadPolicyFile(socketPolicyFile);
			gameChannel = new RpcSocketChannel();
			gameChannel.addEventListener(GChannelEvent.CONNECT_SUCCESS, _handleSocketEvent);
			gameChannel.addEventListener(GChannelEvent.CONNECT_CLOSE, _handleSocketEvent);
			gameChannel.addEventListener(RpcEvent.DATA, _handleGameChannelEvent);
			var socket:String = config.socket;
			gameChannel.connect(socket.split(":")[0], socket.split(":")[1]);
			System.disposeXML(config);
			
			//initialize service
			userService = new UserService(gameChannel);
			avatarService = new AvatarService(gameChannel);
			roomService = new RoomService(gameChannel);
			battleService = new BattleService(gameChannel);
			
			//initialize views
			layout = new FillLayout();
			addChild(uilayer);
			uilayer.append(scenelayer, BorderLayout.CENTER);
			addChild(windowLayer);
			addChild(alertLayer);
			addChild(movieLayer);
			addChild(notelayer);
			addChild(dragLayer);
			addChild(cursorLayer);
			addChild(tipLayer);
			tipLayer.getTipView = function(data:*):DisplayObject {
				if (data is AvatarModel) {
					var tip:StringTip = new StringTip();
					tip.bindData = "<font color=\"#92D050\">" + (data as AvatarModel).name + " Lv." + ((data as AvatarModel).level.id + 1) + "</font>\n"
						+ "<font color=\"#ffffff\">" + (data as AvatarModel).describe + "</font>";
					return tip;
				} else {
					return null;
				}
			};
			addChild(processingLayer);
			instance = this;
		}
		
		private function _handleSocketEvent(event:GChannelEvent):void {
			switch (event.type) {
				case GChannelEvent.CONNECT_SUCCESS:
					notelayer.showNode("connect server");
					
					scenelayer.addChild(new LoginSceneView());
					break;
				case GChannelEvent.CONNECT_CLOSE:
					notelayer.showNode("disconnect server");
					break;
			}
		}
		
		private function _handleGameChannelEvent(event:RpcEvent):void {
			if (event.response is ApplicationModel) {
				var application:ApplicationModel = event.response as ApplicationModel;
				application._lastSetTimeMilliseconds = getTimer();
				GameModel.instance.application = application;
			}
		}
		
		override protected function doInit():void {
			super.doInit();
			
			if (logger.debugEnabled) {
				var status:FPStatus = new FPStatus();
				status.x = stage.stageWidth - 100;
				stage.addChild(status);
				
				//initialize FlashConsole
				Cc.startOnStage(stage, "`");
			} else {
				captureUncaughtErrors(loaderInfo); //since flash player 10.2, support caught global error.
			}
			
			RootManager.register(this);
			GPaintManager.instance.stage = stage;
			stage.addEventListener(Event.RESIZE, handleStageResized);
			handleStageResized();
			setInterval(gc, 7700);
		}
		
		public function gc(force:Boolean = false):void {
			GOperPool.instance.clean(force);
			try {
				new LocalConnection().connect(_id);
				new LocalConnection().connect(_id);
			} catch (e:Error) {
				System.gc();
			}
		}
		
		public function handleStageResized(e:Event = null):void {
			width = stage.stageWidth;
			height = stage.stageHeight;
			revalidateLayout();
		}
	}
}
