package com.gearbrother.monsterHunter.flash.view.replay.oper {
	import com.gearbrother.monsterHunter.flash.model.MonsterModel;
	import com.gearbrother.monsterHunter.flash.model.SkillModel;
	import com.gearbrother.monsterHunter.flash.view.replay.ArmedSkillPane;
	import com.gearbrother.monsterHunter.flash.view.replay.ReplayMonsterView;
	import com.greensock.TweenLite;


	/**
	 * @author feng.lee
	 * create on 2012-12-10 下午6:21:52
	 */
	public class ArmedSkillVisibleOper extends ReplayOper {
		private var _actorView:ReplayMonsterView;
		
		private var _selectedSkill:SkillModel;
		
		public function ArmedSkillVisibleOper(actorView:ReplayMonsterView, skill:SkillModel) {
			super(actorView.replayView);
			
			_selectedSkill = skill;
			_actorView = actorView;
		}
		
		override public function execute():void {
			super.execute();
			
//			_replayView.infolayer.addChild(propertyPane);

			var armedSkillBar:ArmedSkillPane;
			if (_replayView.armedSkilllayer.numChildren > 0)
				armedSkillBar = _replayView.armedSkilllayer.getChildAt(0) as ArmedSkillPane;
			else
				armedSkillBar = new ArmedSkillPane();
			armedSkillBar.selectSkill = _selectedSkill;
			_replayView.armedSkilllayer.addChild(armedSkillBar);
			armedSkillBar.validateLayoutNow();
			armedSkillBar.x = _actorView.x - (armedSkillBar.preferredSize.width >> 1);
			armedSkillBar.y = _actorView.y + 10;
			result();
			/*if (armedSkillBar.parent) {
				result();
			} else {
				_replayView.infolayer.addChild(armedSkillBar);
				armedSkillBar.x = _actorView.x - (armedSkillBar.width >> 1);
				armedSkillBar.y = _actorView.y + 10;
				var icons:Array = [];
				for (var i:int = 0; i < armedSkillBar.numChildren; i++) {
					var icon:DisplayObject = armedSkillBar.getChildAt(i);
					icon.alpha = icon.scaleX = icon.scaleY = .0;
					icons.push(icon);
				}
				TweenMax.allTo(icons, .3, {transformAroundCenter:{scaleX: 1.0, scaleY: 1.0}, alpha: 1.0, onComplete: result});
			}*/
		}
	}
}
