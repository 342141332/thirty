package com.gearbrother.monsterHunter.flash.view.replay.oper {
	import com.gearbrother.monsterHunter.flash.view.replay.ReplayMonsterView;
	import com.gearbrother.monsterHunter.flash.view.scene.SceneReplayView;
	import com.greensock.TweenLite;

	import flash.geom.Point;

	import com.gearbrother.glash.common.oper.GOper;


	/**
	 * @author feng.lee
	 * create on 2012-12-10 下午6:26:26
	 */
	public class MoveOper extends ReplayOper {
		private var _actorView:ReplayMonsterView;

		private var _closeTo:Point;

		public function MoveOper(actorView:ReplayMonsterView, closeTo:Point, replayView:SceneReplayView) {
			super(replayView);

			_actorView = actorView;
			_closeTo = closeTo;
		}

		override public function execute():void {
			super.execute();

			_actorView.movie.paused = true;
			TweenLite.to(_actorView, .3, {x: _closeTo.x, y: _closeTo.y, onComplete: notifyResult});
		}

		override public function notifyResult(event:* = null):void {
			_actorView.movie.paused = false;
			super.notifyResult(event);
		}
	}
}
