package {
	import com.gearbrother.glash.GMain;
	import com.gearbrother.glash.display.GSprite;
	import com.gearbrother.glash.display.layout.impl.CenterLayout;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.LOGGER_FACTORY;
	import org.as3commons.logging.api.getLogger;
	import org.as3commons.logging.setup.LevelTargetSetup;
	import org.as3commons.logging.setup.LogSetupLevel;
	import org.as3commons.logging.setup.target.TraceTarget;


	/**
	 * @author feng.lee
	 * create on 2012-11-26 下午5:21:08
	 */
	public class GAvmRenderCase extends Sprite {
		static public const logger:ILogger = getLogger(GAvmRenderCase);
		
		private var _sprite:Example;
		
		private var _timer:Timer = new Timer(15);
		
		public function GAvmRenderCase() {
			super();
			
			LOGGER_FACTORY.setup = new LevelTargetSetup(
				new TraceTarget("{date} {time} [{logLevel}] [{name}] {message}")
				, LogSetupLevel.DEBUG);
			
			var text:TextField = new TextField();
			text.text = "如果看到黑色的方块说明AVM2的Event.RenderEvent事件并不是每次刷新屏幕前都会触发";
			text.autoSize = TextFieldAutoSize.LEFT;
			stage.addChild(text);
			_timer.addEventListener(TimerEvent.TIMER, _handleEvent);
			_timer.start();
			stage.frameRate = 1;
			stage.addEventListener(Event.ENTER_FRAME, _handleEvent);
			stage.addEventListener(Event.RENDER, _handleEvent);
			stage.addEventListener(MouseEvent.CLICK, _handleEvent);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, _handleEvent);
		}
		
		private function _handleEvent(event:Event):void {
			logger.debug(event);
			switch (event.type) {
				case Event.ENTER_FRAME:
					break;
				case Event.RENDER:
					if (_sprite)
						_sprite.remove();
					_sprite = null;
					break;
				case TimerEvent.TIMER:
					if (!_sprite)
						stage.addChild(_sprite = new Example());
					stage.invalidate();
					break;
				case MouseEvent.MOUSE_MOVE:
					return;
					stage.invalidate();
					(event as MouseEvent).updateAfterEvent();
					break;
				case MouseEvent.CLICK:
					if (_sprite) {
						_sprite.remove();
						_sprite = null;
					} else {
						_sprite = new Example();
						stage.addChild(_sprite);
						stage.invalidate();
						logger.debug("---------------------------- add ----------------------------");
					}
					break;
			}
		}
	}
}
import com.gearbrother.glash.display.GNoScale;
import com.gearbrother.glash.display.GSprite;

import flash.display.BitmapData;

class Example extends GNoScale {
	static public const __dirty1:String = "_dirty1";
	
	public function set dirty1(value:Number):void {
		revalidateLayout();
	}
	
	public function Example() {
		super();
		
//		enabledTick = true;
//		dirty1 = Math.random();
		this.graphics.beginFill(0x000000);
		this.graphics.drawRect(0, 0, 100, 100);
		this.graphics.endFill();
		
		/*for (var i:int = 0; i < 100; i++) {
			var bmd:BitmapData = new BitmapData(1000, 1000);
			bmd.draw(this);
			bmd.dispose();
		}*/
	}
	
	override public function tick(interval:int):void {
		trace("tick", interval);
	}
}