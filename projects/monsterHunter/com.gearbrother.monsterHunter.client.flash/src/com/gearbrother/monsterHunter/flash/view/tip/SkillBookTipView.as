package com.gearbrother.monsterHunter.flash.view.tip {
	import com.gearbrother.glash.display.GSkinSprite;
	import com.gearbrother.monsterHunter.flash.skin.GreyTipSkin;
	import com.gearbrother.monsterHunter.flash.skin.tip.SkillBookTipSkin;
	
	import flash.display.DisplayObject;


	/**
	 * @author feng.lee
	 * create on 2013-2-18
	 */
	public class SkillBookTipView extends GSkinSprite {
		public function SkillBookTipView() {
			var skin:SkillBookTipSkin = new SkillBookTipSkin();
			super(skin);
		}
	}
}
