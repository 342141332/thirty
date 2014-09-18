package com.gearbrother.glash.util.display {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 *
	 * @author feng.lee
	 *
	 */
	public class GDisplayUtil {
		/**
		 *
		 * @param display
		 * @param rect		抓取大小相对于抓去对象显示坐标
		 * @return
		 *
		 */
		static public function grab(display:DisplayObject, rect:Rectangle = null):BitmapData {
			var bounds:Rectangle = rect ? rect : display.getBounds(display);
			var bmd:BitmapData = new BitmapData(Math.max(bounds.width, 1), Math.max(bounds.height, 1), true, 0x00000000);
			var m:Matrix = display.transform.matrix;
			m.tx = -bounds.left;
			m.ty = -bounds.top;
			bmd.draw(display, m);
			return bmd;
		}

		/**
		 * 检测对象是否在屏幕中
		 * @param displayObj	显示对象
		 *
		 */
		static public function inScreen(displayObj:DisplayObject):Boolean {
			if (displayObj.stage == null)
				return false;

			var screen:Rectangle = Geom.getRect(displayObj.stage);
			return screen.containsRect(displayObj.getBounds(displayObj.stage));
		}

		/**
		 * 添加到对象之后
		 * @param container
		 * @param child
		 * @param target
		 *
		 */
		static public function addChildAfter(child:DisplayObject, target:DisplayObject):void {
			target.parent.addChildAt(child, target.parent.getChildIndex(target) + 1);
		}

		/**
		 * 添加到对象之前
		 * @param container
		 * @param child
		 * @param target
		 *
		 */
		static public function addChildBefore(child:DisplayObject, target:DisplayObject):void {
			target.parent.addChildAt(child, target.parent.getChildIndex(target));
		}

		/**
		 * 获得子对象数组
		 * @param container
		 *
		 */
		static public function getChildren(parent:DisplayObject, depth:int = int.MAX_VALUE, filter:Class = null):Array {
			var res:Array = [];
			if (parent is DisplayObjectContainer) {
				var num:uint = (parent as DisplayObjectContainer).numChildren;
				for (var i:int = 0; i < num; i++) {
					var child:DisplayObject = (parent as DisplayObjectContainer).getChildAt(i);
					if (filter) {
						if (child is filter) {
							res.push(child);
						}
					} else {
						res.push(child);
					}
					if (child is DisplayObjectContainer) {
						var loopDepth:uint = depth - 1;
						if (loopDepth > 0)
							res = res.concat(getChildren(child as DisplayObjectContainer, loopDepth));
					}
				}
			}
			return res;
		}

		/**
		 * 移除所有子对象
		 * @param container	目标
		 *
		 */
		static public function removeAllChildren(container:DisplayObjectContainer):void {
			while (container.numChildren)
				container.removeChildAt(0);
		}

		/**
		 * 批量增加子对象
		 *
		 */
		static public function addAllChildren(container:DisplayObjectContainer, children:Array):void {
			for (var i:int = 0; i < children.length; i++) {
				if (children[i] is Array)
					addAllChildren(container, children[i] as Array);
				else
					container.addChild(children[i])
			}
		}

		/**
		 * 将显示对象移至顶端
		 * @param displayObj	目标
		 *
		 */
		static public function moveToHigh(displayObj:DisplayObject):void {
			var parent:DisplayObjectContainer = displayObj.parent;
			if (parent) {
				parent.setChildIndex(displayObj, 0);
			}
		}

		/**
		 * 同时设置mouseEnabled以及mouseChildren。
		 *
		 */
		static public function setMouseEnabled(displayObj:DisplayObjectContainer, enable:Boolean):void {
			displayObj.mouseChildren = displayObj.mouseEnabled = enable;
		}

		/**
		 * 复制显示对象
		 * @param v
		 *
		 */
		static public function cloneDisplayObject(v:DisplayObject):DisplayObject {
			var result:DisplayObject = v["constructor"]();
			result.filters = result.filters;
			result.transform.colorTransform = v.transform.colorTransform;
			result.transform.matrix = v.transform.matrix;
			if (result is Bitmap)
				(result as Bitmap).bitmapData = (v as Bitmap).bitmapData;
			return result;
		}

		/**
		 * 获取舞台Rotation
		 *
		 * @param displayObj	显示对象
		 * @return
		 *
		 */
		static public function getStageRotation(displayObj:DisplayObject):Number {
			var currentTarget:DisplayObject = displayObj;
			var r:Number = 1.0;

			while (currentTarget && currentTarget.parent != currentTarget) {
				r += currentTarget.rotation;
				currentTarget = currentTarget.parent;
			}
			return r;
		}

		/**
		 * 获取舞台缩放比
		 *
		 * @param displayObj
		 * @return
		 *
		 */
		static public function getStageScale(displayObj:DisplayObject):Point {
			var currentTarget:DisplayObject = displayObj;
			var scale:Point = new Point(1.0, 1.0);

			while (currentTarget && currentTarget.parent != currentTarget) {
				scale.x *= currentTarget.scaleX;
				scale.y *= currentTarget.scaleY;
				currentTarget = currentTarget.parent;
			}
			return scale;
		}

		/**
		 * 获取舞台Visible
		 *
		 * @param displayObj	显示对象
		 * @return
		 *
		 */
		static public function getStageVisible(displayObj:DisplayObject):Boolean {
			var currentTarget:DisplayObject = displayObj;
			while (currentTarget && currentTarget.parent != currentTarget) {
				if (currentTarget.visible == false)
					return false;
				currentTarget = currentTarget.parent;
			}
			return true;
		}

		/**
		 * 判断对象是否在某个容器中
		 * @param displayObj
		 * @param container
		 * @return
		 *
		 */
		static public function hasContain(container:DisplayObjectContainer, displayObj:DisplayObject):Boolean {
			var currentTarget:DisplayObject = displayObj;
			while (currentTarget) {
				if (currentTarget == container)
					return true;
				currentTarget = currentTarget.parent;
			}
			return false;
		}

		static public function relativeTo(from:DisplayObject, to:DisplayObject):Point {
			var fromPt:Point = from.localToGlobal(new Point);
			var toPt:Point = to.localToGlobal(new Point);
			return toPt.subtract(fromPt);
		}

		static public function pixelHitTest(object:DisplayObject, localX:Number , localY:Number):Boolean {
			var bmapData:BitmapData = new BitmapData(1, 1, true, 0x00000000);
			var bounds:Rectangle = object.getBounds(object);
			var m:Matrix = new Matrix(1, 0, 0, 1, -localX, -localY);
			bmapData.draw(object, m);
			var returnVal:Boolean = bmapData.hitTest(new Point(0, 0), 128, new Point(0, 0));
			bmapData.dispose();
			return returnVal;
		}
		
		static public function isEmptyBmd(bmd:BitmapData):Boolean {
			var unContentRect:Rectangle = bmd.getColorBoundsRect(0xff000000, 0xff000000, true);
			return unContentRect.width == 0 && unContentRect.height == 0;
		}

		static public function replace(target:DisplayObject, replace:DisplayObject, isCenter:Boolean = true):void {
			var parent:DisplayObjectContainer = target.parent;
			var targetIndex:int = parent.getChildIndex(target);
			parent.removeChild(target);
			replace.x = target.x + (isCenter ? (target.width - replace.width) / 2 : 0);
			replace.y = target.y + (isCenter ? (target.height - replace.height) / 2 : 0);
			parent.addChildAt(replace, targetIndex);
		}

		static public function cover(target:DisplayObject, cover:DisplayObject, layer:DisplayObjectContainer, isCenter:Boolean = true):void {
			var bounds:Rectangle = target.getBounds(layer);
			var parent:DisplayObjectContainer = target.parent;
			cover.x = bounds.x + (isCenter ? (target.width - cover.width) / 2 : 0);
			cover.y = bounds.y + (isCenter ? (target.height - cover.height) / 2 : 0);
			layer.addChild(cover);
		}
	}
}
