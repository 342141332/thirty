package {
	import com.gearbrother.glash.GMain;
	import com.gearbrother.glash.display.container.GHBox;
	import com.gearbrother.glash.display.control.GButton;
	import com.gearbrother.glash.display.layout.impl.EmptyLayout;
	import com.gearbrother.glash.testcase.skin.AlertSkin;
	import com.gearbrother.glash.util.math.GRandomUtil;
	
	import flash.events.MouseEvent;


	/**
	 * @author feng.lee
	 * create on 2012-11-8 下午8:33:44
	 */
	[SWF(widthPercent = "100", heightPercent = "100", frameRate = "60")]
	public class GDisplayLayerWindowCase extends GMain {
		public var alertBtn:GButton;

		public var windowBtn:GButton;

		public function GDisplayLayerWindowCase() {
			super();

			alertLayer.maskColor = 0x000000;
			alertLayer.maskAlpha = .3;

			var buttonBar:GHBox = new GHBox();
			alertBtn = new GButton();
			alertBtn.text = "open alert";
			buttonBar.addChild(alertBtn);
			windowBtn = new GButton();
			windowBtn.text = "open window";
			buttonBar.addChild(windowBtn);
			buttonBar.width = buttonBar.preferredSize.width;
			buttonBar.height = buttonBar.preferredSize.height;
			rootLayer.layout = new EmptyLayout();
			rootLayer.addChild(buttonBar);
			addEventListener(MouseEvent.CLICK, handleMouseEvent);
		}

		protected function handleMouseEvent(event:MouseEvent):void {
			switch (event.target) {
				case alertBtn:
					new Alert().open();
					break;
				case windowBtn:
					new Win(GRandomUtil.choose([1, 2])).open();
					break;
			}
		}
	}
}

import com.gearbrother.glash.GMain;
import com.gearbrother.glash.display.container.GAlert;
import com.gearbrother.glash.display.container.GWindow;
import com.gearbrother.glash.display.control.GButton;
import com.gearbrother.glash.display.control.text.GText;
import com.gearbrother.glash.testcase.skin.AlertSkin;
import com.gearbrother.glash.testcase.skin.WindowSkin;
import com.gearbrother.glash.util.lang.ArrayUtil;
import com.gearbrother.glash.util.math.GRandomUtil;

import flash.events.MouseEvent;

class Win extends GWindow {
	public var titleLabel:GText;

	public var confirmBtn:GButton;

	private var _neighbourIds:Array;

	public function Win(id:int) {
		super(new WindowSkin);

		titleLabel = new GText(skin["titleLabel"]);
		titleLabel.text = "attachIDs = " + String(_neighbourIds) + ", size = [width = " + width + ", height = " + height + "]";
		confirmBtn = new GButton(skin["confirmBtn"]);
		confirmBtn.text = "change size";
		_neighbourIds = [id];
		addEventListener(MouseEvent.CLICK, handleMouseEvent, false, 0, true);
	}

	protected function handleMouseEvent(event:MouseEvent):void {
		switch (event.target) {
			case confirmBtn:
				this.width = GRandomUtil.integer(100, 400);
				this.height = GRandomUtil.integer(100, 200);
				titleLabel.text = "attachIDs = " + String(_neighbourIds) + ", size = [width = " + width + ", height = " + height + "]";
				revalidateLayout();
				break;
		}
	}

	override public function canBeNeighbour(window:*):Boolean {
		if (ArrayUtil.hasShare(_neighbourIds, (window as Win)._neighbourIds).length > 0)
			return true;
		else
			return false;
	}
}

class Alert extends GAlert {
	public var yesBtn:GButton;

	public var noBtn:GButton;

	public function Alert():void {
		var skin:AlertSkin = new AlertSkin()
		super(skin);

		yesBtn = new GButton(skin.yesBtn);
		yesBtn.text = "yes";
		noBtn = new GButton(skin.noBtn);
		noBtn.text = "no";
	}
}
