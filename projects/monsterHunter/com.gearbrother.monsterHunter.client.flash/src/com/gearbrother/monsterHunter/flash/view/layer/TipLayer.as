package com.gearbrother.monsterHunter.flash.view.layer {
	import com.gearbrother.glash.display.layer.GTipLayer;
	import com.gearbrother.monsterHunter.flash.model.SkillModel;
	import com.gearbrother.monsterHunter.flash.model.SkillBookModel;
	import com.gearbrother.monsterHunter.flash.view.tip.SkillBookTipView;
	import com.gearbrother.monsterHunter.flash.view.tip.SkillTipView;
	
	import flash.display.DisplayObject;


	/**
	 * @author feng.lee
	 * create on 2013-2-25
	 */
	public class TipLayer extends GTipLayer {
		public function TipLayer() {
			super();
			
			getTipView = _getTipView;
		}
		
		private function _getTipView(data:*):DisplayObject {
			if (data is SkillModel) {
				return new SkillTipView();
			} else if (data is SkillBookModel) {
				return new SkillBookTipView();
			}
			return null;
		}
	}
}
