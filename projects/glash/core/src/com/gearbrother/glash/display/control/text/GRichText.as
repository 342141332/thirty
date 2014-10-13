package com.gearbrother.glash.display.control.text {
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.control.text.GText;
	import com.gearbrother.glash.util.display.GTextFieldUtil;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BitmapFilter;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;


	/**
	 * 打碎文字转换为单个位图，可把文字当成位图处理
	 * 缺点：内存使用过于频繁
	 * 
	 * @author feng.lee
	 *
	 */
	public class GRichText extends GText {
		static public const textTweenScroll:Function = function(items:Array):void {
			var duration:Number = .5;
			for (var i:int = 0; i < items.length; i++) {
				var item:DisplayObject = items[i];
				item.alpha = .0;
				TweenMax.fromTo(items[i], duration, {x: item.x - 20}, {alpha: 1.0, x: item.x, rotation: 360 /*transformAroundCenter: {}*/, delay: duration * i * .5});
			}
		};

		static public const textTweenAlpha:Function = function(items:Array):void {
			var duration:Number = .5;
			for (var i:int = 0; i < items.length; i++) {
				var item:DisplayObject = items[i];
				item.alpha = .0;
				TweenLite.to(items[i], duration, {alpha: 1.0, delay: duration * i * .5});
			}
		};

		private var _textRender:GTextRender;

		/**
		 * 绘制text底纹
		 */
		public function get textRender():GTextRender {
			return _textRender;
		}

		public function set textRender(newValue:GTextRender):void {
			if (_textRender != newValue) {
				_textRender = newValue;
				repaint();
			}
		}

		private var _tween:Function;

		public function get tween():Function {
			return _tween;
		}

		public function set tween(newValue:Function):void {
			if (_tween != newValue) {
				_tween = newValue;
				repaint();
			}
		}

		private var _textCanvas:Sprite;

		private var _textRenderLayer:Shape;

		/**
		 * 打散的文字实例
		 */
		protected var _separatedChars:Array;

		/*override public function get tipData():* {
			if (_partTipDatas) {
				var mouseAt:int = textField.getCharIndexAtPoint(textField.mouseX, textField.mouseY);
				for each (var partTip:TextTipData in _partTipDatas) {
					if (partTip.beginIndex > mouseAt && partTip.endIndex > mouseAt)
						return partTip;
				}
				return super.tipData;
			} else {
				return super.tipData;
			}
		}*/

		public function GRichText(skin:TextField = null) {
			super(skin);

			this.skin.parent.removeChild(this.skin);
			_separatedChars = [];
			mouseChildren = false;
		}

		/**
		 * 设置文本框大小
		 * @param w
		 * @param h
		 *
		 */
		public function setTextFieldSize(w:Number = NaN, h:Number = NaN, autoSize:String = TextFieldAutoSize.NONE):void {
			if (textField) {
				textField.autoSize = autoSize;

				if (!isNaN(w))
					textField.width = w;

				if (!isNaN(h))
					textField.height = h;
			}
		}

		/**
		 * 根据文本框大小设置文本字体
		 * @param adjustY	自动调整文本框的y值
		 * @param resetY	每次调整都将y设回0（否则重复设置data并调整大小会出问题）
		 *
		 */
		public function autoFontSize(adjustY:Boolean = false, resetY:Boolean = false):void {
			GTextFieldUtil.autoFontSize(textField, adjustY, resetY);
		}

		override public function paintNow():void {
			super.paintNow();

			/*if (textRender) {
				//由于BlendMode只应用于BITMAP带ALPHA通道
				//,所以在textfield.embedfonts == false的时候,使用设备字体,系统默认使用点象素的方式展现字体,内存表现为位图,适用BlendMode.ALPHA
				//,但是当TextField.embedfonts == true时,字体内存表现为flash显示对象, 便不可使用BlendMode,只能使用mask了
				//,所以为了统一转换为BitmapData
				textRender.render(_textRenderLayer, textField);
				textField.blendMode = BlendMode.ALPHA;
				_textCanvas.blendMode = BlendMode.LAYER;
				textField.cacheAsBitmap = true;
			} else {
				textField.blendMode = BlendMode.NORMAL;
				_textCanvas.blendMode = BlendMode.NORMAL;
				textField.cacheAsBitmap = false;
			}*/
			if (textRender) {
				if (!_textCanvas) {
					_textCanvas = new Sprite();
					_textCanvas.addChild(_textRenderLayer = new Shape());
				}
				_textRenderLayer.graphics.clear();
				textRender.render(_textRenderLayer, textField);
				_textCanvas.blendMode = BlendMode.LAYER;
			}

			destoryAllChars();
			//seperate all chars
			var gap:int = 0;
			for (var i:int = 0; i < textField.text.length; i++) {
				var charText:TextField = GTextFieldUtil.getTextFieldAtIndex(textField, i);
				if (charText.textWidth == 0 || charText.textWidth == 0)
					continue;

				charText.appendText(" ");	//在某些字体下单个字母会显示的不全，这是avm的bug所以在后面加上一个空格
//				addChild(charText);
				var charBmp:Bitmap = new Bitmap(new BitmapData(charText.textWidth, charText.textHeight, true, 0x00000000));
				charBmp.bitmapData.draw(charText, new Matrix(1, 0, 0, 1));
				charBmp.x = charText.x;
				charBmp.y = charText.y;
				if (_textCanvas) {
					charBmp.blendMode = BlendMode.ALPHA;
					if (_textCanvas.numChildren > 1) {
						_textCanvas.removeChildAt(1);
					}
					_textCanvas.addChild(charBmp);
					var renderedCharBmp:Bitmap = new Bitmap(new BitmapData(charBmp.width, charBmp.height, true, 0x00000000));
					renderedCharBmp.bitmapData.draw(_textCanvas, new Matrix(1, 0, 0, 1, -charBmp.x, -charBmp.y));
					renderedCharBmp.x = charBmp.x;
					renderedCharBmp.y = charBmp.y;
					charBmp.bitmapData.dispose();
					charBmp = renderedCharBmp;
				}
				_separatedChars.push(addChild(charBmp));
			}
			if (tween != null)
				tween(_separatedChars);
			/*for each (var separatedText:DisplayObject in _separateTexts)
				separatedText.filters = [];
			for each (var textFilter:Array in textFilters) {
				var targetTexts:Array = _separateTexts.slice(textFilter[0], textFilter[1]);
				for each (var targetText:DisplayObject in targetTexts) {
					targetText.filters = [textFilter[2]];
				}
			}
			var bmd:BitmapData = new BitmapData(textField.width, textField.height, true, 0x00000000);
			bmd.draw(textField, textField.transform.matrix);
			_textBitmap.bitmapData = bmd;
			if (_textBitmap) {
				_textBitmap.bitmapData.dispose();
				_textBitmap = null;
			} else {
				_textBitmap = new Bitmap();
				addChild(_textBitmap);
			}*/
		}

		protected function destoryAllChars():void {
			while(_separatedChars.length) {
				var child:DisplayObject = _separatedChars.shift();
				if (child is Bitmap)
					(child as Bitmap).bitmapData.dispose();

				if (child.parent)
					child.parent.removeChild(child);
			}
		}

		override protected function doDispose():void {
			destoryAllChars()

			super.doDispose();
		}
	}
}
