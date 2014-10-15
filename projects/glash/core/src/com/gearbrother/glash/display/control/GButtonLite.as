package com.gearbrother.glash.display.control {
	import com.gearbrother.glash.display.GMovieClip;
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.GSkinSprite;
	import com.gearbrother.glash.display.mouseMode.GIncessancyClick;
	import com.gearbrother.glash.media.GSoundChannel;
	import com.gearbrother.glash.mvc.GActionEvent;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.net.URLRequest;

	[Event(name="select", type="flash.events.Event")]

	/**
	 * 
	 * 标签规则：为一整动画，up,over,down,disabled,selectedUp,selectedOver,selectedDown,selectedDisabled是按钮的八个状态，
	 * 状态间的过滤为两个标签中间加-。比如up和over的过滤即为up-over
	 * @author feng.lee
	 * create on 2012-9-26 下午2:15:22
	 */
	public class GButtonLite extends GNoScale {
		static public const LABEL_UP:String = "up";
		static public const LABEL_OVER:String = "over";
		static public const LABEL_DOWN:String = "down";
		static public const LABEL_DISABLED:String = "disabled";
		static public const LABEL_SELECTED_UP:String = "selectedUp";
		static public const LABEL_SELECTED_OVER:String = "selectedOver";
		static public const LABEL_SELECTED_DOWN:String = "selectedDown";
		static public const LABEL_SELECTED_DISABLED:String = "selectedDisabled";

		static public const UP:int = 0;
		static public const OVER:int = 1;
		static public const DOWN:int = 2;
		static public const DISABLED:int = 3;

		static public const LABELS:Array = [
			[LABEL_UP, LABEL_SELECTED_UP]
			, [LABEL_OVER, LABEL_SELECTED_OVER]
			, [LABEL_DOWN, LABEL_SELECTED_DOWN]
			, [LABEL_DISABLED, LABEL_SELECTED_DISABLED]
		];

		/** 按钮状态（up） */
		public const upState:GButtonState = new GButtonState();
		/** 按钮状态（over） */
		public const overState:GButtonState = new GButtonState();
		/** 按钮状态（downState） */
		public const downState:GButtonState = new GButtonState();
		/** 按钮状态（disabledState） */
		public const disabledState:GButtonState = new GButtonDisabledState();
		/** 按钮状态（selectedUp） */
		public const selectedUpState:GButtonState = new GButtonState();
		/** 按钮状态（selectedOver） */
		public const selectedOverState:GButtonState = new GButtonState();
		/** 按钮状态（selectedDown） */
		public const selectedDownState:GButtonState = new GButtonState();
		/** 按钮状态（selectedDisabled） */
		public const selectedDisabledState:GButtonState = new GButtonDisabledState();
		
		static public var clickSound:*;

		private var _mouseDown:Boolean;

		private var _mouseOver:Boolean;

		/**
		 * 执行的指令名称
		 */
		public var action:String;

		private var _incessancyClick:GIncessancyClick;

		/**
		 * 是否允许按下时模拟连续点击
		 */
		public function set autoRepeat(value:Boolean):void {
			if (value)
				_incessancyClick = new GIncessancyClick(this);
		}

		public var enabledLabelMovie:Boolean;

		/**
		 * 按钮状态字典
		 */
		public var buttonStates:Object;

		/**
		 * 是否可以点击选择
		 */
		public var toggle:Boolean;

		override public function set enabled(value:Boolean):void {
			super.enabled = value;

			buttonMode = enabled;
			tweenTo(UP);
		}

		override public function set selected(value:Boolean):void {
			super.selected = value;
			
			tweenTo(_mouseOver ? OVER : UP);
		}
		
		override public function set width(newValue:Number):void {
			if (width != newValue) {
				super.width = newValue;
				repaint();
			}
		}
		
		override public function set height(newValue:Number):void {
			if (height != newValue) {
				super.height = newValue;
				repaint();
			}
		}

		protected var _movie:GMovieClip;

		public function GButtonLite(skin:DisplayObject = null) {
			super(skin);

			buttonStates = {
//				up: upState
//					, over: overState
//					, down: downState
					disabled: disabledState
//					, selectedUp: selectedUpState
//					, selectedOver: selectedOverState
//					, selectedDown: selectedDownState
					, selectedDisabled: selectedDisabledState
			};
			_movie = new GMovieClip(skin as MovieClip, 5);
			enabledLabelMovie = true;
			_mouseDown = false;
			_mouseOver = false;
			toggle = false;
			mouseChildren = false;
			enabled = true;	//tweenTo(UP);
			addEventListener(MouseEvent.MOUSE_DOWN, _handleMouseEvent);
			addEventListener(MouseEvent.ROLL_OVER, _handleMouseEvent);
			addEventListener(MouseEvent.ROLL_OUT, _handleMouseEvent);
			addEventListener(MouseEvent.CLICK, _handleMouseEvent);
		}

		protected function _handleMouseEvent(event:MouseEvent):void {
			switch (event.type) {
				case MouseEvent.MOUSE_DOWN:
					_mouseDown = true;
					tweenTo(DOWN);
					stage.addEventListener(MouseEvent.MOUSE_UP, _handleMouseEvent);
					break;
				case MouseEvent.MOUSE_UP:
					_mouseDown = false;
					tweenTo(_mouseOver ? OVER : UP);
					stage.removeEventListener(MouseEvent.MOUSE_UP, _handleMouseEvent);
					break;
				case MouseEvent.ROLL_OVER:
					_mouseOver = true;
					if (event.buttonDown) {
						if (_mouseDown)
							tweenTo(DOWN);
					} else {
						tweenTo(OVER);
					}
					break;
				case MouseEvent.ROLL_OUT:
					_mouseOver = false;
					tweenTo(UP);
					break;
				case MouseEvent.CLICK:
					if (toggle)
						selected = !selected;

					if (this.action) {
						var e:GActionEvent = new GActionEvent(GActionEvent.ACTION);
						e.action = this.action;
						dispatchEvent(e)
					}
					
					if (clickSound is URLRequest)
						GSoundChannel.buttonChannel.playURL(clickSound as URLRequest);
					else if (clickSound is Sound)
						GSoundChannel.buttonChannel.play(clickSound);
					else if (clickSound)
						throw new Error("unknown sound");
					break;
			}
		}

		protected function tweenTo(n:int):void {
			if (!enabled)
				n = DISABLED;

			var next:String = LABELS[n][int(selected)];
			var state:GButtonState = buttonStates[next];
			if (state)
				state.parse(this);

			if (_movie && _movie.labels) {
				if (enabledLabelMovie) {
					if (_movie.hasLabel(_movie.currentQueueLabelName + "-" + next)) {
						_movie.setLabel(_movie.currentQueueLabelName + "-" + next, 1);
						_movie.queueLabel(next, -1);
					} else if (_movie.hasLabel("*-" + next)) {
						_movie.setLabel("*-" + next, 1);
						_movie.queueLabel(next, -1);
					} else {
						_movie.setLabel(next, -1);
					}
				} else {
					_movie.setLabel(next, -1);
				}
			}
		}

		override public function paintNow():void {
			_movie.skin.width = width;
			_movie.skin.height = height;
		}

		override protected function doDispose():void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, _handleMouseEvent);
			removeEventListener(MouseEvent.MOUSE_DOWN, _handleMouseEvent);
			removeEventListener(MouseEvent.ROLL_OVER, _handleMouseEvent);
			removeEventListener(MouseEvent.ROLL_OUT, _handleMouseEvent);
			removeEventListener(MouseEvent.CLICK, _handleMouseEvent);

			super.doDispose();
		}
	}
}
import com.gearbrother.glash.display.control.GButtonLite;
import com.gearbrother.glash.display.control.GButtonState;

import flash.filters.ColorMatrixFilter;

class GButtonDisabledState extends GButtonState {
	public function GButtonDisabledState() {
		super();

		this.filters = [new ColorMatrixFilter([0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0])];
	}
	
	override public function parse(target:GButtonLite):void {
		super.parse(target);
	}
}