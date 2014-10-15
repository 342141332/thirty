package com.gearbrother.monsterHunter.flash.view.tip {
	import com.gearbrother.glash.display.GSkinSprite;
	import com.gearbrother.monsterHunter.flash.skin.GreyTipSkin;
	
	import flash.display.DisplayObject;


	/**
	 * @author feng.lee
	 * create on 2013-2-18
	 */
	public class SkillTipView extends GSkinSprite {
		public function SkillTipView() {
			var skin:GreyTipSkin = new GreyTipSkin();
			super(skin);
		}
	}
}
