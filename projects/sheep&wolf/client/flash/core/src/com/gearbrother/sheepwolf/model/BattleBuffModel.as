package com.gearbrother.sheepwolf.model {
	import com.gearbrother.sheepwolf.rpc.protocol.bussiness.BattleBuffProtocol;


	/**
	 * @author lifeng
	 * @create on 2014-6-16
	 */
	public class BattleBuffModel extends BattleBuffProtocol {
		static public const INVISIBLE:String = "invisible";

		public function BattleBuffModel(prototype:Object = null) {
			super(prototype);
		}
	}
}
