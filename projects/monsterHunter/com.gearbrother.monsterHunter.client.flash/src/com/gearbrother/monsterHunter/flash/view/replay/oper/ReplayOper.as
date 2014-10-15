package com.gearbrother.monsterHunter.flash.view.replay.oper {
	import com.gearbrother.monsterHunter.flash.view.scene.SceneReplayView;
	
	import com.gearbrother.glash.common.oper.GOper;


	/**
	 * @author feng.lee
	 * create on 2012-12-11 下午6:17:14
	 */
	public class ReplayOper extends GOper {
		protected var _replayView:SceneReplayView;
		
		public function ReplayOper(replayView:SceneReplayView) {
			super();
			
			_replayView = replayView;
		}
	}
}
