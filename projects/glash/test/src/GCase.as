package {
	import com.gearbrother.glash.debug.FPStatus;
	import com.gearbrother.glash.display.container.GContainer;
	import com.gearbrother.glash.display.layer.GWindowLayer;
	import com.gearbrother.glash.display.layout.impl.FillLayout;
	import com.gearbrother.glash.display.manager.GPaintManager;
	import com.gearbrother.glash.manager.RootManager;
	import com.junkbyte.console.Cc;
	
	import flash.events.Event;
	
	import org.as3commons.logging.api.LOGGER_FACTORY;
	import org.as3commons.logging.setup.LevelTargetSetup;
	import org.as3commons.logging.setup.LogSetupLevel;
	import org.as3commons.logging.setup.target.GFlashConsoleTarget;
	import org.as3commons.logging.setup.target.GTraceTarget;
	import org.as3commons.logging.setup.target.mergeTargets;
	import org.as3commons.logging.util.captureUncaughtErrors;
	
	public class GCase extends GContainer {
		private var _windowLayer:GWindowLayer;
		public function get windowLayer():GWindowLayer {
			return _windowLayer ||= new GWindowLayer();
		}
		
		public function GCase() {
			super();
			
			layout = new FillLayout();
			addChild(windowLayer);
		}
		
		override protected function doInit():void {
			super.doInit();
			
			LOGGER_FACTORY.setup = new LevelTargetSetup(
				mergeTargets(
					new GTraceTarget("{date} {time} [{logLevel}] [{name}] {message}")
					, new GFlashConsoleTarget("{date} {time} [{logLevel}] [{name}] {message}")
				)
				, LogSetupLevel.DEBUG);
			var status:FPStatus = new FPStatus();
			status.x = stage.stageWidth - 100;
			stage.addChild(status);
			
			//initialize FlashConsole
			Cc.startOnStage(stage, "`");
			
			RootManager.register(this);
			GPaintManager.instance.stage = stage;
			GPaintManager.instance.debug = true;
			stage.addEventListener(Event.RESIZE, handleStageResized);
			handleStageResized();
		}
		
		public function handleStageResized(e:Event = null):void {
			width = stage.stageWidth;
			height = stage.stageHeight;
			revalidateLayout();
		}
	}
}
