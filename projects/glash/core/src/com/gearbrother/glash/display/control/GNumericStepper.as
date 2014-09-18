package com.gearbrother.glash.display.control {
	import com.gearbrother.glash.display.control.text.GNumeric;
	import com.gearbrother.glash.skin.GNumbericStepperSkin;
	import com.gearbrother.glash.util.display.GSearchUtil;
	
	import flash.display.DisplayObject;
	import flash.events.FocusEvent;
	import flash.text.TextField;


	/**
	 * 数字选择框
	 *
	 * 标签规则：子对象的upArrow,downArrow将被转化为向上和向下的按钮
	 *
	 * @author feng.lee
	 *
	 */
	public class GNumericStepper extends GRange {
		static public var defaultSkin:Class = GNumbericStepperSkin;
		
		public var label:GNumeric;
		
		override public function set maxValue(newValue:Number):void {
			super.maxValue = newValue;
			label.repaint();
		}

		override public function set value(newValue:Number):void {
			super.value = newValue;
			label.text = value;
		}

		public function GNumericStepper(skin:DisplayObject = null) {
			skin ||= new defaultSkin();
			super(skin);

			label = new GNumeric(GSearchUtil.findChildByClass(skin, TextField, 1) as TextField);
			label.addEventListener(FocusEvent.FOCUS_OUT, _handleFocusOut);
			label.multiline = false;
			label.restrict = "/0-9\\-";
			label.valueFormater = function(data:Number):String {
				return data + "/" + maxValue;
			}
			stepSize = 1;
		}

		protected function _handleFocusOut(event:FocusEvent):void {
			value = Number(label.text);
		}
	}
}
