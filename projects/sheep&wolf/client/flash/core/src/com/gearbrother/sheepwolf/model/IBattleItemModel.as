package com.gearbrother.sheepwolf.model {
	import com.gearbrother.sheepwolf.rpc.protocol.bussiness.BoundsProtocol;

	/**
	 *
	 * @author 	Neo.Zhang
	 * @create 	2014-7-28 下午5:51:10
	 *
	 */
	public interface IBattleItemModel extends IQuadTreeable {
		function get uuid():String;

		function get cartoon():String;

		function get battle():BattleModel;

		function set battle(newValue:BattleModel):void;
		
		function get layer():String;
		
		function get isDestoryable():Boolean;
		
		function get hp():int;
		
		function get maxHp():int;

		function intersect(item:IBattleItemModel):Boolean;

		function get validTime1():Number;

		function get validTime2():Number;

		function get isCollisionable():Boolean;
		
		function get isSheepPassable():Boolean;
		
		function get isWolfPassable():Boolean;
		
		function isBlock(item:IBattleItemModel):Boolean;
		
		function get touchAutoRemoteCall():String;
		
		function get touchManualRemoteCall():String;
		
		function encode():Object;
	}
}
