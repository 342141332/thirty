package com.gearbrother.mushroomWar.model {
	import com.gearbrother.mushroomWar.rpc.protocol.bussiness.PointBeanProtocol;


	/**
	 *
	 * @author 	Neo.Zhang
	 * @create 	2014-8-12 下午5:05:16
	 *
	 */
	public class PointBeanModel extends PointBeanProtocol {
		public function PointBeanModel(prototype:Object = null) {
			super(prototype);
		}
		
		public function distancePoint(d:PointBeanModel):Number {
			return Math.sqrt(Math.pow(x - d.x, 2) + Math.pow(y - d.y, 2));
		}
		
		public function distance(toX:Number, toY:Number):Number {
			return Math.sqrt(Math.pow(x - toX, 2) + Math.pow(y - toY, 2));
		}
	}
}
