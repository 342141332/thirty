package com.gearbrother.monsterHunter.flash.view.common {
	import com.gearbrother.glash.display.control.text.GText;
	import com.gearbrother.glash.paper.display.layer.GPaperLayer;
	import com.gearbrother.monsterHunter.flash.model.HunterModel;


	/**
	 * @author feng.lee
	 * create on 2013-1-29
	 */
	public class HunterAvatarView extends AvatarView {
		public var follow:MonsterAvatarView;
		
		public function get model():HunterModel {
			return data as HunterModel;
		}
		
		override public function set data(newValue:*):void {
			if (!newValue is HunterModel)
				throw new Error("only accept HunterModel");
			
			super.data = newValue;
		}

		public function HunterAvatarView(layer:GPaperLayer = null) {
			super(layer);
			_name.y = -157;
			_name.fontColor = 0xCCCC00;
		}
	}
}
