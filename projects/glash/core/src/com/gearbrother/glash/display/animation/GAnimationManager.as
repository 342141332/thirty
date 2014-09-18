package com.gearbrother.glash.display.animation {
	import com.gearbrother.glash.common.oper.GOperEvent;
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.event.GDisplayEvent;
	import com.greensock.TweenLite;
	import com.greensock.easing.Bounce;
	
	import flash.display.DisplayObject;
	import flash.events.Event;


	/**
	 * 所有控件基类
	 *
	 * @author feng.lee
	 * create on 2013-2-17
	 */
	public class GAnimationManager {
		private var _addAnimation:GAnimation;
		public function set addAnimation(newValue:GAnimation):void {
			_addAnimation = newValue;
		}

		private var _moveAnimation:GAnimation;
		public function set moveAnimation(newValue:GAnimation):void {
			_moveAnimation = newValue;
		}

		private var _resizeAnimation:GAnimation;
		public function set resizeAnimation(newValue:GAnimation):void {
			_resizeAnimation = newValue;
		}

		private var _removeAnimation:GAnimation;
		public function set removeAnimation(newValue:GAnimation):void {
			if (_removeAnimation)
				_removeAnimation.removeEventListener(GOperEvent.OPERATION_COMPLETE, _handleAnimationEvent);
			_removeAnimation = newValue;
		}

		private var _x:int;
		private var _y:int;
		private var _alpha:Number;
		private var _skin:DisplayObject;

		public function GAnimationManager() {
		}
		
		public function store(skin:DisplayObject):void {
			_x = skin.x;
			_y = skin.y;
			_alpha = skin.alpha;
			_skin = skin;
		}
		
		public function play():void {
			TweenLite.to(_skin, .3, {x: _skin.x, y: _skin.y});
			_skin.x = _x;
			_skin.y = _y;
		}
		
		/**
		 * 想要删除时带动画必须调用这个 
		 * 
		 */		
		public function remove():void {
			if (_removeAnimation) {
				_removeAnimation.addEventListener(GOperEvent.OPERATION_COMPLETE, _handleAnimationEvent, false, 0, true);
				_removeAnimation.execute();
			} else
				super.remove();
		}
		
		private function _handleAnimationEvent(event:Event):void {
			switch (event.target) {
				case _removeAnimation:
					_removeAnimation.removeEventListener(GOperEvent.OPERATION_COMPLETE, _handleAnimationEvent);
					super.remove();
					break;
			}
		}
	}
}
