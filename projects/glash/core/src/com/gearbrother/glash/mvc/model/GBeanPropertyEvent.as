package com.gearbrother.glash.mvc.model {
	import flash.events.Event;


	/**
	 * @author 		lifeng
	 * @version 	1.0.0
	 * create on	2012-12-8 下午1:33:32
	 */
	public class GBeanPropertyEvent extends Event {
		static public const PROPERTY_CHANGE:String = "property_change";

		public var propertyKey:String;

		public var newValue:*;

		public var oldValue:*;

		public function GBeanPropertyEvent(propertyKey:String, newValue:*, oldValue:*) {
			super(PROPERTY_CHANGE, bubbles, cancelable);

			this.propertyKey = propertyKey;
			this.newValue = newValue;
			this.oldValue = oldValue;
		}
	}
}
