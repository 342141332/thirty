package com.gearbrother.glash.display.control.text {
	import com.gearbrother.glash.common.geom.GPadding;
	import com.gearbrother.glash.display.GDisplayConst;
	import com.gearbrother.glash.display.GSprite;
	import com.gearbrother.glash.util.display.GTextFieldUtil;
	import com.greensock.TweenLite;
	import com.greensock.easing.Circ;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;


	/**
	 * 数值显示
	 *
	 * 标签规则：和文本框相同
	 *
	 * @author feng.lee
	 *
	 */
	public class GNumeric extends GTextInput {
		/**
		 * 转换文字函数
		 */
		public var textFunction:Function;

		/**
		 * 缓动时间
		 */
		public var duration:int = 1000;

		/**
		 * 附加在数字前的文字
		 * @return
		 *
		 */
		public var prefix:String = "";

		/**
		 * 附加在数字后的文字
		 * @return
		 *
		 */
		public var suffix:String = "";

		/**
		 * 缓动函数
		 */
		public var easing:* = Circ.easeOut;

		/**
		 * 显示变化文字
		 */
		public var showOffestTextNum:int = 0;

		/**
		 * 变化文字间距
		 */
		public var offestTextGap:int = 0;

		/**
		 * 变化文本持续时间
		 */
		public var offestTextShowTime:int = 1000;

		/**
		 * 变化文本字体
		 */
		public var offestTextFormat:TextFormat;

		/**
		 * 变化文本字体2
		 */
		public var offestTextFormat2:TextFormat;

		/**
		 * 变化文本滤镜
		 */
		public var offestTextFilters:Array;

		/**
		 * 是否缩放变化文本
		 */
		public var scaleOffestText:Boolean = false;
		/**
		 * 变化文本方向
		 */
		public var offsetTextDirect:int = GDisplayConst.ALIGN_BOTTOM;

		protected var offestTexts:GSprite;
		protected var offestValues:Array = [];

		/**
		 * 小数点位数
		 */
		public var fix:int = 0;

		private var _minValue:Number;
		public function get minValue():Number {
			return _minValue;
		}
		public function set minValue(value:Number):void {
			_minValue = value;
		}

		private var _maxValue:Number;
		public function get maxValue():Number {
			return _maxValue;
		}
		public function set maxValue(value:Number):void {
			_maxValue = value;
		}

		public function GNumeric(skin:TextField = null, textPadding:GPadding = null) {
			super(skin);
		}

		/**
		 * 确认文本的数据
		 *
		 */
		override public function accaptText():void {
			var value:Number = Number(value);
			if (isNaN(value))
				value = minValue;

			if (isNaN(value))
				value = 0;

			value = Number(value.toFixed(fix));

			if (!isNaN(maxValue) && value > maxValue)
				value = maxValue;

			if (!isNaN(minValue) && value < minValue)
				value = minValue;

			setValue(value, false);

			textField.scrollH = 0;
			textField.scrollV = 0;
		}

		/**
		 * 增加值
		 * @param v
		 * @param tween
		 *
		 */
		public function addValue(v:Number, tween:Boolean = true):void {
			setValue(data + v, tween);
		}

		/**
		 * 设置数值
		 *
		 * @param v
		 * @param tween	是否缓动
		 *
		 */
		public function setValue(v:Number, tween:Boolean = true):void {
			var offest:Number = v - Number(data);

			data = v;

			if (tween && !isNaN(text)) {
				if (offest != 0) {
					if (showOffestTextNum)
						addOffestNum(offest);

					TweenLite.killTweensOf(this);
					TweenLite.to(this, duration, {displayValue: v, ease: easing, onComplete: tweenCompleteHandler})
				}
			} else {
				tweenCompleteHandler();
			}
		}

		private function tweenCompleteHandler():void {
			text = Number(data);
		}

		/**
		 * 增加变化文本
		 *
		 */
		public function addOffestNum(v:Number):void {
			if (showOffestTextNum) {
				offestValues.push(v);
				offestValues = offestValues.slice(Math.max(0, offestValues.length - showOffestTextNum), showOffestTextNum);
			}

			refreshOffestTexts();
			setTimeout(removeOffestNum, offestTextShowTime);
		}

		//删除一个变化文本
		private function removeOffestNum():void {
			offestValues.shift();
			refreshOffestTexts();
		}

		/**
		 * 更新变化文本
		 *
		 */
		public function refreshOffestTexts():void {
			if (!offestTexts) {
				offestTexts = new GSprite();
				addChild(offestTexts);
			}

			offestTexts.removeAllChildren();

			var prevText:TextField; // = labelTextField.textField;
			for (var i:int = 0; i < offestValues.length; i++) {
				var n:TextField = createOffestTexts(prevText, offestValues[i]);
				offestTexts.addChild(n);

				prevText = n;
			}
		}

		protected function createOffestTexts(prevText:TextField, v:int):TextField {
			var n:TextField = GTextFieldUtil.clone(prevText, false);
			n.text = (v >= 0 ? "+" : "") + v.toString();

			if (offsetTextDirect == GDisplayConst.ALIGN_LEFT)
				n.x = prevText.x - n.textWidth - offestTextGap;
			else if (offsetTextDirect == GDisplayConst.ALIGN_RIGHT)
				n.x = prevText.x + prevText.textWidth + offestTextGap;
			else if (offsetTextDirect == GDisplayConst.ALIGN_TOP)
				n.y = prevText.y - n.textHeight - offestTextGap;
			else if (offsetTextDirect == GDisplayConst.ALIGN_BOTTOM)
				n.y = prevText.y + prevText.textHeight + offestTextGap;

			var tf:TextFormat = n.defaultTextFormat;
			if (v < 0 && offestTextFormat2)
				tf = offestTextFormat2;
			else if (offestTextFormat)
				tf = offestTextFormat;

			if (scaleOffestText)
				tf.size = Number(tf.size) * (1 - 1 / (showOffestTextNum + 1));
			n.setTextFormat(tf, 0, n.length);
			n.defaultTextFormat = tf;
			if (offestTextFilters)
				n.filters = offestTextFilters;
			n.cacheAsBitmap = true;
			return n;
		}
	}
}