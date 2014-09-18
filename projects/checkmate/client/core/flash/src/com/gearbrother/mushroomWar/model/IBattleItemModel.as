package com.gearbrother.mushroomWar.model {
	import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BoundsProtocol;

	/**
	 *
	 * @author 	Neo.Zhang
	 * @create 	2014-7-28 下午5:51:10
	 *
	 */
	public interface IBattleItemModel extends IQuadTreeable {
		function get instanceId():String;

		function get cartoon():String;

		function get battle():BattleModel;

		function set battle(newValue:BattleModel):void;

		function get layer():String;

		function get hp():int;

		function get maxHp():int;

		function get ownerId():String;
		
		function get currentAction():Object;

		function encode():Object;
	}
}
