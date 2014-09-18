package com.gearbrother.glash.display {

	/**
	 * @author feng.lee
	 * @create on 2013-4-5
	 */
	public interface IGPropertyManagable {
		function set value(newValue:*):void;

		function get value():*;

		function validateNow():void;

		function dispose():void;
	}
}
