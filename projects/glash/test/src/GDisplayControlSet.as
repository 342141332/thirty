package {
	import com.gearbrother.glash.GMain;
	import com.gearbrother.glash.display.GDisplayConst;
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.GSkinSprite;
	import com.gearbrother.glash.display.GSprite;
	import com.gearbrother.glash.display.container.GBackgroundContainer;
	import com.gearbrother.glash.display.container.GContainer;
	import com.gearbrother.glash.display.control.GBackground;
	import com.gearbrother.glash.display.layout.impl.EmptyLayout;
	import com.gearbrother.glash.display.layout.impl.FlowLayout;
	import com.gearbrother.glash.display.layout.impl.GridLayout;
	import com.gearbrother.glash.display.layout.impl.HorizontalLayout;
	import com.gearbrother.glash.testcase.skin.GTipSkin;
	
	import flash.events.MouseEvent;


	/**
	 * @author feng.lee
	 * create on 2012-9-28 上午11:46:55
	 */
	[SWF(width = "800", height = "500", frameRate = "60")]
	public class GDisplayControlSet extends GMain {
		private	var background:GBackgroundContainer;

		private var content:GContainer;

		public function GDisplayControlSet() {
			super();

			var skin:GTipSkin = new GTipSkin();
			background = new GBackgroundContainer();
			background.outerRectangle = skin.getRect(skin);
			background.innerRectangle = skin.content.getBounds(skin);
			background.width = background.height = 200;
			var bg:GBackground = new GBackground(skin.background);
			bg.parent.removeChild(bg);
			background.background = bg;
			content = new GContainer();
			content.layout = new GridLayout(0, 1, 5, 5);
			background.content = content;
			stage.addEventListener(MouseEvent.CLICK, _handleMouseEvent);
			rootLayer.layout = new HorizontalLayout(GDisplayConst.ALIGN_BOTTOM);
			rootLayer.addChild(background);
		}
		
		private function _handleMouseEvent(event:MouseEvent):void {
			var row:GNoScale = new GNoScale;
			row.graphics.beginFill(0x0000FF);
			row.graphics.drawRect(0, 0, 80, 30);
			row.graphics.endFill();
			row.width = 80;
			row.height = 30;
			content.addChild(row);
//			background.width = background.preferredSize.width;
//			background.height = background.preferredSize.height;
//			background.validateLayoutNow();
		}
	}
}
import com.gearbrother.glash.common.oper.ext.GFile;
import com.gearbrother.glash.display.GNoScale;
import com.gearbrother.glash.display.container.GContainer;
import com.gearbrother.glash.display.control.GButton;
import com.gearbrother.glash.display.control.GCheckBox;
import com.gearbrother.glash.display.control.GHScrollBar;
import com.gearbrother.glash.display.control.GHSlider;
import com.gearbrother.glash.display.control.GLoader;
import com.gearbrother.glash.display.control.GNumericStepper;
import com.gearbrother.glash.display.control.GRadioButton;
import com.gearbrother.glash.display.control.GSelectGroup;
import com.gearbrother.glash.display.control.GVScrollBar;
import com.gearbrother.glash.display.control.GVSlider;
import com.gearbrother.glash.display.control.text.GTextInput;
import com.gearbrother.glash.display.layout.impl.FlowLayout;
import com.gearbrother.glash.display.mouseMode.GDragScrollMode;

import flash.events.Event;
import flash.events.MouseEvent;

class ControlsPane extends GContainer {
	public function ControlsPane() {
		super();

		layout = new FlowLayout();

		var button:GButton = new GButton();
		addChild(button);

		var checkBox:GCheckBox = new GCheckBox();
		checkBox.addEventListener(Event.CHANGE, _onChange);
		addChild(checkBox);

		var radioBtn1:GRadioButton = new GRadioButton();
		addChild(radioBtn1);
		var radioBtn2:GRadioButton = new GRadioButton();
		addChild(radioBtn2);
		var radioBtn3:GRadioButton = new GRadioButton();
		addChild(radioBtn3);
		var group:GSelectGroup = radioBtn1.group = radioBtn2.group = radioBtn3.group = new GSelectGroup();
		group.addEventListener(Event.CHANGE, _onChange);

		var numeric:GNumericStepper = new GNumericStepper();
		numeric.maxValue = 99;
		numeric.minValue = 1;
		addChild(numeric);
		numeric.addEventListener(Event.CHANGE, _onChange);

		var hSilder:GHSlider = new GHSlider();
		hSilder.maxValue = 100;
		hSilder.minValue = 1;
		hSilder.value = 50;
		hSilder.width = 150;
		addChild(hSilder);
		hSilder.addEventListener(Event.CHANGE, _onChange);

		var vSilder:GVSlider = new GVSlider();
		vSilder.maxValue = 100;
		vSilder.minValue = 1;
		vSilder.value = 50;
		vSilder.height = 150;
		addChild(vSilder);
		vSilder.addEventListener(Event.CHANGE, _onChange);

		var hScroll:GHScrollBar = new GHScrollBar();
		hScroll.minValue = 1;
		hScroll.maxValue = 100;
		hScroll.value = 30;
		hScroll.width = 150;
		addChild(hScroll);
		hScroll.addEventListener(Event.CHANGE, _onChange);

		var vScroll:GVScrollBar = new GVScrollBar();
		vScroll.minValue = 1;
		vScroll.maxValue = 100;
		vScroll.value = 30;
		vScroll.height = 150;
		addChild(vScroll);
		vScroll.addEventListener(Event.CHANGE, _onChange);
	}

	private function _onChange(event:Event):void {
		trace(event.target, event);
	}
}

class ScrollPane extends GNoScale {
	public var textarea:GTextInput;

	public var hScrollbar:GHScrollBar;

	public var vScrollbar:GVScrollBar;
	
	public var loader:GLoader;
	
	public var loaderHScrollbar:GHScrollBar;
	
	public var loaderVScrollbar:GVScrollBar;

	public function ScrollPane() {
		var tabPane:ScrollTabPane = new ScrollTabPane();
		super(tabPane);

		/*textarea = new GTextInput(tabPane.textarea);
		hScrollbar = new GHScrollBar(tabPane.hScrollbar);
		hScrollbar.width = textarea.width;
		hScrollbar.scrollTarget = textarea;
		vScrollbar = new GVScrollBar(tabPane.vScrollbar);
		vScrollbar.height = textarea.height;
		vScrollbar.scrollTarget = textarea;*/
		
		loader = new GLoader();
		loader.source = new GFile("http://a3.att.hudong.com/57/47/19300001203883132135478240652.jpg");
		loaderHScrollbar = new GHScrollBar(tabPane.loaderHScrollbar);
		loaderHScrollbar.width = tabPane.loader.width;
		loaderVScrollbar = new GVScrollBar(tabPane.loaderVScrollbar);
		loaderVScrollbar.height = tabPane.loader.height;
		var scrollPane:GContainer = new GContainer();
		scrollPane.width = tabPane.loader.width;
		scrollPane.height = tabPane.loader.height;
		scrollPane.addChild(loader);
		scrollPane.replace(tabPane.loader);
		loaderHScrollbar.scrollTarget = loaderVScrollbar.scrollTarget = scrollPane;
		new GDragScrollMode(scrollPane);
		addEventListener(MouseEvent.CLICK, _handleMouseEvent);
	}
	
	private function _handleMouseEvent(event:Event):void {
		loader.stage;
	}
}
