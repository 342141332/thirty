package com.gearbrother.glash.display.control {
	import com.gearbrother.glash.display.GDisplayConst;
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.GSkinSprite;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author feng.lee
	 * create on 2012-7-26 下午2:33:37
	 */
	public class GSlider extends GRange {
		/**
		 * 滑动块
		 */
		public var thumb:GButtonLite;

		private var _autoHide:Boolean;

		/**
		 * 快速滚动速度
		 */
		public var pageDetra:int = 25;

		private var _direction:int;

		public function get direction():int {
			return _direction;
		}

		private var _pageSize:Number;

		public function get pageSize():Number {
			return _pageSize;
		}

		public function set pageSize(newValue:Number):void {
			_pageSize = newValue;
		}

		private var _mouseDownPos:Point;

		private var _thumbMin:Number;
		
		private var _thumbMax:Number;
		
		private var _maxThumbSize:Number;

		public function get scrollRange():Number {
			if (_direction == GDisplayConst.AXIS_X) {
				return _maxThumbSize - thumb.width;
			} else if (_direction == GDisplayConst.AXIS_Y) {
				return _maxThumbSize - thumb.height;
			} else {
				throw new Error("unknown direction");
			}
		}

		override public function set skin(newValue:DisplayObject):void {
			if (newValue.hasOwnProperty("thumb")) {
				thumb = new GButtonLite(newValue["thumb"]);
			}
			if (newValue.hasOwnProperty("track")) {
				track = newValue["track"];
			}

			super.skin = newValue;
		}
		
		public function GSlider(direction:int, skin:DisplayObject = null) {
			super(skin);

			_autoHide = true;
			_direction = direction;
			addEventListener(MouseEvent.MOUSE_DOWN, _handleMouseEvent);
		}

		override public function _handleMouseEvent(e:MouseEvent):void {
			super._handleMouseEvent(e);

			switch (e.target) {
				case thumb:
					_mouseDownPos = new Point(mouseX - thumb.x, mouseY - thumb.y);
					stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMove);
					stage.addEventListener(MouseEvent.MOUSE_UP, _handleStageEvent);
					break;
				case track:
					onStageMove(e);
					break;
			}
		}

		protected function onStageMove(e:MouseEvent):void {
			if (direction == GDisplayConst.AXIS_X) {
				percent = (mouseX - (minButton ? minButton.x + minButton.width : 0) - (_mouseDownPos ? _mouseDownPos.x : 0)) / scrollRange;
			} else if (direction == GDisplayConst.AXIS_Y) {
				percent = (mouseY - (minButton ? minButton.y + minButton.height : 0) - (_mouseDownPos ? _mouseDownPos.y : 0)) / scrollRange;
			}
			e.updateAfterEvent();
		}

		protected function _handleStageEvent(e:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, _handleStageEvent);
			_mouseDownPos = null;
		}

		override protected function doValidateLayout():void {
			if (_direction == GDisplayConst.AXIS_X) {
				if (maxButton)
					maxButton.x = width - maxButton.width;
				if (minButton && maxButton) {
					_maxThumbSize = maxButton.x - minButton.x - minButton.width;
					_thumbMin = minButton.x + minButton.width;
					_thumbMax = maxButton.x;
				} else {
					_maxThumbSize = track.width;
				}
				if (track) {
					track.x = /*minButton ? minButton.x + minButton.width : */0;
					track.width = width/* - track.x - (maxButton ? maxButton.width : 0)*/;
				}
			} else if (_direction == GDisplayConst.AXIS_Y) {
				if (maxButton)
					maxButton.y = height - maxButton.height;
				if (minButton && maxButton) {
					_maxThumbSize = maxButton.y - minButton.y - minButton.height;
					_thumbMin = minButton.y + minButton.height;
					_thumbMax = maxButton.y;
				} else {
					_maxThumbSize = track.height;
				}
				if (track) {
					track.y = /*minButton ? minButton.y + minButton.height : */0;
					track.height = height/* - track.y - (maxButton ? maxButton.height : 0)*/;
				}
			}
		}
		
		override public function paintNow():void {
			if (direction == GDisplayConst.AXIS_X) {
				if (thumb) {
					thumb.width = Math.max(10, _maxThumbSize * _pageSize / (maxValue - minValue + _pageSize));
					thumb.x = _thumbMin + scrollRange * percent;
					if (_autoHide && minValue == maxValue)
						thumb.visible = false;
					else
						thumb.visible = true;
				}
			} else {
				if (thumb) {
					thumb.height = Math.max(10, _maxThumbSize * _pageSize / (maxValue - minValue + _pageSize));
					thumb.y = _thumbMin + scrollRange * percent;
					if (_autoHide && minValue == maxValue)
						thumb.visible = false;
					else
						thumb.visible = true;
				}
			}

			super.paintNow();
		}

		override protected function doDispose():void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, _handleStageEvent);

			super.doDispose();
		}
	}
}
