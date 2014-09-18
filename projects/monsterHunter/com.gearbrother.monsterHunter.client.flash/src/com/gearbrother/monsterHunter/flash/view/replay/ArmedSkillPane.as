package com.gearbrother.monsterHunter.flash.view.replay {
	import com.gearbrother.glash.display.container.GContainer;
	import com.gearbrother.glash.display.control.GLoader;
	import com.gearbrother.glash.display.layout.impl.FlowLayout;
	import com.gearbrother.monsterHunter.flash.model.MonsterModel;
	import com.gearbrother.monsterHunter.flash.model.SkillModel;
	import com.gearbrother.monsterHunter.flash.view.common.SkillIconView;

	/**
	 * @author feng.lee
	 * create on 2012-12-23
	 */
	public class ArmedSkillPane extends GContainer {
		static public const UNSELECTED_SIZE:int = 30;
		static public const SELECTED_SIZE:int = 50;
		
		override public function set data(value:*):void {
			if (value is MonsterModel) {
				super.data = value;

				removeAllChildren();
				var armedSkills:Array = (value as MonsterModel).skills;
				for each (var armedSkill:SkillModel in armedSkills) {
					var icon:SkillIconView = new SkillIconView();
					icon.width = icon.height = UNSELECTED_SIZE;
					icon.data = armedSkill;
					addChild(icon);
				}
			} else {
				throw new Error("invalid");
			}
		}

		public function set selectSkill(value:SkillModel):void {
			for (var i:int = 0; i < numChildren; i++) {
				var icon:SkillIconView = getChildAt(i) as SkillIconView;
				if (icon.data == value) {
					icon.width = icon.height = SELECTED_SIZE;
				} else {
					icon.width = icon.height = UNSELECTED_SIZE;
				}
			}
		}

		public function ArmedSkillPane() {
			super();

			width = 200;
			layout = new FlowLayout();
		}
	}
}
