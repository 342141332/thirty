package com.gearbrother.sheepwolf.model {
	import com.gearbrother.glash.mvc.model.GBean;
	import com.gearbrother.sheepwolf.GameMain;
	import com.gearbrother.sheepwolf.rpc.protocol.bussiness.BattleUserActionSkillUsingProtocol;
	import com.gearbrother.sheepwolf.view.layer.scene.battle.BattleSceneViewCanvas;


	/**
	 * @author lifeng
	 * @create on 2014-6-9
	 */
	public class BattleUserActionSkillUsingModel extends BattleUserActionSkillUsingProtocol {
		public var battleUser:BattleItemUserModel;
		
		public var battleSceneView:BattleSceneViewCanvas;
		
		public var waitingForResponse:Boolean;
		
		public function BattleUserActionSkillUsingModel(prototype:Object = null) {
			super(prototype);
		}
		
		public function process():void {
			if (waitingForResponse)
				return;

			if (GameModel.instance.application.serverTime > currentTime + skill.level.preUseCause) {
				GameMain.instance.battleService.skillUse(0, {});
				waitingForResponse = true;
			}
		}
		
		override public function merge(source:GBean):void {
			super.merge(source);
			
			waitingForResponse = (source as BattleUserActionSkillUsingModel).waitingForResponse;
		}
	}
}
