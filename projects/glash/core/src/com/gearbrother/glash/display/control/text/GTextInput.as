package com.gearbrother.glash.display.control.text {
	import com.gearbrother.glash.util.lang.GTextUtil;

	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;

	[Event(name = "focus_out", type = "flash.events.FocusEvent")]

	/**
	 * @author feng.lee
	 * create on 2012-12-27 上午10:40:32
	 */
	public class GTextInput extends GText {
		/**
		 * 最大输入限制字数
		 *
		 * @return
		 *
		 */
		public function get maxChars():int {
			return textField.maxChars;
		}

		public function set maxChars(newValue:int):void {
			textField.maxChars = newValue;
		}

		/**
		 * ANSI的最大输入限制字数（中文算两个字）
		 */
		public var maxAnsiChars:int;

		public var restrictRegExp:RegExp;

		public function get editable():Boolean {
			return textField.type == TextFieldType.INPUT;
		}

		public function set editable(newValue:Boolean):void {
			textField.type = newValue ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
			textField.mouseEnabled = newValue;
		}

		private var _isEditing:Boolean;

		public var autoSelect:Boolean;

		public var changeWhenInput:Boolean;

		public var submitByEnter:Boolean;

		public function GTextInput(skin:TextField = null) {
			super(skin);

			//需要设置selectable = true, 不然光标会隐藏
			selectable = editable = true;
			autoSelect = true;
			changeWhenInput = true;
			submitByEnter = true;

			textField.addEventListener(TextEvent.TEXT_INPUT, _handleInputEvent);
			textField.addEventListener(MouseEvent.MOUSE_DOWN, _handleMouseEvent);
			textField.addEventListener(FocusEvent.FOCUS_IN, _handleFocusEvent);
			textField.addEventListener(FocusEvent.FOCUS_OUT, _handleFocusEvent);
			textField.addEventListener(KeyboardEvent.KEY_DOWN, _handleKeyEvent);
		}

		/**
		 * 键入文字事件
		 * @param event
		 *
		 */
		protected function _handleInputEvent(event:TextEvent):void {
			/*var text:String = textField.text;
			var startStr:String = text.slice(0, textField.caretIndex);
			if (startStr)
				startStr +=
			var endStr:String = text.slice(textField.caretIndex + 1, textField.text.length);
			var toText:String = textField.caretIndex*/
			if (restrictRegExp && !restrictRegExp.test(textField.text + event.text))
				event.preventDefault();

			if (maxAnsiChars && GTextUtil.getANSILength(textField.text + event.text) > maxAnsiChars)
				event.preventDefault();
		}

		private function _handleMouseEvent(event:MouseEvent):void {
			switch (event.type) {
				case MouseEvent.MOUSE_DOWN:
					textField.removeEventListener(MouseEvent.MOUSE_DOWN, _handleMouseEvent);
					if (autoSelect)
						textField.setSelection(0, textField.text.length);
					break;
			}
		}

		/**
		 * 文件焦点事件
		 * @param event
		 *
		 */
		protected function _handleFocusEvent(event:FocusEvent):void {
			switch (event.type) {
				case FocusEvent.FOCUS_IN:
					textField.text = text || "";
					textField.addEventListener(Event.CHANGE, _handleChangeEvent);
					_isEditing = true;
					break;
				case FocusEvent.FOCUS_OUT:
					textField.removeEventListener(Event.CHANGE, _handleChangeEvent);
					if (editable)
						accaptText();
					_isEditing = false;
					textField.addEventListener(MouseEvent.MOUSE_DOWN, _handleMouseEvent);
					break;
			}
		}

		private function _handleChangeEvent(event:Event):void {
			if (changeWhenInput && _isEditing)
				text = textField.text;
		}

		protected function _handleKeyEvent(event:KeyboardEvent):void {
			if (submitByEnter && event.keyCode == Keyboard.ENTER)
				stage.focus = null;
		}

		/**
		 * 确认输入框的文本，使data获得新的值，并触发Change
		 *
		 */
		public function accaptText():void {
			text = textField.text;
			repaint();
		}

		override public function paintNow():void {
			if (!_isEditing)
				super.paintNow();
		}
	}
}
