package com.gearbrother.monsterHunter.flash.view.replay.oper {
	
	import com.gearbrother.glash.common.oper.GOper;
	import com.gearbrother.glash.common.resource.type.GAliasFile;
	import com.gearbrother.glash.common.resource.type.GBmdDefinition;
	import com.gearbrother.glash.common.resource.type.GDefinition;
	import com.gearbrother.glash.display.GMovieBitmap;
	import com.gearbrother.monsterHunter.flash.view.replay.ReplayMonsterView;
	import com.gearbrother.monsterHunter.flash.view.scene.SceneReplayView;
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;


	/**
	 * @author feng.lee
	 * create on 2012-12-10 下午6:21:23
	 */
	public class SelectOper extends GOper {
		private var _actorView:ReplayMonsterView;
		private var _replayView:SceneReplayView;
		
		public function SelectOper(replayView:SceneReplayView, actorView:ReplayMonsterView) {
			super();
			
			_replayView = replayView;
			_actorView = actorView;
		}
		
		override public function execute():void {
			super.execute();

			trace("----------------- SelectOper -----------------");
			var _selectCursor:DisplayObject;
			if (_replayView.selectlayer.numChildren == 0) {
				_selectCursor = new GMovieBitmap();
				(_selectCursor as GMovieBitmap).definition = new GBmdDefinition(new GDefinition(new GAliasFile("asset/widget/select_cycle.swf"), "Main"));
				_selectCursor.x = _actorView.x;
				_selectCursor.y = _actorView.y;
				_replayView.selectlayer.addChild(_selectCursor);
				TweenLite.to(_selectCursor, .3, {colorMatrixFilter: {brightness: 1.7}, onComplete: result});
			} else {
				_selectCursor = _replayView.selectlayer.getChildAt(0);
				TweenLite.to(_selectCursor, .3, {x: _actorView.x, y: _actorView.y, onComplete: result});
			}
		}
	}
}
