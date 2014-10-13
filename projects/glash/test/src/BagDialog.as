package {
	import com.gearbrother.glash.GMain;

	public class BagDialog extends GMain {
		public function BagDialog() {
			super();
			
			new BagDialog2().open();
		}
	}
}
import com.gearbrother.glash.display.container.GWindow;
import com.gearbrother.glash.display.control.GNumericStepper;
import com.gearbrother.glash.display.control.GRadioButton;
import com.gearbrother.glash.display.control.GSelectGroup;

import flash.display.DisplayObjectContainer;


/**
 * 背包弹出窗口
 * @author neozhang
 *
 */
class BagDialog2 extends GWindow {
	public var allBtn:GRadioButton;
	public var equipBtn:GRadioButton;
	public var toolBtn:GRadioButton;
	public var jewelBtn:GRadioButton;
	public var items:Array;
	public var pageSwitch:GNumericStepper;
	
	public function BagDialog2() {
		super(new BagSkin());
		
		allBtn = new GRadioButton(skin["allBtn"]);
		equipBtn = new GRadioButton(skin["equipBtn"]);
		toolBtn = new GRadioButton(skin["toolBtn"]);
		jewelBtn = new GRadioButton(skin["jewelBtn"]);
		allBtn.group = equipBtn.group = toolBtn.group = jewelBtn.group = new GSelectGroup();
		pageSwitch = new GNumericStepper(skin["pageSwitch"]);
		pageSwitch.minValue = 1;
		pageSwitch.maxValue = 10;
		pageSwitch.value = 1;
	}
}