package com.gearbrother.monsterHunter.flash {
	import com.gearbrother.glash.GMain;
	import com.gearbrother.glash.common.oper.GOperGroupListener;
	import com.gearbrother.glash.common.resource.type.GAliasFile;
	import com.gearbrother.glash.common.resource.type.GFile;
	import com.gearbrother.glash.display.control.GButton;
	import com.gearbrother.glash.display.control.GButtonLite;
	import com.gearbrother.glash.display.layer.GProcessingLayer;
	import com.gearbrother.glash.display.layer.GTipLayer;
	import com.gearbrother.glash.net.GSocketChannel;
	import com.gearbrother.monsterHunter.flash.command.GameCommandMap;
	import com.gearbrother.monsterHunter.flash.component.ButtonBlueSkin;
	import com.gearbrother.monsterHunter.flash.service.DebugServiceImpl;
	import com.gearbrother.monsterHunter.flash.service.IGameService;
	import com.gearbrother.monsterHunter.flash.service.ServiceImpl;
	import com.gearbrother.monsterHunter.flash.view.layer.GuideLayer;
	import com.gearbrother.monsterHunter.flash.view.layer.NoteLayer;
	import com.gearbrother.monsterHunter.flash.view.layer.SceneLayer;
	import com.gearbrother.monsterHunter.flash.view.layer.TipLayer;
	import com.gearbrother.monsterHunter.flash.view.layer.UiLayer;
	
	import flash.net.URLRequest;
	import flash.system.System;

	public class GameMain extends GMain {
		static public var instance:GameMain;

		private var _socket:GSocketChannel;

		public function get socket():GSocketChannel {
			return _socket ||= new GSocketChannel();
		}
		
		private var _sceneLayer:SceneLayer;
		public function get sceneLayer():SceneLayer {
			return _sceneLayer ||= new SceneLayer();
		}

		private var _uiLayer:UiLayer;
		public function get layerUI():UiLayer {
			return _uiLayer ||= new UiLayer();
		}

		private var _guideLayer:GuideLayer;
		public function get guideLayer():GuideLayer {
			return _guideLayer ||= new GuideLayer();
		}

		private var _tiplayer:TipLayer;
		override public function get tipLayer():GTipLayer {
			return _tiplayer ||= new TipLayer();
		}
		
		private var _notelayer:NoteLayer;
		public function get noteLayer():NoteLayer {
			return _notelayer ||= new NoteLayer();
		}
		
		private var _loadingLayer:ProcessingLayer;

		override public function get processingLayer():GProcessingLayer {
			return _loadingLayer ||= new ProcessingLayer();
		}

		private var _apiService:IGameService;

		public function get apiService():IGameService {
			return _apiService;
		}
		
		public function GameMain(config:XML) {
			super(config.id);

			GFile.pathPrefix = config.pathPrefix;
			var libXmls:XMLList = config.libs.lib;
			var listener:GOperGroupListener = new GOperGroupListener();
			for each (var libXml:XML in libXmls) {
				var lib:Object = {name: String(libXml.@name)
					, src: String(libXml.@src)
					, weight: int(libXml.@w)
					, lazy: libXml.@l == "true"
						, language: String(libXml.@lang)};
				GAliasFile.fileInfo[lib.name] = lib;
				if (libXml.@l == false)
					listener.listenOper(pool.getInstance(new GAliasFile(libXml.@src)));
			}
			if (CONFIG::debug)
				_apiService = new DebugServiceImpl();
			else
				_apiService = new ServiceImpl(config.api);
			
			GButtonLite.clickSound = new URLRequest(new GAliasFile("sound/button.mp3").fullPath);
			
			function handleSkinSucc():void {
				listener.stop();
				new GameCommandMap();
			}
			listener.start(handleSkinSucc);
			//install component style
			GButton.DEFAULT_SKIN = ButtonBlueSkin;
			System.disposeXML(config);
			instance = this;
		}

		override protected function initView():void {
			// initialize Scene layer
			addChild(sceneLayer);

			// initialize UI layer
			addChild(layerUI);

//			addChild(monsterBarLayer);

			addChild(windowLayer);

			addChild(alertLayer);
			
			addChild(noteLayer);

			addChild(movieLayer);

			// initialize LOADING layer
			addChild(processingLayer);

			addChild(cursorLayer);

			addChild(tipLayer);

			addChild(guideLayer);
		}
	}
}
import com.gearbrother.glash.GMain;
import com.gearbrother.glash.common.resource.type.GAliasFile;
import com.gearbrother.glash.display.layer.GProcessingLayer;
import com.gearbrother.monsterHunter.flash.GameMain;

class ProcessingLayer extends GProcessingLayer {
	private var _isFirstLoaded:Boolean;

//	private var _fileLoaderView:AssetLoaderView = new AssetLoaderView();
//	
//	private var _serviceLoaderView:DataLoader = new DataLoader();

	override public function tick(interval:int):void {
	/*var oper:GOper;
	if (GMain.instance.filePool.queue.children.length > 0) {
		var childs:Array = GMain.instance.filePool.queue.children;
		for each (oper in GMain.instance.filePool.queue.children) {
			if (oper is IGUiShowLoading && (oper as IGUiShowLoading).showLoading) {	//show GFileLoadOper's Loading
				var loadOper:GFileItem = oper as GFileItem;
				if (!_fileLoaderView.parent)
					addChild(_fileLoaderView);
				return;
			}
		}
	}
	if (GMain.instance.bmdPool.queue.children.length > 0) {
		for each (oper in GMain.instance.bmdPool.queue.children) {
			if (oper is IGUiShowLoading && (oper as IGUiShowLoading).showLoading) {
				//show GFileLoadOper's Loading
				if (!_fileLoaderView.parent)
					addChild(_fileLoaderView);
				return;
			}
		}
	}
	if (GMain.instance.httpQueue.children.length > 0) {
		for each (oper in GMain.instance.httpQueue.children) {
			if (oper is IGUiShowLoading && (oper as IGUiShowLoading).showLoading) {	//show GFileLoadOper's Loading
				if (!_serviceLoaderView.parent)
					addChild(_serviceLoaderView);
				return;
			}
		}
	}*/
	}
}