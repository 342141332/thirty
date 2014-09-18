package {
	import com.gearbrother.glash.GMain;
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.GSkinSprite;
	import com.gearbrother.glash.display.layout.impl.EmptyLayout;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;


	/**
	 * @author feng.lee
	 * create on 2013-1-8
	 */
	[SWF(width = "850", height = "500", frameRate = "60")]
	public class GDisplayLayerTipCase extends GMain {
		public function GDisplayLayerTipCase() {
			super();

			rootLayer.layout = new EmptyLayout();

			tipLayer.getTipView = getTipView;
			var widget:GNoScale;
			widget = new GNoScale();
			widget.graphics.beginFill(0x000000);
			widget.graphics.drawRect(0, 0, 20, 20);
			widget.graphics.endFill();
			widget.x = 350;
			widget.y = 450;
			rootLayer.addChild(widget);
			widget.tipData = "Hello Tip1";
			widget.name = "Hello Tip1";
			
			widget = new GNoScale();
			widget.graphics.beginFill(0x000000);
			widget.graphics.drawRect(0, 0, 20, 20);
			widget.graphics.endFill();
			widget.x = 400;
			widget.y = 450;
			rootLayer.addChild(widget);
			widget.tipData = "Hello Tip1";
			widget.name = "Hello Tip1";

			widget = new GNoScale();
			widget.graphics.beginFill(0x000000);
			widget.graphics.drawRect(0, 0, 20, 20);
			widget.graphics.endFill();
			widget.x = 450;
			widget.y = 450;
			rootLayer.addChild(widget);
			widget.tipData = "Hello Tip2";
			widget.name = "Hello Tip2";

			widget = new GNoScale();
			widget.graphics.beginFill(0x000000);
			widget.graphics.drawRect(0, 0, 10, 10);
			widget.graphics.endFill();
			widget.x = 300;
			widget.y = 50;
			rootLayer.addChild(widget);
			widget.tipData = "Hello Tip3";
			
			widget = new GNoScale();
			widget.graphics.beginFill(0x000000);
			widget.graphics.drawRect(0, 0, 10, 10);
			widget.graphics.endFill();
			widget.x = 500;
			widget.y = 50;
			rootLayer.addChild(widget);
			widget.name = "empty";
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, _handleStageEvent);
		}

		public function getTipView(data:*):DisplayObject {
			if (data is String) {
				var tip:Tip = new Tip();
				tip.text.text = data;
				return tip;
			}
			return null;
		}
		
		private function _handleStageEvent(event:Event):void {
			var menu:Menu = new Menu();
			menu.x = stage.mouseX;
			menu.y = stage.mouseY;
			stage.addChild(menu);
		}
	}
}
import com.gearbrother.glash.display.GSkinSprite;
import com.gearbrother.glash.display.control.GMenu;
import com.gearbrother.glash.display.control.text.GText;
import com.gearbrother.glash.testcase.skin.GTipSkin;

class Tip extends GSkinSprite {
	public var text:GText;

	public function Tip() {
		var tipSkin:GTipSkin = new GTipSkin();
		super(tipSkin);

		text = new GText(tipSkin.label);

	}
}
class Menu extends GMenu {
	public function Menu() {
		super(new GTipSkin());
	}
}