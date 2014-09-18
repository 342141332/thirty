package com.gearbrother.glash.display.control {
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.GSkinSprite;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	[Event(name = "change", type = "flash.events.Event")]

	/**
	 * 范围控件基类
	 * @see com.gearbrother.glash.ui.control.GSilder
	 *
	 * @author feng.lee
	 * create on 2013-1-23
	 */
	public class GRange extends GNoScale {
		/**
		 * 减小按钮
		 */
		public var minButton:GButtonLite;

		/**
		 * 增大按钮
		 */
		public var maxButton:GButtonLite;

		/**
		 * 进度轨迹,通常是滑动条背景
		 */
		public var track:Sprite;

		private var _maxValue:Number;

		public function get maxValue():Number {
			return _maxValue;
		}

		public function set maxValue(newValue:Number):void {
			if (_maxValue != newValue) {
				_maxValue = newValue;
				this.value = isNaN(this.value) ? _maxValue : Math.min(_maxValue, this.value);
				repaint();
			}
		}

		private var _minValue:Number;

		public function get minValue():Number {
			return _minValue;
		}

		public function set minValue(newValue:Number):void {
			if (_minValue != newValue) {
				_minValue = newValue;
				this.value = isNaN(this.value) ? _minValue : Math.max(_minValue, this.value);
				repaint();
			}
		}

		public function get percent():Number {
			if (minValue == _maxValue)
				return 1.0;
			else
				return (_value - minValue) / (_maxValue - minValue);
		}

		public function set percent(newValue:Number):void {
			this.value = minValue + (maxValue - minValue) * newValue;
		}

		private var _value:Number;

		public function get value():Number {
			return _value;
		}

		public function set value(newValue:Number):void {
			if (false == isNaN(minValue) && false == isNaN(maxValue))
				newValue = Math.max(Math.min(newValue, maxValue), minValue);
			if (_value != newValue) {
				_value = newValue;
				dispatchEvent(new Event(Event.CHANGE));
				repaint();
			}
		}

		/**
		 * 滚动速度
		 */
		public var stepSize:int = 5;
		
		override public function set skin(newValue:DisplayObject):void {
			if (newValue && newValue.hasOwnProperty("minButton")) {
				minButton = new GButtonLite(newValue["minButton"]);
				minButton.autoRepeat = true;
				minButton.addEventListener(MouseEvent.CLICK, _handleMouseEvent);
			}
			if (newValue && newValue.hasOwnProperty("maxButton")) {
				maxButton = new GButtonLite(newValue["maxButton"]);
				maxButton.autoRepeat = true;
				maxButton.addEventListener(MouseEvent.CLICK, _handleMouseEvent);
			}

			super.skin = newValue;
		}

		public function GRange(skin:DisplayObject = null) {
			super(skin);
		}

		public function _handleMouseEvent(e:MouseEvent):void {
			switch (e.target) {
				case minButton:
					value -= stepSize;
					break;
				case maxButton:
					value += stepSize;
					break;
			}
		}

		public function scrollToTop():void {
			value = minValue;
		}

		public function scrollToBottom():void {
			value = maxValue;
		}
		
		override public function paintNow():void {
			if (minButton)
				minButton.enabled = value > minValue;
			if (maxButton)
				maxButton.enabled = value < maxValue;
		}
	}
}
