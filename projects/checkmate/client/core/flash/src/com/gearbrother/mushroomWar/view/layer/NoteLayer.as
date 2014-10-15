package com.gearbrother.mushroomWar.view.layer {
	import com.gearbrother.glash.display.GNoScale;
	import com.greensock.TimelineMax;
	import com.greensock.TweenLite;
	import com.greensock.easing.Circ;
	import com.greensock.easing.Linear;

	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;


	/**
	 * @author neozhang
	 * @create on Jun 25, 2013
	 */
	public class NoteLayer extends GNoScale {
		private var _nodes:Array;

		private var _timer:Timer;

		public var isFollowMouse:Boolean;
		public var point:Point;

		public function get sleep():Boolean {
			return _timer.running;
		}

		public function set sleep(newValue:Boolean):void {
			if (newValue)
				_timer.stop();
			else
				_timer.start();
		}

		public function NoteLayer() {
			super();

			_timer = new Timer(500);
			_timer.addEventListener(TimerEvent.TIMER, _handleTimerEvent);
			mouseChildren = mouseEnabled = false;
			_nodes = [];
		}

		public function showNode(message:String):void {
			_nodes.push([message]);
			//_timer.start();
			_handleTimerEvent();
		}

		private function _handleTimerEvent(event:Event = null):void {
			if (_nodes.length) {
				var node:Array = _nodes.shift();
				var message:String = node[0];
				//var isFollowMouse:Boolean = false;//messageInfo[1];
				//var point:Point = null;//messageInfo[2];
				var nodeView:TextField = new TextField();
				nodeView.autoSize = TextFieldAutoSize.LEFT;
				nodeView.textColor = 0xFFFF99;
				nodeView.htmlText = message;
				nodeView.setTextFormat(new TextFormat("SimSun", 21, null, true));
				if (point) {
					nodeView.x = point.x - nodeView.textWidth / 2;
					nodeView.y = point.y;
				} else if (isFollowMouse) {
					nodeView.x = mouseX;
					nodeView.y = mouseY;
				} else {
					nodeView.x = (width - nodeView.textWidth) >> 1;
					nodeView.y = (height - nodeView.textHeight) >> 1;
				}
				nodeView.mouseEnabled = false;
				nodeView.filters = [new GlowFilter(0x000000, 1, 3, 3, 50)];
				nodeView.alpha = .0;
				addChild(nodeView);
				var timeline:TimelineMax = new TimelineMax({onComplete: _onComplete, onCompleteParams: [nodeView]});
				timeline.append(TweenLite.to(nodeView, .4, {alpha: 1, y: nodeView.y, ease: Linear.easeNone}));
				timeline.append(TweenLite.to(nodeView, .8, {alpha: 0, y: nodeView.y - 65, ease: Circ.easeIn}));
				nodeView.y += 45;
			} else {
				_timer.stop();
			}
		}

		private function _onComplete(nodeView:TextField):void {
			nodeView.parent.removeChild(nodeView);
		}
	}
}
