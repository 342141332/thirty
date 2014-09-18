package com.gearbrother.glash.display.layer {
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.container.GContainer;
	import com.gearbrother.glash.util.display.GDisplayUtil;
	import com.greensock.TweenLite;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;


	/**
	 *
	 * @author feng.lee
	 *
	 */
	public class GWindowLayer extends GNoScale {
		/**
		 * 缓动时间
		 */
		public var duration:Number;

		/**
		 * 窗口并排间距
		 */
		public var hGap:int;

		private var _showeds:Array;

		public function get windows():Array {
			var res:Array = [];
			for (var i:int = 0; i < numChildren; i++) {
				var child:DisplayObject = getChildAt(i);
				if (false == child is WindowBitmap)
					res.push(child);
			}
			return res;
		}

		public function GWindowLayer() {
			super();

			duration = .7;
			hGap = 0;
			_showeds = [];
		}

		/**
		 *
		 * @param clazz
		 * @return true 则窗口创建，false则删除窗口
		 *
		 */
		public function toogleWindow(clazz:Class):Boolean {
			for each (var window:DisplayObject in windows) {
				if (window is clazz) {
					removeChild(window);
					return false;
				}
			}
			addChild(new clazz());
			return true;
		}

		override public function addChild(child:DisplayObject):DisplayObject {
			var window:IGWindow = child as IGWindow;
			var oldWindows:Array = windows.concat();
			for (var i:int = 0; i < oldWindows.length; i++) {
				var oldWin:IGWindow = oldWindows[i];
				if (!window.canBeNeighbour(oldWin))
					removeChild(oldWin as DisplayObject);
			}
			return super.addChild(window as DisplayObject);
		}

		override public function removeChild(child:DisplayObject):DisplayObject {
			//删除时残影
			if (duration > .0) {
				var bounds:Rectangle = child.getBounds(child);
				var grab:WindowBitmap = new WindowBitmap(GDisplayUtil.grab(child));
				grab.x = child.x + bounds.left;
				grab.y = child.y + bounds.top;
				TweenLite.to(grab, duration, {alpha: .0, onComplete: _removeGrab, onCompleteParams: [grab]});
				var index:int = getChildIndex(child);
				addChildAt(grab, index);
			}
			var at:int = _showeds.indexOf(child);
			if (at != -1)
				_showeds.splice(at, 1);
			return super.removeChild(child);
		}

		private function _removeGrab(grab:Bitmap):void {
			if (grab.parent == this)
				super.removeChild(grab);
			grab.bitmapData.dispose();
		}

		private function _compare(item1:IGWindow, item2:IGWindow):int {
			return item1.compareNeighbour(item2);
		}

		override protected function doValidateLayout():void {
			var currentWindows:Array = windows;
			currentWindows.sort(_compare, Array.NUMERIC);
			currentWindows = currentWindows.reverse();
			var window:DisplayObject;
			var maxWidth:int;
			for each (window in currentWindows) {
				maxWidth += window.width;
			}
			maxWidth += Math.max(0, currentWindows.length - 1) * hGap;
			var lastX:int = (width - maxWidth) >> 1;
			for each (window in currentWindows) {
				TweenLite.killTweensOf(window);
				if (_showeds.indexOf(window) == -1) {
					window.alpha = .3;
					window.x = lastX;
					window.y = height - window.height >> 1;
					TweenLite.to(window, duration, {alpha: 1.0});
					_showeds.push(window);
				} else {
					TweenLite.to(window, duration, {x: lastX, y: height - window.height >> 1});
				}
				lastX += window.width + hGap;
			}
		}
	}
}
import com.gearbrother.glash.common.algorithm.GBoxsGrid;
import com.gearbrother.glash.display.container.GContainer;
import com.gearbrother.glash.display.layout.impl.EmptyLayout;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.geom.Rectangle;

class WindowBitmap extends Bitmap {
	public function WindowBitmap(bitmapData:BitmapData) {
		super(bitmapData);
	}
}

class WindowLayout extends EmptyLayout {
	private var _hGap:int;

	public function WindowLayout(hGap:int = 10) {
		super();

		_hGap = hGap;
	}

	override public function layoutContainer(target:GContainer):void {
		var children:Array = [];
		var child:DisplayObject;
		var maxWidth:int;
		for (var i:int = 0; i < target.numChildren; i++) {
			child = target.getChildAt(i);
			maxWidth += child.width;
		}
		maxWidth += Math.max(0, children.length - 1) * _hGap;
		var lastX:int = (target.width - maxWidth) >> 1;
		for each (child in children) {
			child.x = lastX;
			child.y = (target.height - child.height >> 1);
			lastX += child.width + _hGap;
		}
	}
}
