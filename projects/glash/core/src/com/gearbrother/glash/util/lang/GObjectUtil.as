package com.gearbrother.glash.util.lang {
	import flash.utils.getDefinitionByName;

	import mx.utils.ObjectUtil;

	public class GObjectUtil {
		
		/**
		 * 创建一个对象并赋初值
		 * 同样的功能也能通过创建ClassFactory代替
		 *
		 * @param obj	一个对象的实例或者一个类，类会自动实例化。
		 * @param values	初值对象
		 * @return
		 *
		 */
		public static function createObject(obj:*, values:Object):* {
			if (obj is Class)
				obj = new obj();
			
			for (var key:* in values)
				obj[key] = values[key];
			
			return obj;
		}

		/**
		 *
		 *  @param target, [object1,] [objectN] !important it will change target
		 * 	@return merged object
		 *
		 *
		 * 	@Example1:
		 * 	var object1 = {
		 *	  apple: 0,
		 *	  banana: {weight: 52, price: 100},
		 *	  cherry: 97
		 *	};
		 *	var object2 = {
		 *	  banana: {price: 200},
		 *	  durian: 100
		 *	};
		 *
		 * 	//merge object2 into object1
		 * 	ObjectUtil.extend(object1, object2);
		 *
		 * 	trace(object1);
		 *
		 * 	{ apple: 0, banana: { price: 200 }, cherry: 97, durian: 100 }
		 *
		 *
		 *
		 *
		 * 	@Example2:
		 * 	merge defaults and options, without modifying defaults
		 *	var defaults = { validate: false, limit: 5, name: "foo" };
		 *	var options = { validate: true, name: "bar" };
		 *
		 *
		 *	var settings = $.extend({}, defaults, options);
		 *
		 *	trace(settings);
		 *
		 * 	{ validate: true, limit: 5, name: bar }
		 *
		 */
		public static function extend(... arguments):Object {
			var options:Object, name:*, src:*, copy:*, copyIsArray:Boolean, clone:*, target:Object = arguments[0] || {}, i:int = 1, length:int = arguments.length, deep:Boolean = false;

			// Handle a deep copy situation
			if (typeof(target) === "boolean") {
				deep = target;
				target = arguments[1] || {};
				// skip the boolean and the target
				i = 2;
			}

			// Handle case when target is a string or something (possible in deep copy)
			if (typeof(target) !== "object" && !target is Function) {
				target = {};
			}

			for (; i < length; i++) {
				// Only deal with non-null/undefined values
				if ((options = arguments[i]) != null) {
					// Extend the base object
					for (name in options) {
						src = target[name];
						copy = options[name];

						// Prevent never-ending loop
						if (target === copy) {
							continue;
						}

						// Recurse if we're merging plain objects or arrays
						if (deep && copy && (isSimple(copy) || (copyIsArray = copy is Array))) {
							if (copyIsArray) {
								copyIsArray = false;
								clone = src && src is Array ? src : [];

							} else {
								clone = src && isSimple(src) ? src : {};
							}

							// Never move original objects, clone them
							target[name] = GObjectUtil.extend(deep, clone, copy);

								// Don't bring in undefined values
						} else if (copy !== undefined) {
							target[name] = copy;
						}
					}
				}
			}

			// Return the modified object
			return target;
		}

		/**
		 * Returns whether or not the given object is simple data type.
		 *
		 * @param the object to check
		 * @return true if the given object is a simple data type; false if not
		 */
		public static function isSimple(object:Object):Boolean {
			switch (typeof(object)) {
				case "number":
				case "string":
				case "boolean":
					return true;
				case "object":
					return (object is Date) || (object is Array);
			}

			return false;
		}

		public static function toInstance(proto:Object, cls:Class):* {
			var instance:* = new cls();
//			injectToInstance(proto, instance);
			return instance;
		}

//		public static function injectToInstance(proto:Object, instance:*):void {
//			var clsInfo:ClassInfo = ClassInfo.forInstance(instance);
//			var simples:Array = [ClassInfo.forClass(Number)
//				, ClassInfo.forClass(String)
//				, ClassInfo.forClass(Boolean)
//				, ClassInfo.forClass(uint)
//				, ClassInfo.forClass(int)];
//			for each (var property:Property in clsInfo.getProperties()) {
//				var metadata:Metadata;
//				var collectionType:Class;
//				if (property.writable) {
//					if (simples.indexOf(property.type) != -1) {
//						//is base type
//						property.setValue(instance, proto[property.name]);
//					} else if (property.type.isInterface()) {
//						metadata = property.getMetadata("Convert")[0];
//						collectionType = getDefinitionByName(metadata.getArgument("type")) as Class;
//						property.setValue(instance, proto[property.name]);
//					} else if (property.type.isType(ArrayEventable)
//						|| property.type.isType(Array)) {
//						metadata = property.getMetadata("Convert")[0];
//						collectionType = getDefinitionByName(metadata.getArgument("type")) as Class;
//						var collection:* = property.getValue(instance);
//						for each (var pro:* in proto[property.name]) {
//							var instanceCol:* = toInstance(pro, collectionType);
//							if (collection is ArrayEventable) {
//								(collection as ArrayEventable).add(instanceCol);
//							} else if (collection is Array) {
//								(collection as Array).push(instanceCol);
//							}
//						}
//					} else if (property.type.isType(Vector)) {
////						__log.debug("don't support property [0] type is vector", property.name);
//					} else {
//						if (proto.hasOwnProperty(property.name)) {
//							property.setValue(instance, toInstance(proto[property.name], property.type.getClass()));
//						} else {
////							__log.debug("not found [0]'s property [1] in object", clsInfo.getClass(), property.name);
//						}
//					}
//				}
//			}
//		}
	}
}