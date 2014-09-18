package com.gearbrother.glash.mvc.model {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.getQualifiedClassName;

	[Event(name = "property_change", type = "com.gearbrother.glash.mvc.model.GBeanPropertyEvent")]

	/**
	 * @author 		lifeng
	 * @version 	1.0.0
	 * create on	2012-12-8 下午1:33:10
	 */
	public class GBean extends EventDispatcher {
		static public const NONE:EventDispatcher = new EventDispatcher();

		private var _properties:Object;
		
		public function setProperty(propertyKey:String, newValue:*):void {
			if (_properties[propertyKey] != newValue) {
				var oldValue:* = _properties[propertyKey];
				var newValue:* = _properties[propertyKey] = newValue;
				dispatchEvent(new GBeanPropertyEvent(propertyKey, newValue, oldValue));
			}
		}

		public function getProperty(propertyKey:String):* {
			return _properties[propertyKey];
		}

		public function getProperties():Object {
			return _properties;
		}

		public function setPropertyChanged(propertyKey:String, newValue:* = null, oldValue:* = null):void {
			dispatchEvent(new GBeanPropertyEvent(propertyKey, newValue, oldValue));
		}

		public function GBean(prototype:Object = null) {
			super();

			prototype ||= {};
			if (prototype["constructor"] != Object)
				throw new Error("should be Object");
			_properties = prototype;
		}

		public function merge(source:GBean):void {
			if (getQualifiedClassName(source) != getQualifiedClassName(this))
				throw new ArgumentError("source should be same class");

			var sourceProprties:Object = source._properties;
			for (var sourcePropertyKey:String in sourceProprties) {
				/*if (_properties[sourcePropertyKey] is GBean
					&& getQualifiedClassName(_properties[sourcePropertyKey]) == getQualifiedClassName(sourceProprties[sourcePropertyKey]))
					(_properties[sourcePropertyKey] as GBean).merge(sourceProprties[sourcePropertyKey]);
				else*/
					setProperty(sourcePropertyKey, sourceProprties[sourcePropertyKey]);
			}
		}
	}
}
