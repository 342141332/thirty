package com.gearbrother.glash.common.utils {
	import flash.utils.setTimeout;

	/**
	 * 延迟执行并只执行一次
	 *
	 */
	public class GUniqueCall {
		/**
		 * 是否刚修改过
		 */
		public var dirty:Boolean = false;

		/**
		 * 是否是在下一帧执行
		 */
		public var frame:Boolean = false;

		/**
		 * 执行的函数
		 */
		public var handler:Function;

		/**
		 * 参数列表
		 */
		protected var para:Array;

		/**
		 *
		 * @param handler	执行的函数
		 * @param frame	是否是在下一帧执行
		 */
		public function GUniqueCall(handler:Function, frame:Boolean = false) {
			this.handler = handler;
			this.frame = frame;
		}

		public function invalidate(... para):void {
			if (dirty)
				return;
			dirty = true;

			this.para = para;
		}

		public function vaildNow():void {
			if (handler == null)
				return;

			if (para)
				handler.apply(null, para);
			else
				handler();

			dirty = false;
			para = null;
		}

		public function halt():void {
			dirty = false;
		}
	}
}
