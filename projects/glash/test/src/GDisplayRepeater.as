package {
	import com.gearbrother.glash.GMain;
	import com.gearbrother.glash.display.GSprite;
	import com.gearbrother.glash.display.container.GRepeater;
	import com.gearbrother.glash.display.control.GButton;
	import com.gearbrother.glash.display.layout.impl.EmptyLayout;
	import com.gearbrother.glash.display.mouseMode.GDragScrollMode;
	import com.gearbrother.glash.util.display.GColorUtil;
	import com.gearbrother.glash.util.math.GRandomUtil;
	import com.greensock.TweenLite;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;


	[SWF(width="800", height="500")]
	/**
	 * @author feng.lee
	 * create on 2013-2-17
	 */
	public class GDisplayRepeater extends GMain {
		private var _refreshBtn:GButton;
		
		private var _repeater:GRepeater;

		public function GDisplayRepeater() {
			super(id);
			
			rootLayer.addChild(_refreshBtn = new GButton());

			_repeater = new GRepeater(Box, 1000);
			_repeater.width = 700;
			_repeater.height = 100;
			_repeater.x = 50;
			_repeater.y = 100;
			new GDragScrollMode(_repeater);
			rootLayer.layout = new EmptyLayout();
			rootLayer.addChild(_repeater);

			stage.addEventListener(MouseEvent.CLICK, _handleMouseEvent);
		}

		private function _handleMouseEvent(event:MouseEvent):void {
			if (event.target is Box) {
				var pos:Point = _repeater.getItemPosition((event.target as Box).data);
				TweenLite.to(_repeater, 3, {scrollH: pos.x});
			} else if (event.target == _refreshBtn) {
				TweenLite.killTweensOf(_repeater);
				_repeater.scrollH = 0;
				TweenLite.to(_repeater, 1, {scrollH: 100});
				var data:Array = [];
				for (var i:int = GRandomUtil.integer(1, 20); i < 1000; i++) {
					data.push(i);
				}
				_repeater.data = data;
			}
		}
	}
}
import com.gearbrother.glash.common.oper.ext.GFile;
import com.gearbrother.glash.display.GNoScale;
import com.gearbrother.glash.display.GSprite;
import com.gearbrother.glash.display.control.GLoader;
import com.gearbrother.glash.mvc.model.GBean;
import com.gearbrother.glash.util.display.GColorUtil;
import com.gearbrother.glash.util.math.GRandomUtil;

import flash.text.TextField;
import flash.text.TextFieldAutoSize;

class Box extends GNoScale {
	public var label:TextField;

	public var loader:GLoader;
	
	override public function get isLayoutRoot():Boolean {
		return true;
	}
	
	override public function set data(newValue:*):void {
		super.data = newValue;
		
		label.text = String(data);
		var source:Array = ["asset/icon/icon4.jpg", "asset/icon/icon5.jpg", "asset/icon/icon1.jpg", "asset/icon/icon1.png", "asset/icon/icon2.png"];
		loader.source = new GFile(source[data % source.length]);
		//loader.validatePropertiesNow();
		cacheAsBitmap = true;
	}
	
	public function Box() {
		var color:uint = GColorUtil.RYB(GRandomUtil.integer(0, 255), GRandomUtil.integer(0, 255), GRandomUtil.integer(0, 255));
		graphics.beginFill(color);
		graphics.drawRect(0, 0, 100, 100);
		graphics.endFill();
		width = height = 100;

		addChild(label = new TextField());
		label.autoSize = TextFieldAutoSize.LEFT;
		addChild(loader = new GLoader());
		loader.width = GRandomUtil.integer(30, 100);
		loader.height = GRandomUtil.integer(30, 100);
		
		mouseChildren = false;
	}
	
	override protected function doValidateLayout():void {
		loader.x = (width - loader.width) >> 1;
		loader.y = (height - loader.height) >> 1;
		super.doValidateLayout();
	}
}