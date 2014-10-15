package com.gearbrother.glash.net {
	import flash.net.*;
	import flash.utils.*;

	/**
	 * Socket消息聚合器接口
	 * 针对不同的协议, 用于组装从socket中拿到的buff来组装个个协议的包
	 * @author feng.lee
	 * 
	 */	
	public interface IGSocketDataAssembler {
		function reset():void;

		/**
		 * 
		 * @param socket
		 * @return 当前从socket中获得buff是否能组装成一个消息
		 * @see com.gearbrother.glash.net.impl.connection.DataAssembleResult
		 */		
		function assemble(socket:Socket):int;

		function getAssembledDatas():ByteArray;
	}
}