package com.gearbrother.glash.display.layer {
	import com.gearbrother.glash.display.GNoScale;
	import com.greensock.TimelineMax;
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
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;


	/**
	 * 游戏中常用文字通知冒泡
	 * @author feng.lee
	 *
	 */
	public class GNoteLayer extends GNoScale {
		private var _nodes:Array;

		private var _timer:Timer;

		public function get sleep():Boolean {
			return _timer.running;
		}

		public function set sleep(newValue:Boolean):void {
			if (newValue)
				_timer.stop();
			else
				_timer.start();
		}

		public function GNoteLayer() {
			super();

			_timer = new Timer(500);
			_timer.addEventListener(TimerEvent.TIMER, _handleTimerEvent);
			mouseChildren = mouseEnabled = false;
			_nodes = [];
		}

		public function showNode(message:String):void {
			_nodes.push([message]);
			_timer.start();
		}

		private function _handleTimerEvent(event:Event):void {
			if (_nodes.length) {
				var node:Array = _nodes.shift();
				var message:String = node[0];
				var isFollowMouse:Boolean = false; //messageInfo[1];
				var point:Point = null; //messageInfo[2];
				var nodeView:TextField = new TextField();
				nodeView.autoSize = TextFieldAutoSize.LEFT;
				nodeView.textColor = 0xFFFF99;
				nodeView.htmlText = message;
				nodeView.setTextFormat(new TextFormat("SimSun", 17, null, true));
				if (isFollowMouse) {
					if (point) {
						nodeView.x = point.x - nodeView.textWidth / 2;
						nodeView.y = point.y;
					} else {
						nodeView.x = mouseX;
						nodeView.y = mouseY;
					}
				} else {
					nodeView.x = stage.stageWidth / 2 - nodeView.textWidth / 2;
					nodeView.y = stage.stageHeight >> 1;
				}
				nodeView.mouseEnabled = false;
				nodeView.filters = [new GlowFilter(0x000000, 1, 3, 3, 50)];
				addChild(nodeView);
				var timeline:TimelineMax = new TimelineMax({onComplete: _onComplete, onCompleteParams: [nodeView]});
				timeline.append(TweenLite.to(nodeView, 2, {y: nodeView.y - 100, ease: Linear.easeNone}));
				timeline.append(TweenLite.to(nodeView, 2, {alpha: 0, y: nodeView.y - 200, ease: Linear.easeNone}));
			} else {
				_timer.stop();
			}
		}

		private function _onComplete(nodeView:TextField):void {
			nodeView.parent.removeChild(nodeView);
		}
	}
}
