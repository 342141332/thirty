package com.gearbrother.glash.display.propertyHandler {
	import com.gearbrother.glash.common.oper.GOper;

	/**
	 *
	 * @author 	Neo.Zhang
	 * @create 	2014-7-10 上午11:06:19
	 *
	 */
	public interface GPropertyPoolOperProcessingListener {
		function addOper(newOper:GOper):void;

		function removeOper(oldOper:GOper):void;
	}
}
