package com.gearbrother.monsterHunter.flash.view.replay.oper {
	import com.gearbrother.glash.common.oper.GOper;
	import com.gearbrother.glash.common.resource.type.GAliasFile;
	import com.gearbrother.glash.common.resource.type.GBmdDefinition;
	import com.gearbrother.glash.common.resource.type.GDefinition;
	import com.gearbrother.glash.display.GMovieBitmap;
	import com.gearbrother.glash.display.event.GDisplayEvent;
	import com.gearbrother.glash.display.event.GDisplayEvent;
	import com.gearbrother.glash.display.filter.GFilter;
	import com.gearbrother.monsterHunter.flash.GameMain;
	import com.gearbrother.monsterHunter.flash.model.MonsterModel;
	import com.gearbrother.monsterHunter.flash.model.ReplaySignalModel;
	import com.gearbrother.monsterHunter.flash.view.replay.ReplayMonsterView;
	import com.gearbrother.monsterHunter.flash.view.scene.SceneReplayView;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import flash.events.IEventDispatcher;


	/**
	 * @author feng.lee
	 * create on 2012-12-10 下午6:23:43
	 */
	public class SkillDoOper extends GOper {
		private var _actorView:ReplayMonsterView;
		
		private var _signal:ReplaySignalModel;
		
		private var _def:GBmdDefinition;
		
		private var brightFilter:GFilter = GFilter.getBright(100);
		
		private var blurFilter:GFilter = GFilter.getBlur(1.3, 1);

		public function SkillDoOper(actorView:ReplayMonsterView, signal:ReplaySignalModel, def:GBmdDefinition) {
			super();

			_actorView = actorView;
			_signal = signal;
			_def = def;
		}

		override public function execute():void {
			super.execute();

			_actorView.movie.definition = _def;
			_actorView.movie.setLabel(null, 1);
			_actorView.movie.addEventListener(GDisplayEvent.LABEL_QUEUE_END, _handleMovieEvent);
			_actorView.movie.addEventListener(GDisplayEvent.LABEL_QUEUE_START, _handleMovieEvent);
		}
		
		private function _handleMovieEvent(event:GDisplayEvent):void {
			if (event.type == GDisplayEvent.LABEL_QUEUE_START) {
				if (event.labelName == ReplayMonsterView.label_playInjured) {
					for each (var result:MonsterModel in _signal.results) {
						var resultActorView:ReplayMonsterView = _actorView.replayView.getActorView(result.id);
						var damage:int = result.hp - resultActorView.actorModel.hp;
						resultActorView.actorModel.hp = result.hp;
						if (damage < -20) {
							//TODO scenelayer is in layout,
							TweenMax.to(GameMain.instance.sceneLayer, .9, {shake: {y: 17, num: 4}});
						}
						if (false) {
							//do nothing
						} else if (resultActorView.actorModel.hp > 0) {
							resultActorView.movie.paused = true;
//							TweenLite.to(resultActorView, .5, {x: resultActorView.x + 5, onComplete: onInjuredComplete, onCompleteParams: [resultActorView]});
//							brightFilter.apply(resultActorView.movie);
//							blurFilter.apply(resultActorView.movie);
						} else {
							resultActorView.movie.paused = true;
							TweenMax.to(resultActorView, .7, {autoAlpha: .0});
//							resultActorView.movie.filters = GFilterUtil.getBlackWhiteFilter();
						}
						var skillMovie:GMovieBitmap = new GMovieBitmap(10);
						skillMovie.definition = _signal.skill.conf.movieDefinition;
						skillMovie.playOnce = true;
						resultActorView.addChild(skillMovie);
					}
				}
			} else if (event.type == GDisplayEvent.LABEL_QUEUE_END) {
				_actorView.movie.removeEventListener(GDisplayEvent.LABEL_QUEUE_END, _handleMovieEvent);
				_actorView.movie.removeEventListener(GDisplayEvent.LABEL_QUEUE_START, _handleMovieEvent);
				_actorView.movie.definition = _actorView.actorModel.definitionStand;
				_actorView.movie.setLabel(null);
				this.result();
			}
		}
		
		private function onInjuredComplete(view:ReplayMonsterView):void {
			view.movie.paused = false;
			brightFilter.unapply(view.movie);
			blurFilter.unapply(view.movie);
		}
	}
}
