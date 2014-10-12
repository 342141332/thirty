package com.gearbrother.mushroomWar.model {
	import com.gearbrother.mushroomWar.rpc.protocol.bussiness.Protocol;
	
	/**
	 * @author lifeng
	 * @create on 2014-1-6
	 */
	public class ModelRegister {
		{
			Protocol.protocols[Protocol.CharacterModel] = CharacterModel;
			Protocol.protocols[Protocol.Skill] = SkillModel;
			Protocol.protocols[Protocol.Application] = ApplicationModel;
			Protocol.protocols[Protocol.Battle] = BattleModel;
			Protocol.protocols[Protocol.PointBean] = PointBeanModel;
			Protocol.protocols[Protocol.BattleRoom] = BattleRoomModel;
			Protocol.protocols[Protocol.BattleRoomSeat] = BattleRoomSeatModel;
			Protocol.protocols[Protocol.BattleItem] = BattleItemModel;
			Protocol.protocols[Protocol.Hall] = HallModel;
			Protocol.protocols[Protocol.Bounds] = BoundsModel;
			Protocol.protocols[Protocol.User] = UserModel;
			Protocol.protocols[Protocol.Equip] = EquipModel;
		}
	}
}
