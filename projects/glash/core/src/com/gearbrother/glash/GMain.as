package com.gearbrother.glash {
	import com.gearbrother.glash.common.oper.GOperPool;
	import com.gearbrother.glash.display.container.GContainer;
	import com.gearbrother.glash.display.layer.GAlertLayer;
	import com.gearbrother.glash.display.layer.GCursorLayer;
	import com.gearbrother.glash.display.layer.GDragLayer;
	import com.gearbrother.glash.display.layer.GMenuLayer;
	import com.gearbrother.glash.display.layer.GMovieLayer;
	import com.gearbrother.glash.display.layer.GProcessingLayer;
	import com.gearbrother.glash.display.layer.GTipLayer;
	import com.gearbrother.glash.display.layer.GWindowLayer;
	import com.gearbrother.glash.display.layout.impl.CenterLayout;
	import com.gearbrother.glash.display.layout.impl.FillLayout;
	import com.gearbrother.glash.display.manager.GPaintManager;
	import com.gearbrother.glash.manager.RootManager;
	
	import flash.events.Event;
	import flash.net.LocalConnection;
	import flash.system.System;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.LOGGER_FACTORY;
	import org.as3commons.logging.api.getLogger;
	import org.as3commons.logging.setup.LevelTargetSetup;
	import org.as3commons.logging.setup.LogSetupLevel;
	import org.as3commons.logging.setup.target.GFlashConsoleTarget;
	import org.as3commons.logging.setup.target.GTraceTarget;
	import org.as3commons.logging.setup.target.mergeTargets;

	/**
	 * @author feng.lee
	 * create on 2012-8-22 下午7:43:55
	 */
	public class GMain extends GContainer {
		static public const logger:ILogger = getLogger(GMain);
		
		private var _id:String;

		private var _rootLayer:GContainer;
		public function get rootLayer():GContainer {
			return _rootLayer ||= new GContainer();
		}

		private var _windowLayer:GWindowLayer;
		public function get windowLayer():GWindowLayer {
			return _windowLayer ||= new GWindowLayer();
		}

		private var _alertLayer:GAlertLayer;
		public function get alertLayer():GAlertLayer {
			return _alertLayer ||= new GAlertLayer();
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
		
		public function GMain(id:String = null) {
			super();

//			TweenPlugin.activate([FramePlugin, FrameLabelPlugin, AutoAlphaPlugin, TransformAroundCenterPlugin, ColorTransformPlugin, ColorMatrixFilterPlugin, GShakePlugin, BlurFilterPlugin]);
			//initialize log strategy
			LOGGER_FACTORY.setup = new LevelTargetSetup(
				mergeTargets(
					new GTraceTarget("{date} {time} [{logLevel}] [{name}] {message}")
					, new GFlashConsoleTarget("{date} {time} [{logLevel}] [{name}] {message}")
				)
				, LogSetupLevel.DEBUG);

			//当主文件加载后INIT会在构造函数后派发，但实际上stage已经存在，后续逻辑都是依赖于获取stage所以人为初始化stage所有逻辑
//			if (stage)
//				dispatchEvent(new Event(Event.ADDED_TO_STAGE));

			_id = id;
			mouseEnabled = false;
			layout = new FillLayout();
			rootLayer.layout = new CenterLayout();
			addChild(rootLayer);
			/*
			// initialize POPUP layer
			addChild(windowLayer);
			addChild(dragLayer);
			// initialize TIP layer
			addChild(tipLayer);
			addChild(cursorLayer);
			// initialize CONFIRM layer
			addChild(alertLayer);
			addChild(movieLayer);
			// initialize LOADING layer
			addChild(processingLayer);
			*/
		}

		override protected function doInit():void {
			super.doInit();
			
			RootManager.register(this);
			GPaintManager.instance.stage = stage;
			stage.addEventListener(Event.RESIZE, handleStageResized);
			handleStageResized();
			//setInterval(gc, 7700);
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
