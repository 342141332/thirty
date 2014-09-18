package com.gearbrother.glash.common.geom {
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import org.as3commons.lang.ICloneable;
	import com.gearbrother.glash.util.display.Geom;

	/**
	 * @author feng.lee
	 * create on 2012-5-29 下午8:43:13
	 */
	public class GPadding implements ICloneable {
		public var top:int;
		public var left:int;
		public var bottom:int;
		public var right:int;

		public function GPadding(top:int = 0, right:int = 0, bottom:int = 0, left:int = 0) {
			this.top = top;
			this.left = left;
			this.bottom = bottom;
			this.right = right;
		}

		/**
		 * 根据属性更正矩形大小
		 *
		 * @param rect	需要更正的矩形
		 * @param parent	父矩形
		 *
		 */
		public function adjectRect(rect:*, parent:*):void {
			parent = Geom.getRect(parent, parent);

			if (!isNaN(left))
				rect.x = parent.x + left;

			if (!isNaN(top))
				rect.y = parent.y + top;

			if (!isNaN(right))
				rect.width = parent.right - right - rect.x;

			if (!isNaN(bottom))
				rect.height = parent.bottom - bottom - rect.y;
		}

		/**
		 * 根据更正两个同级矩形的大小
		 *
		 * @param rect	需要更正的矩形
		 * @param rect2	源矩形
		 *
		 */
		public function adjectRectBetween(rect:*, rect2:*):void {
			if (!isNaN(left))
				rect.x = rect2.x + left;

			if (!isNaN(top))
				rect.y = rect2.y + top;

			if (!isNaN(right))
				rect.width = rect2.x + rect2.width - right - rect.x;

			if (!isNaN(bottom))
				rect.height = rect2.y + rect2.height - bottom - rect.y;

			//处理注册点问题
			var dis:DisplayObject = rect as DisplayObject
			if (dis) {
				var pRect:Rectangle = Geom.getRect(dis);
				dis.x -= pRect.x - dis.x;
				dis.y -= pRect.y - dis.y;
			}
		}

		/**
		 * 取反
		 * @return
		 *
		 */
		public function invent():GPadding {
			return new GPadding(-left, -top, -right, -bottom)
		}

		/**
		 * 复制
		 * @return
		 *
		 */
		public function clone():* {
			return new GPadding(left, top, right, bottom)
		}
	}
}
