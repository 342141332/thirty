package com.gearbrother.mushroomWar.rpc.protocol {
	import com.gearbrother.glash.mvc.model.GBean;
	import com.gearbrother.mushroomWar.rpc.protocol.bussiness.Protocol;
	
	import org.as3commons.lang.ObjectUtils;


	/**
	 * @author lifeng
	 * @create on 2013-11-14
	 */
	public class RpcProtocol extends GBean {
		static public const $CLASS:String = "$class";
		
		static public function prototype2Protocol(prototype:Object):* {
			if (prototype) {
				if (prototype.hasOwnProperty($CLASS) && prototype[$CLASS]) {
					var clazz:Class = Protocol.protocols[prototype[$CLASS]];
					return new clazz(prototype);
				} else if (prototype is Array) {
					var array:Array = [];
					for each (var proto:Object in prototype) {
						array.push(prototype2Protocol(proto));
					}
					return array;
				} else if (prototype["constructor"] == Object) {
					var keys:Array = ObjectUtils.getKeys(prototype);
					for (var i:int = 0; i < keys.length; i++) {
						var k:String = keys[i];
						prototype[k] = prototype2Protocol(prototype[k]);
					}
					return prototype;
				} else if (prototype is int) {
					return prototype;
				} else if (prototype is String) {
					return prototype;
				} else if (prototype is Number) {
					return prototype;
				} else {
					throw new Error("unknown prototype");
				}
			} else {
				return null;
			}
		}

		public function RpcProtocol(prototype:Object = null) {
			super(prototype);
		}
	}
}
