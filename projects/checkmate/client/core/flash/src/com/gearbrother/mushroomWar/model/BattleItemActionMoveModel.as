package com.gearbrother.mushroomWar.model {
	
	import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BattleItemActionMoveProtocol;
	
	import flash.geom.Point;

	public class BattleItemActionMoveModel extends BattleItemActionMoveProtocol {
		static public const DIRECTION_UP:int = 1;
		
		static public const DIRECTION_RIGHT:int = 2;
		
		static public const DIRECTION_DOWN:int = 3;
		
		static public const DIRECTION_LEFT:int = 4;

		public function BattleItemActionMoveModel(prototype:Object = null) {
			super(prototype);
		}
	}
}
