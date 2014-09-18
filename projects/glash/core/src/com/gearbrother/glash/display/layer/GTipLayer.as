package com.gearbrother.glash.display.layer {
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.GSprite;
	import com.gearbrother.glash.display.IGToolTipable;
	import com.gearbrother.glash.display.manager.GTickEvent;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.setTimeout;


	/**
	 * 提示类，需要手动加载到某个容器内，将一直处于最高层。
	 * 此类会一直检测鼠标下的物体，实现IToolTipManagerClient就会根据其toolTipObj自动弹出。
	 *
	 * 皮肤用ToolTipSprite.defaultSkin来设置
	 *
	 */
	public class GTipLayer extends GNoScale {
		/**
		 * 默认光标皮肤
		 */
		static public var defaultSkin:*; // = ToolTipSkin;

		public var getTipView:Function; //已注册的ToolTipObj集合

		/**
		 * 延迟显示的毫秒数
		 */
		public var delay:int = 250;

		/**
		 * ToolTip目标
		 */
		private var _tipTarget:IGToolTipable;

		private var _tipView:GNoScale;

		protected function set tipTarget(newValue:IGToolTipable):void {
			if (_tipTarget != newValue) {
				_delayTarget = newValue;
				_refreshTimer.reset();
				_refreshTimer.start();
			}
		}

		private var _delayTarget:IGToolTipable;

		private var _refreshTimer:Timer;

		/**
		 * 皮肤必须为IToolTipSkin
		 *
		 * @param obj
		 *
		 */
		public function GTipLayer() {
			super();

			this.mouseEnabled = this.mouseChildren = false;
		}

		protected override function doInit():void {
			super.doInit();

			stage.addEventListener(MouseEvent.MOUSE_OVER, _handleMouseEvent, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_OUT, _handleMouseEvent, false, 0, true);
			_refreshTimer = new Timer(delay, 1);
			_refreshTimer.addEventListener(TimerEvent.TIMER, _updateTipTarget);
		}

		private function _handleMouseEvent(event:MouseEvent):void {
			var target:IGToolTipable = event.target as IGToolTipable;
			switch (event.type) {
				case MouseEvent.MOUSE_OVER:
					tipTarget = target;
					break;
				case MouseEvent.MOUSE_OUT:
					tipTarget = null;
					break;
			}
		}

		private function _updateTipTarget(event:TimerEvent):void {
			if (_tipTarget != _delayTarget) {
				_tipTarget = _delayTarget;
				var newTipView:GNoScale = _tipTarget && getTipView != null ? getTipView(_tipTarget.tipData) : null;
				if (newTipView) {
					var left:int = mouseX + 10;
					if (left + newTipView.width > stage.stageWidth)
						left = mouseX - 10 - newTipView.width;
					var top:int = mouseY + 10;
					if (top + newTipView.height > stage.stageHeight)
						top = mouseY - 10 - newTipView.height;
					if (_tipView) {
						_tipView.remove();
						_tipView = null;

						_tipView = newTipView;
						addChild(_tipView);
						_tipView.x = left;
						_tipView.y = top;
					} else {
						_tipView = newTipView;
						addChild(_tipView);
						_tipView.x = left;
						_tipView.y = top;
						_tipView.alpha = .0;
						TweenLite.to(_tipView, .3, {alpha: 1.0});
					}
				} else if (_tipView) {
					TweenMax.to(_tipView, .2, {alpha: .0, onComplete: _onTipAlpha, onCompleteParams: [_tipView]});
				}
				_tipView = newTipView;
			}
		}

		private function _onTipAlpha(tipView:DisplayObject):void {
			tipView.parent.removeChild(tipView);
		}
		
		override protected function doValidateLayout():void {
			if (_tipView) {
				_tipView.width = _tipView.preferredSize.width;
				_tipView.height = _tipView.preferredSize.height;
				_tipView.validateLayoutNow();
			}
		}
	}
}
