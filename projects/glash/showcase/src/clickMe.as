package {
	import com.gearbrother.glash.GMain;
	import com.gearbrother.glash.display.GSkinSprite;
	import com.gearbrother.glash.display.control.GButton;
	import com.gearbrother.glash.display.control.GButtonLite;
	import com.gearbrother.glash.display.control.GHScrollBar;
	import com.gearbrother.glash.display.control.GHSlider;
	import com.gearbrother.glash.display.control.GNumericStepper;
	import com.gearbrother.glash.display.control.GSelectGroup;
	import com.gearbrother.glash.display.control.GVScrollBar;
	import com.gearbrother.glash.display.control.GVSlider;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLRequest;

	[SWF(width = "800", height = "600", frameRate = "60")]

	/**
	 * @author feng.lee
	 * create on 2013-1-28
	 */
	public class clickMe extends GMain {
		private var pane:DisplayObject;

		public function clickMe(id:String = null) {
			super(id);

			var _loader:Loader = new Loader();
			_loader.load(new URLRequest("fla/skin.swf"));
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _handleLoadEvent);
		}

		private function _handleLoadEvent(event:Event):void {
			var skin:DisplayObject = (event.target as LoaderInfo).content;
			var labelButton1:GButtonLite = new GButtonLite(skin["button1"]);
			var labelButton2:GButton = new GButton(skin["button2"]);
//			labelButton2.toggle = true;
			var checkButton1:GButton = new GButton(skin["checkButton1"]);
			var checkButton2:GButton = new GButton(skin["checkButton2"]);
			var radioButton1:GButton = new GButton(skin["radioButton1"]);
			var radioButton2:GButton = new GButton(skin["radioButton2"]);
			var group:GSelectGroup = radioButton1.selectedGroup = radioButton2.selectedGroup = new GSelectGroup();
			group.addEventListener(Event.CHANGE, _handleEvent);
			var numericStepper:GNumericStepper = new GNumericStepper(skin["numericStepper"]);
			var hsilder:GHSlider = new GHSlider(skin["hSilder"]);
			hsilder.width = 170;
			var vsilder:GVSlider = new GVSlider(skin["vSilder"]);
			var hscrollbar:GHScrollBar = new GHScrollBar(skin["hScrollbar"]);
			hscrollbar.width = 100;
			hscrollbar.minValue = 0;
			hscrollbar.maxValue = 100;
			hscrollbar.value = 30;
			var vscrollbar:GVScrollBar = new GVScrollBar(skin["vScrollbar"]);
			vscrollbar.height = 270;
			vscrollbar.minValue = 0;
			vscrollbar.maxValue = 100;
			vscrollbar.value = 30;
			stage.addChild(pane = new GSkinSprite((event.target as LoaderInfo).loader));
		}
		
		private function _handleEvent(event:Event):void {
			trace(event.target);
		}
	}
}