package com.gearbrother.sheepwolf.model {
	import com.gearbrother.sheepwolf.rpc.protocol.bussiness.Protocol;
	
	/**
	 * @author lifeng
	 * @create on 2014-1-6
	 */
	public class ModelRegister {
		{
			Protocol.protocols[Protocol.Avatar] = AvatarModel;
			Protocol.protocols[Protocol.Skill] = SkillModel;
			Protocol.protocols[Protocol.Application] = ApplicationModel;
			Protocol.protocols[Protocol.Battle] = BattleModel;
			Protocol.protocols[Protocol.PointBean] = PointBeanModel;
			Protocol.protocols[Protocol.BattleRoom] = BattleRoomModel;
			Protocol.protocols[Protocol.BattleBuff] = BattleBuffModel;
			Protocol.protocols[Protocol.BattleItem] = BattleItemModel;
			Protocol.protocols[Protocol.BattleItemUser] = BattleItemUserModel;
			Protocol.protocols[Protocol.BattleItemTemplate] = BattleItemTemplateModel;
			Protocol.protocols[Protocol.BattleUserActionWalk] = BattleUserActionWalkModel;
			Protocol.protocols[Protocol.BattleUserActionSkillUsing] = BattleUserActionSkillUsingModel;
			Protocol.protocols[Protocol.Hall] = HallModel;
			Protocol.protocols[Protocol.Bounds] = BoundsModel;
			Protocol.protocols[Protocol.User] = UserModel;
			Protocol.protocols[Protocol.Equip] = EquipModel;
		}
	}
}
