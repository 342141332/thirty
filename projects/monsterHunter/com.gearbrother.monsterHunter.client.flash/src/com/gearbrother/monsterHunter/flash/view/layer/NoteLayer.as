package com.gearbrother.monsterHunter.flash.view.layer {
	import com.gearbrother.glash.display.container.GContainer;
	import com.gearbrother.monsterHunter.flash.GameMain;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	/**
	 * 游戏中常用文字通知冒泡
	 * @author feng.lee
	 *
	 */
	public class NoteLayer extends GContainer {
		private var _messageInfos:Array;

		public function NoteLayer() {
			super();

			this.mouseChildren = this.mouseEnabled = false;
			_messageInfos = [];
		}

		/**
		 *	message 显示的文字
		 * v == true 随鼠标弹出
		 * v == flase 屏幕中间弹出
		 * point 在该点弹出并以该点为中心
		 */
		public function addMessage(message:String, isFollowMouse:Boolean = false, point:Point = null):void {
			_messageInfos.push([message, isFollowMouse, point]);
		}

		private function _popup(event:Event):void {
			if (_messageInfos.length > 0) {
				var messageInfo:Array = _messageInfos.shift();
				var message:String = messageInfo[0];
				var isFollowMouse:Boolean = messageInfo[1];
				var point:Point = messageInfo[2];
				var _pop:TextField = new TextField();
				_pop.autoSize = TextFieldAutoSize.LEFT;
				_pop.textColor = 0xFFFF99;
				_pop.htmlText = message;
				_pop.setTextFormat(new TextFormat(null, 14, null, true));
				if (isFollowMouse) {
					if (point) {
						_pop.x = point.x - _pop.textWidth / 2;
						_pop.y = point.y;
					} else {
						_pop.x = mouseX;
						_pop.y = mouseY;
					}
				} else {
					_pop.x = stage.stageWidth / 2 - _pop.textWidth / 2;
					_pop.y = stage.stageHeight >> 1;
				}
				_pop.mouseEnabled = false;
				_pop.filters = [new GlowFilter(0x000000, 1, 3, 3, 50)];
				addChild(_pop);
//				var timeline:TimelineMax = new TimelineMax({onComplete: __onComplete});
//				timeline.append(TweenLite.to(_pop, 2, {y: _pop.y - 100, ease: Linear.easeNone}));
//				timeline.append(TweenLite.to(_pop, 2, {alpha: 0, y: _pop.y - 200, ease: Linear.easeNone}));

				function __onComplete():void {
					if (_pop.parent) {
						_pop.parent.removeChild(_pop);
						_pop = null;
					}
				}
			}
		}
	}
}
