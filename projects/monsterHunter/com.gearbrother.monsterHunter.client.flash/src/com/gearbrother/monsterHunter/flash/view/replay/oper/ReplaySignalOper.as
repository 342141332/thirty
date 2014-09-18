package com.gearbrother.monsterHunter.flash.view.replay.oper {
	import com.gearbrother.glash.common.oper.GQueue;
	import com.gearbrother.glash.common.resource.type.GBmdDefinition;
	import com.gearbrother.monsterHunter.flash.model.MonsterModel;
	import com.gearbrother.monsterHunter.flash.model.ReplaySignalModel;
	import com.gearbrother.monsterHunter.flash.view.replay.ReplayMonsterView;
	import com.gearbrother.monsterHunter.flash.view.scene.SceneReplayView;
	
	import flash.geom.Point;


	/**
	 * 播放技能Icon -》
	 * @author 		lifeng
	 * @version 	1.0.0
	 * create on	2012-12-8 下午6:30:44
	 */
	public class ReplaySignalOper extends GQueue {
		private var _signal:ReplaySignalModel;

		public function get priority():uint {
			return 0;
		}

		public function get actorView():ReplayMonsterView {
			return _replayView.getActorView(_signal.actor.id);
		}

		private var _replayView:SceneReplayView;
		public function get replayView():SceneReplayView {
			return _replayView;
		}

		private var _resources:Array;
		public function get resources():Array {
			return _resources.concat();
		}
		
		public function ReplaySignalOper(signal:ReplaySignalModel, replayView:SceneReplayView) {
			autoStart = false;
			_signal = signal;
			_replayView = replayView;
			_resources = [];
			var actor:MonsterModel = _signal.actor;
			_resources.push(_signal.skill.conf.icon);
			_resources.push(_signal.skill.conf.movieDefinition);
			_resources.push(_signal.skill.conf.actorMovieID == 0 ? actor.definitionADMovie : actor.definitionApMovie);
		}
		
		override public function execute():void {
			_replayView.roundLabel.text = String(_signal.round);
			var resultOneActorModel:MonsterModel = _signal.results[0];
			var resultOneActorView:ReplayMonsterView = _replayView.getActorView(resultOneActorModel.id);
			new SelectOper(_replayView, actorView).commit(this);
			var def:GBmdDefinition = _signal.skill.conf.actorMovieID == 0
				? _signal.actor.definitionADMovie : _signal.actor.definitionApMovie;
			var resetProperOper:SetPropertyOper;
			if (actorView != resultOneActorView) {
				if (_signal.skill.conf.needClose) {
					resetProperOper = new SetPropertyOper(actorView, {direction: actorView.direction}, _replayView);
//					var hitInfo:GBmdsInfo = _replayView.resloader.getResource(def);
					var target:Point// = hitInfo.userData["target"];
					if (!target) {
						target = new Point(70);
						logger.warn("not found target in movie {0}", [def]);
					}
					var toPoint:Point = new Point();
					if (actorView.x > resultOneActorView.x) {
						toPoint.x = resultOneActorView.x + Math.abs(target.x);
						new SetPropertyOper(actorView, {direction: actorView.direction}, _replayView).commit(this);
					} else {
						toPoint.x = resultOneActorView.x - Math.abs(target.x);
						new SetPropertyOper(actorView, {direction: actorView.direction}, _replayView).commit(this);
					}
					toPoint.y = resultOneActorView.y;
					new MoveOper(actorView, toPoint, _replayView).commit(this);
				}
			}
			new ArmedSkillVisibleOper(actorView, _signal.skill).commit(this);
			new SkillDoOper(actorView, _signal, def).commit(this);
			var currentAt:int = replayView.signalViews.indexOf(this);
			var nextSignal:ReplaySignalOper = (replayView.signalViews.length > currentAt + 1) ? replayView.signalViews[++currentAt] : null;
			if ((nextSignal && nextSignal._signal.actor != _signal.actor) || !nextSignal)
				new MoveOper(actorView
					, replayView.positionTransformer.locationToPixel(actorView.actorModel.fomat, 1)
					, _replayView).commit(this);
			if (resetProperOper) {
				resetProperOper.commit(this);
			}
			
			super.execute();
		}
	}
}
