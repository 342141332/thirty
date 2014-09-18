package com.gearbrother.monsterHunter.flash.command {
	import com.gearbrother.glash.common.utils.GHandler;
	import com.gearbrother.monsterHunter.flash.GameMain;
	import com.gearbrother.monsterHunter.flash.event.ExploreMapEvent;
	import com.gearbrother.monsterHunter.flash.model.ExploreMapModel;
	import com.gearbrother.monsterHunter.flash.protocal.GameResponseDomain;
	import com.gearbrother.monsterHunter.flash.view.scene.SceneExploreMapView;
	import com.gearbrother.monsterHunter.flash.view.scene.SceneReplayView;

	/**
	 * @author feng.lee
	 * @create on 2013-3-4
	 */
	public class ExploreMapCommand extends GameCommand {
		public var event:ExploreMapEvent;
		
		public function ExploreMapCommand() {
			super();
		}
		
		override public function execute():void {
			switch (event.type) {
				case ExploreMapEvent.GET:
					service.enterExploreMap(event.mapID, handleResponse);
					break;
				case ExploreMapEvent.HUNT:
					service.hunt(event.mapID, event.monsterID, handleResponse);
					break;
				case ExploreMapEvent.CATCH:
					service.catchMonster(event.replayID, event.monsterID, handleResponse);
					break;
				case ExploreMapEvent.FIGHT:
					service.fightHunter(event.hunterID, handleResponse);
					break;
			}
		}
		
		override public function result(body:Object):void {
			super.result(body);
			
			switch (event.type) {
				case ExploreMapEvent.GET:
					var view:SceneExploreMapView = new SceneExploreMapView();
					view.data = decodeExploreMap(body[GameResponseDomain.SCENE]);
					GameMain.instance.sceneLayer.scene = view;
					model.loginedUser.mapID = event.mapID;
					break;
				case ExploreMapEvent.HUNT:
					var view2:SceneReplayView = new SceneReplayView();
					view2.data = decodeReplay(body[GameResponseDomain.REPLAY]);
					GameMain.instance.sceneLayer.scene = view2;
					break;
				case ExploreMapEvent.CATCH:
					if (body[GameResponseDomain.PRIVATE])
						model.loginedUser.monsters = model.loginedUser.monsters.concat(decodeMonster(body[GameResponseDomain.PRIVATE]));
					break;
				case ExploreMapEvent.FIGHT:
					var view3:SceneReplayView = new SceneReplayView();
					view3.data = decodeReplay(body[GameResponseDomain.REPLAY]);
					GameMain.instance.sceneLayer.scene = view3;
					break;
			}
		}
	}
}
