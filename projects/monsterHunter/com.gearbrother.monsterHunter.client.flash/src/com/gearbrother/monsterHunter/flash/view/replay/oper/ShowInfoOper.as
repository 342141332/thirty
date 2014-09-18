package com.gearbrother.monsterHunter.flash.view.replay.oper {
	import com.gearbrother.monsterHunter.flash.view.replay.ReplayMonsterView;
	import com.gearbrother.monsterHunter.flash.view.scene.SceneReplayView;
	
	import com.gearbrother.glash.common.oper.GOper;


	/**
	 * @author feng.lee
	 * create on 2012-12-10 下午6:21:52
	 */
	public class ShowInfoOper extends ReplayOper {
		private var _actorView:ReplayMonsterView;
		
		public function ShowInfoOper(actorView:ReplayMonsterView, replayView:SceneReplayView) {
			super(replayView);
			
			_actorView = actorView;
		}
		
		override public function execute():void {
			super.execute();
			
			
		}
	}
}
