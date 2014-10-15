package com.gearbrother.glash.display.control.text {
	import com.gearbrother.glash.display.GDisplayConst;
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.container.GContainer;
	import com.gearbrother.glash.display.layout.impl.HorizontalLayout;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.text.TextField;

	[Event(name="change", type="flash.events.Event")]

	/**
	 * 位图字体，可以设置一个位图作为字体，可以对单字使用filter
	 * @author feng.lee
	 *
	 */
	public class GBmdText extends GContainer {
		public const fonts:Object = {};
		
		private var _value:String;

		public function get text():String {
			return _value;
		}

		public function set text(newValue:String):void {
			if (_value != newValue) {
				_value = newValue;
				removeAllChildren();
				for (var i:int = 0; i < _value.length; i++) {
					var char:String = _value.charAt(i);
					var bmd:BitmapData = fonts[char];
					addChild(new GNoScale(new Bitmap(bmd)));
				}
				dispatchEvent(new Event(Event.CHANGE));
			}
		}

		public function GBmdText() {
			super();
			
			layout = new HorizontalLayout(GDisplayConst.ALIGN_BOTTOM, 0);
		}
	}
}
