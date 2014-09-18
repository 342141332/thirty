package com.gearbrother.monsterHunter.flash.view.replay.oper {
	import com.gearbrother.monsterHunter.flash.view.replay.ReplayMonsterView;
	import com.gearbrother.monsterHunter.flash.view.scene.SceneReplayView;
	
	import com.gearbrother.glash.common.oper.GOper;

	public class SetPropertyOper extends ReplayOper {
		private var _actorView:*;
		
		public var properties:Object;
		
		public function SetPropertyOper(actorView:*, properties:Object, replayView:SceneReplayView) {
			super(replayView);
			
			_actorView = actorView;
			this.properties = properties;
		}
		
		override public function execute():void {
			for (var propertyKey:String in properties) {
				_actorView[propertyKey] = properties[propertyKey];
			}
			
			super.execute();
			result();
		}
	}
}
