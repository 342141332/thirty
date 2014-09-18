package com.gearbrother.glash.common.oper.ext {
	import com.gearbrother.glash.common.utils.GHandler;
	import com.gearbrother.glash.common.oper.GOper;

	/**
	 * @author neozhang
	 * @create on Jun 3, 2013
	 */
	public class GHandleOper extends GOper {
		private var _handler:GHandler;

		public function GHandleOper(handler:GHandler) {
			super(null);

			_handler = handler;
			immediately = true;
		}

		override public function execute():void {
			_handler.call();

			super.execute();
		}
	}
}
