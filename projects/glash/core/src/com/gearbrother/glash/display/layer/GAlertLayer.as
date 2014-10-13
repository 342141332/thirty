package com.gearbrother.glash.display.layer {
	import com.gearbrother.glash.common.collections.ArrayList;
	import com.gearbrother.glash.common.collections.HashSet;
	import com.gearbrother.glash.common.oper.GQueue;
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.GSprite;
	import com.gearbrother.glash.display.container.GAlert;
	import com.gearbrother.glash.display.container.GContainer;
	import com.gearbrother.glash.display.layout.impl.CenterLayout;
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;


	/**
	 * modal弹出层
	 * @author feng.lee
	 * create on 2012-11-9 上午11:42:08
	 */
	public class GAlertLayer extends GContainer {
		private var _mask:GNoScale = new GNoScale();

		public var maskColor:uint;

		public var maskAlpha:Number;

		/**
		 * 鼠标点击非窗口区域自动关闭顶层窗口,优化用户体验
		 */
		public var maskClickClose:Boolean;

		public function GAlertLayer() {
			super();

			layout = new CenterLayout();
			maskColor = 0x000000;
			maskAlpha = .3;
			maskClickClose = true;
			addEventListener(MouseEvent.CLICK, _handleMouseEvent);
		}

		private function _handleMouseEvent(event:MouseEvent):void {
			if (event.target == _mask && maskClickClose) {
				var child:DisplayObject = getChildAt(numChildren - 1);
				if (child is GAlert)
					(child as GAlert).close();
			}
		}
		
		override protected function doValidateLayout():void {
			if (numChildren > 1 || (numChildren == 1 && getChildAt(0) != _mask)) {
				_mask.width = width;
				_mask.height = height;
				_mask.graphics.clear();
				_mask.graphics.beginFill(maskColor, maskAlpha);
				_mask.graphics.drawRect(0, 0, width, height);
				_mask.graphics.endFill();
				if (_mask.parent)
					setChildIndex(_mask, numChildren - 2);
				else {
					_mask.alpha = .0;
					TweenLite.to(_mask, .3, {alpha: 1.0});
					addChild(_mask);
				}
			} else if (_mask.parent) {
				TweenLite.to(_mask, .3, {alpha: .0, onComplete: removeChild, onCompleteParams: [_mask]});
			}
			super.doValidateLayout();
		}
	}
}
