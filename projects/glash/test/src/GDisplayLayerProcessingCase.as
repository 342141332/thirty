package {
	import com.gearbrother.glash.GMain;
	import com.gearbrother.glash.common.oper.GOper;
	import com.gearbrother.glash.common.oper.GQueue;
	import com.gearbrother.glash.common.oper.ext.GBmdDefinition;
	import com.gearbrother.glash.common.oper.ext.GDefinition;
	import com.gearbrother.glash.common.oper.ext.GFile;
	import com.gearbrother.glash.display.layer.GProcessingLayer;
	import com.gearbrother.glash.display.propertyHandler.GPropertyPoolOperHandler;
	
	import flash.events.MouseEvent;


	/**
	 * 点击加载资源,精度条会自动显示
	 *
	 * @author feng.lee
	 * create on 2012-11-11 上午12:01:06
	 */
	[SWF(width = "600", height = "400", frameRate = "1")]
	public class GDisplayLayerProcessingCase extends GCase {
		private var _libHandler:GPropertyPoolOperHandler;
		public function set libs2(newValue:Array):void {
			_libHandler ||= new GPropertyPoolOperHandler(processingLayer, this);
			_libHandler.succHandler = succHandler;
			_libHandler.processHandler = processHandler;
			_libHandler.value = newValue;
		}
		
		private function succHandler(res:*):void {
			
		}
		
		private function processHandler(res:*):void {
			
		}
		
		private var _processLayer:GProcessingLayer;
		public function get processingLayer():GProcessingLayer {
			return _processLayer ||= new ExampleProcessingLayer(this);
		}
		
		public function GDisplayLayerProcessingCase() {
			super();

			addChild(processingLayer);
			stage.addEventListener(MouseEvent.CLICK, handleMouseEvent);
		}

		private function handleMouseEvent(event:MouseEvent):void {
			var assets:Array = [
				new GFile("https://flash-console.googlecode.com/files/console_2.6.zip", GFile.TYPE_BINARY)
				, new GFile("http://subclipse.tigris.org/files/documents/906/49280/site-1.8.22.zip", GFile.TYPE_BINARY)
				, new GFile("http://mirrors.ustc.edu.cn/eclipse/technology/epp/downloads/release/luna/R/eclipse-jee-luna-R-win32-x86_64.zip", GFile.TYPE_BINARY)
//				, new GBmdDefinition(new GDefinition(new GFile("avatar/5.swf"), "Rest"))
//				, new GBmdDefinition(new GDefinition(new GFile("avatar/5.swf"), "Move"))
//				, new GBmdDefinition(new GDefinition(new GFile("avatar/5.swf"), "Injured"))
//				, new GBmdDefinition(new GDefinition(new GFile("avatar/5.swf"), "Fall"))
//				, new GBmdDefinition(new GDefinition(new GFile("avatar/5.swf"), "Cheer"))
//				, new GBmdDefinition(new GDefinition(new GFile("avatar/5.swf"), "Attack"))
			];
			libs2 = assets;
		}
	}
}

import com.gearbrother.glash.GMain;
import com.gearbrother.glash.common.oper.GOper;
import com.gearbrother.glash.common.oper.ext.GFile;
import com.gearbrother.glash.display.GNoScale;
import com.gearbrother.glash.display.container.GWindow;
import com.gearbrother.glash.display.layer.GProcessingLayer;
import com.gearbrother.glash.display.layer.GWindowLayer;
import com.gearbrother.glash.testcase.skin.DataLoadingSkin;
import com.gearbrother.glash.testcase.skin.PreloaderSkin;
import com.gearbrother.glash.util.lang.GStringUtils;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;
import flash.text.TextField;
import flash.utils.getTimer;

class ExampleProcessingLayer extends GProcessingLayer {
	private var _assetView:AssetLoader;
	private var _httpLoader:HttpLoader;

	public function ExampleProcessingLayer(parent:GCase) {
		super();

		_assetView = new AssetLoader(parent.windowLayer);
		_httpLoader = new HttpLoader(parent.windowLayer);
	}
	
	override protected function _refresh():void {
		super._refresh();
		
		addChild(_assetView);
	}
}

class HttpLoader extends GWindow {
	public var _addedToStageTime:int;

	public var movie:MovieClip;

	public function HttpLoader(container:GWindowLayer) {
		var skin:DataLoadingSkin = new DataLoadingSkin()
		super(container, skin);

		movie = skin.movie;
		enableTick = true;
	}

	override protected function doInit():void {
		super.doInit();

		_addedToStageTime = getTimer();
		visible = false;
	}
	
	override public function tick(interval:int):void {
		var skin:DataLoadingSkin = skin as DataLoadingSkin;
	}
}

class AssetLoader extends GWindow {
	public var currentProgressLabel:TextField;

	public var currentProgress:MovieClip;

	public var totalProgressLabel:TextField;

	public var totalProgress:MovieClip;

	private var _fileOperLength:int = -1;

	private var _bmpOperLength:int = -1;

	public function AssetLoader(container:GWindowLayer) {
		var skin:PreloaderSkin = new PreloaderSkin();
		super(container, skin);

		currentProgressLabel = skin.currentProgressLabel;
		currentProgress = skin.currentProgress;
		currentProgress.gotoAndStop(1);
		totalProgressLabel = skin.totalProgressLabel;
		totalProgress = skin.totalProgress;
		totalProgress.gotoAndStop(1);
		enableTick = true;
	}

	override public function tick(interval:int):void {
		var layer:GProcessingLayer = parent as GProcessingLayer;
		for each (var oper:GFile in layer.opers) {
			if (oper.state == GOper.STATE_RUN && oper.bytesTotal != -1) {
				currentProgressLabel.text = oper.url.url;
				currentProgress.gotoAndStop(int(100 * oper.progress));
				break;
			}
		}
		totalProgressLabel.text = "总进度:" + String(layer.opers.length);
		/*if (skin) {
			if (GMain.instance.bmdQueue.children.length > 0) {
				if (_bmpOperLength == -1)
					_bmpOperLength = GMain.instance.bmdQueue.children.length;
				currentProgressLabel.text = "缓存图形";
				currentProgress.gotoAndStop(0);
				totalProgress.gotoAndStop(int((1 - GMain.instance.bmdQueue.children.length / _bmpOperLength) * 100));
			} else if (GMain.instance.fileQueue.children.length > 0) {
				if (_fileOperLength == -1)
					_fileOperLength = GMain.instance.fileQueue.children.length;
				var oper:GFileOper = GMain.instance.fileQueue.children[0];
				//			var globalRate:int = GMain.instance.filePool.queue.children. / oper.bytesTotal * 100;
				//			totalProgress.gotoAndStop(globalRate);

				var currentItemRate:int = oper.bytesLoaded / oper.bytesTotal * 100;
				currentProgress.gotoAndStop(currentItemRate);
				var str:String = "下载速度${speed}kb/s, 当前进度：${rate}%";
				currentProgressLabel.text = GStringUtils.substitute(str, {speed: GMain.instance.bulkloader.speed, rate: currentItemRate});
				totalProgress.gotoAndStop(int((1 - GMain.instance.fileQueue.children.length / _fileOperLength) * 100));
			} else {
				_bmpOperLength == -1;
				_fileOperLength == -1;
				remove();
			}
		}*/
	}
}
