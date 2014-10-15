package {
	import com.gearbrother.glash.GMain;
	import com.gearbrother.glash.display.GDisplaySprite;
	import com.gearbrother.glash.display.GSprite;
	import com.gearbrother.glash.mvc.model.GBeanPropertyEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;

	/**
	 * @author feng.lee
	 * create on 2012-10-18 下午7:06:31
	 */
	[SWF(frameRate="60", width="800", height="600")]
	public class GDisplayValidatePerformanceCase extends GMain {
		static public const logger:ILogger = getLogger(GDisplayValidatePerformanceCase);
		
		private function removeChildren(children:Array):void {
			while (children.length) {
				var child:DisplayObject = children.shift();
				child.parent.removeChild(child);
			}
		}
		
		private var child:TestSprite;
		
		public function GDisplayValidatePerformanceCase() {
			super();
			
			var count:int = 10000;
			var i:int;
			var children:Array = [];
			for (i = 0; i < count; i++) {
				children.unshift(stage.addChild(new GDisplaySprite()));
			}
			removeChildren(children);

			var start:int = getTimer();
			for (i = 0; i < count; i++) {
				//				stage.addChild(new Sprite());
				//				rootLayer.addChild(child = new TestSprite);
				children.unshift(stage.addChild(new GDisplaySprite()));
				//				child.graphics.beginFill(GColorUtil.randomColor(), .5);
				//				var w:int = GRandomUtil.integer(100, 200);
				//				var h:int = GRandomUtil.integer(100, 200);
				//				child.graphics.drawRect(0, 0, w, h);
				//				child.graphics.endFill();
				//				child.data = _bean;
			}
			logger.info("/**");
			logger.info(" * {0} GDisplaySprite added to stage cause {1} milliseconds", [count, getTimer() - start]);
			start = getTimer();
			removeChildren(children);
			logger.info(" * {0} GDisplaySprite removed from stage cause {1} milliseconds", [count, getTimer() - start]);
			logger.info(" */");
			
			start = getTimer();
			for (i = 0; i < count; i++) {
				children.unshift(stage.addChild(new Sprite()));
			}
			logger.info("/**");
			logger.info(" * {0} Sprite added to stage cause {1} milliseconds", [count, getTimer() - start]);
			start = getTimer();
			removeChildren(children);
			logger.info(" * {0} Sprite removed from stage cause {1} milliseconds", [count, getTimer() - start]);
			logger.info(" */");

			stage.addChild(child = new TestSprite());
			start = getTimer();
			var _bean:Bean = new Bean();
			child.data = _bean;
			for (i = 0; i < count; i++)
				_bean.id = Math.random().toString();
			logger.info("/**");
			logger.info(" * Bean change {0} cause {1} milliseconds", [count, getTimer() - start]);
			logger.info(" */");
			start = getTimer();
			var eventDispatcher:EventDispatcher = new EventDispatcher();
			for (i = 0; i < count; i++)
				eventDispatcher.dispatchEvent(new Event(Event.CHANGE));
			logger.info("/**");
			logger.info(" * EventDispatcher change {0} cause {1} milliseconds", [count, getTimer() - start]);
			logger.info(" */");
			
			stage.addEventListener(MouseEvent.CLICK, _dispatchEvent);
		}
		
		private function _dispatchEvent(event:Event):void {
			stage.removeEventListener(event.type, _dispatchEvent);
			stage.addEventListener(event.type, _notOnStage);

			var bean:Bean = child.data;
			var count:int = 10000;
			var start:int = getTimer();
			for (var j:int = 0; j < count; j++)
				bean.id = String(j);
			logger.info("Bean change {0} cause {1} milliseconds", [count, getTimer() - start]);
		}
		
		private function _notOnStage(event:Event):void {
			stage.removeEventListener(event.type, _notOnStage);

			child.remove();
			var bean:Bean = child.data;
			var count:int = 10000;
			var start:int = getTimer();
			for (var j:int = 0; j < count; j++)
				bean.id = String(j);
			logger.info("Bean change {0} cause {1} milliseconds", [count, getTimer() - start]);
		}
	}
}
import com.gearbrother.glash.display.GSprite;
import com.gearbrother.glash.mvc.model.GBean;

import flash.display.Sprite;

import org.as3commons.logging.api.ILogger;
import org.as3commons.logging.api.getLogger;

class TestSprite extends GSprite {
	static public const logger:ILogger = getLogger(TestSprite);
	
	override public function handleModelChanged(events:Object=null):void {
		logger.info(">>>>>>>>>>>>>>>>>> handleModelChanged({}) <<<<<<<<<<<<<<<<<<<", events);
	}
}

class Bean extends GBean {
	static public const ID:String = "ID";
	static public const NAME:String = "NAME";
	
	function Bean() {}
	
	public function get id():String {
		return getProperty(ID);
	}
	public function set id(newValue:String):void {
		setProperty(ID, newValue);
	}
	
	public function get name():String {
		return getProperty(NAME);
	}
	public function set name(newValue:String):void {
		setProperty(NAME, newValue);
	}
}
