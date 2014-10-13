package com.gearbrother.glash.display.control {
	import com.gearbrother.glash.GMain;
	import com.gearbrother.glash.common.GLanguage;
	import com.gearbrother.glash.common.geom.GPadding;
	import com.gearbrother.glash.common.oper.GOperEvent;
	import com.gearbrother.glash.display.control.text.GText;
	import com.gearbrother.glash.skin.GButtonSkin;
	import com.gearbrother.glash.util.display.GMatrixUtil;
	import com.gearbrother.glash.util.display.GSearchUtil;
	
	import flash.display.DisplayObject;
	import flash.display.FrameLabel;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;


	/**
	 * 带有文字的按钮，初始化会根据按钮大小伸缩文字
	 * +-------------+
	 * |	label	 |
	 * +-------------+
	 * 
	 * @author feng.lee
	 * create on 2012-9-27 下午6:26:48
	 */
	public class GButton extends GButtonLite {
		static public var DEFAULT_SKIN:Class = GButtonSkin;
		
		static public const LABEL_UP:String = "up";
		static public const LABEL_OVER:String = "over";
		static public const LABEL_DOWN:String = "down";
		static public const LABEL_DISABLED:String = "disabled";
		static public const LABEL_SELECTED_UP:String = "selectedUp";
		static public const LABEL_SELECTED_OVER:String = "selectedOver";
		static public const LABEL_SELECTED_DOWN:String = "selectedDown";
		static public const LABEL_SELECTED_DISABLED:String = "selectedDisabled";

		static public var defaultLabels:Array = [new FrameLabel("up", 1)
			, new FrameLabel("over", 2)
			, new FrameLabel("down", 3)
			, new FrameLabel("disabled", 4)
			, new FrameLabel("selectedUp", 5)
			, new FrameLabel("selectedOver", 6)
			, new FrameLabel("selectedDown", 7)
			, new FrameLabel("selectedDisabled", 8)
		];

		/**
		 * 是否在必要的时候（资源为多帧，但没有设置Labels）时使用默认Labels
		 */
		public var useDefaultLabels:Boolean = true;
		
		private var _text:String;
		public function get text():String {
			return _text;
		}
		public function set text(newValue:String):void {
			_text = newValue;
			_textfield.text = newValue || "";
		}
		
		protected var _textfield:TextField;

		/**
		 *
		 * @param skin	皮肤
		 *
		 */
		public function GButton(skin:DisplayObject = null) {
			super(skin ||= new DEFAULT_SKIN());

			_textfield = skin["label"];
			if (_textfield)
				GText.applyTextFormat(_textfield);
			_textfield.mouseEnabled = false;
			//custom argus
			if (skin.hasOwnProperty("text")) {
				text = GLanguage.instance.getValue(skin["text"]);
			}
			
			//shift button's matrix to inner
			var bounds:Rectangle = skin.getBounds(skin);
			var innerBounds:Rectangle = _textfield.getBounds(skin);
			//_textfield.border = true;
			_textfield.width = skin.width - innerBounds.left - (bounds.right - innerBounds.right);
			var m:Matrix = GMatrixUtil.getMatrixAt(_textfield, skin);
			m.concat(skin.transform.matrix);
			m.invert();
			m = _textfield.parent.transform.matrix;
			m.concat(_textfield.parent.parent.transform.matrix);
			m.invert();
			var m2:Matrix = new Matrix(1, 0, 0, 1, innerBounds.left + 2, innerBounds.top + 2);
			m2.concat(m);
			_textfield.transform.matrix = m2;
		}
	}
}
