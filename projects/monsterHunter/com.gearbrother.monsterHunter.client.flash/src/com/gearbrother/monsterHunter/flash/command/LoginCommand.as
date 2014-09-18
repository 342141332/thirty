package com.gearbrother.monsterHunter.flash.command {
	import com.gearbrother.glash.common.utils.GHandler;
	import com.gearbrother.monsterHunter.flash.GameMain;
	import com.gearbrother.monsterHunter.flash.event.ExploreMapEvent;
	import com.gearbrother.monsterHunter.flash.event.LoginEvent;
	import com.gearbrother.monsterHunter.flash.model.GameModel;
	import com.gearbrother.monsterHunter.flash.model.HunterModel;
	import com.gearbrother.monsterHunter.flash.protocal.GameResponse;
	import com.gearbrother.monsterHunter.flash.protocal.GameResponseDomain;
	import com.gearbrother.monsterHunter.flash.view.scene.SceneExploreMapView;
	import com.gearbrother.monsterHunter.flash.view.scene.SceneGlobalMapView;

	/**
	 * @author feng.lee
	 * create on 2013-2-26
	 */
	public class LoginCommand extends GameCommand {
		public var event:LoginEvent;

		public function LoginCommand() {
			super();
		}

		override public function execute():void {
			service.login(handleResponse);
		}

		override public function result(body:Object):void {
			super.result(body);

			GameMain.instance.sceneLayer.scene = new SceneGlobalMapView();/*new SceneReplayView();*/
//			GameCommandMap.instance._eventDispatcher.dispatchEvent(ExploreMapEvent.getGetEvent(0));
//			GameCommandMap.instance._eventDispatcher.dispatchEvent(new ExploreMapEvent(ExploreMapEvent.HUNT));
		}
	}
}
