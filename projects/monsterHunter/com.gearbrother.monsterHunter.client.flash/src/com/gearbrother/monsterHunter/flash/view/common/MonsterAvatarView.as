package com.gearbrother.monsterHunter.flash.view.common {
	import com.gearbrother.glash.common.resource.type.GAliasFile;
	import com.gearbrother.glash.common.resource.type.GBmdDefinition;
	import com.gearbrother.glash.common.resource.type.GDefinition;
	import com.gearbrother.glash.display.GMovieBitmap;
	import com.gearbrother.glash.display.GSkinSprite;
	import com.gearbrother.glash.display.GSprite;
	import com.gearbrother.glash.paper.display.item.GPaperSprite;
	import com.gearbrother.glash.paper.display.layer.GPaperLayer;
	import com.gearbrother.monsterHunter.flash.model.MonsterModel;
	import com.gearbrother.monsterHunter.flash.model.SkillModel;

	import flash.display.Sprite;


	/**
	 * @author feng.lee
	 * create on 2012-12-3 下午6:47:16
	 */
	public class MonsterAvatarView extends AvatarView {

		public function get model():MonsterModel {
			return data as MonsterModel;
		}

		override public function set data(newValue:*):void {
			if (!newValue is MonsterModel)
				throw new Error("only accept MonsterModel");

			super.data = newValue;
			_name.value = model.rankStr + ".lv." + model.level + model.name;
		}

		public function MonsterAvatarView(layer:GPaperLayer = null) {
			super(layer);
			_name.y = -100;
		}
	}
}
