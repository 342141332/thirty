package com.gearbrother.glash.display.control {
	import flash.display.DisplayObject;


	/**
	 * @author neozhang
	 * @create on Sep 5, 2013
	 */
	public class GPageStepper extends GNumericStepper {
		public function GPageStepper(skin:DisplayObject = null) {
			super(skin);
			
			label.valueFormater = function(data:Number):String {
				return (data + 1) + "/" + (maxValue + 1);
			};
			label.editable = false;
		}
	}
}
