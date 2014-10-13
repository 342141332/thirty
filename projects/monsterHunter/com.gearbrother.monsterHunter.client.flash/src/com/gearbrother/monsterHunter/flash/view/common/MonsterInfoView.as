package com.gearbrother.monsterHunter.flash.view.common {
	import com.gearbrother.glash.display.GSkinSprite;
	import com.gearbrother.glash.display.IGDndable;
	import com.gearbrother.glash.display.control.text.GText;
	import com.gearbrother.glash.display.event.GDndEvent;
	import com.gearbrother.glash.display.filter.GFilter;
	import com.gearbrother.glash.mvc.model.GBeanPropertyEvent;
	import com.gearbrother.glash.util.math.GRandomUtil;
	import com.gearbrother.monsterHunter.flash.GameMain;
	import com.gearbrother.monsterHunter.flash.command.GameCommandMap;
	import com.gearbrother.monsterHunter.flash.event.MonsterEvent;
	import com.gearbrother.monsterHunter.flash.model.MonsterModel;
	import com.gearbrother.monsterHunter.flash.model.SkillBookModel;
	import com.gearbrother.monsterHunter.flash.model.SkillModel;
	import com.gearbrother.monsterHunter.flash.skin.common.MonsterInfoSkin;
	
	import flash.events.Event;


	/**
	 * @author feng.lee
	 * create on 2013-1-4 下午5:37:30
	 */
	public class MonsterInfoView extends GSkinSprite implements IGDndable {
		public var rankLabel:GText;
		
		public var nameLabel:GText;
		
		public var levelLabel:GText;
		
		public var attackDamageLabel:GText;
		
		public var attackArmorLabel:GText;
		
		public var abilityPowerLabel:GText;
		
		public var abilityArmorLabel:GText;
		
		public var healthLabel:GText;
		
		public var speedLabel:GText;

		public var avatarView:AvatarView;

		public var skill1:SkillIconView;
		public var skill2:SkillIconView;
		public var skill3:SkillIconView;
		public var skill4:SkillIconView;
		
		private var _highLight:GFilter;
		
		public function get dndData():* {
			return data;
		}

		override public function set data(value:*):void {
			if (!data is MonsterModel)
				throw new Error("only MonsterModel");
			
			super.data = value;
		}
		
		private function get model():MonsterModel {
			return data as MonsterModel;
		}
		
		public function MonsterInfoView() {
			var skin:MonsterInfoSkin = new MonsterInfoSkin();
			super(skin);

			_highLight = GFilter.getBright(100);
			nameLabel = new GText(skin.nameLabel);
			nameLabel.visible = false;
			rankLabel = new GText(skin.rankLabel);
			levelLabel = new GText(skin.levelLabel);
			attackDamageLabel = new GText(skin.attackDamageLabel);
			attackArmorLabel = new GText(skin.attackArmorLabel);
			abilityPowerLabel = new GText(skin.abilityPowerLabel);
			abilityArmorLabel = new GText(skin.abilityArmorLabel);
			healthLabel = new GText(skin.healthLabel);
			speedLabel = new GText(skin.speedLabel);

			skin.removeChild(skin.avatar);
			avatarView = new AvatarView();
			avatarView.x = skin.avatar.x + (skin.avatar.width >> 1);
			avatarView.y = skin.avatar.y + skin.avatar.height;
			addChild(avatarView);

			skill1 = new SkillIconView(skin.skill1);
			skill1.addEventListener(GDndEvent.Drop, _handleDragEvent);
			skill2 = new SkillIconView(skin.skill2);
			skill2.addEventListener(GDndEvent.Drop, _handleDragEvent);
			skill3 = new SkillIconView(skin.skill3);
			skill3.addEventListener(GDndEvent.Drop, _handleDragEvent);
			skill4 = new SkillIconView(skin.skill4);
			skill4.addEventListener(GDndEvent.Drop, _handleDragEvent);
		}

		override protected function doInit():void {
			super.doInit();
			
			GameMain.instance.dragLayer.addEventListener(Event.CHANGE, _handleDragEvent);
		}
		
		private function _handleDragEvent(event:Event):void {
			var skillIcons:Array = [skill1, skill2, skill3, skill4];
			switch (event.type) {
				case Event.CHANGE:
					for each (var skillIcon:SkillIconView in skillIcons) {
						if (GameMain.instance.dragLayer.dragData is SkillBookModel
								&& skillIcon.data is SkillModel
								&& (skillIcon.data as SkillModel).confID == (GameMain.instance.dragLayer.dragData as SkillBookModel).confID) {
							_highLight.apply(skillIcon);
						} else {
							_highLight.unapply(skillIcon);
						}
					}
					break;
				case GDndEvent.Drop:
					var skillIconIndex:int = skillIcons.indexOf(event.currentTarget);
					if (skillIconIndex != -1 && GameMain.instance.dragLayer.dragData is SkillBookModel) {
						GameCommandMap.instance._eventDispatcher.dispatchEvent(
							MonsterEvent.getAddSkillExpEvent(data, skillIconIndex, GameMain.instance.dragLayer.dragData)
						);
					}
					break;
			}
		}
		
		override public function handleModelChanged(events:Object=null):void {
			if (!events) {
				var monster:MonsterModel = data;
				nameLabel.value = monster.name;
				rankLabel.value = monster.rankStr;
				levelLabel.value = "Lv." + monster.level;
				avatarView.data = monster;
				var skillIcons:Array = [skill1, skill2, skill3, skill4];
				for (var i:int = 0; i < skillIcons.length; i++) {
					var skillIcon:SkillIconView = skillIcons[i];
					if (monster.skills.length > i)
						skillIcon.data = monster.skills[i];
					else
						skillIcon.visible = false;
				}
				attackDamageLabel.value = monster.attackDamage + " + " + GRandomUtil.integer(1, 2) * monster.rank;
				attackArmorLabel.value = monster.attackArmor + " + " + GRandomUtil.integer(1, 2) * monster.rank;
				abilityPowerLabel.value = monster.abilityPower + " + " + GRandomUtil.integer(1, 2) * monster.rank;
				abilityArmorLabel.value = monster.abilityArmor + " + " + GRandomUtil.integer(1, 2) * monster.rank;
				healthLabel.value = monster.hp;
				speedLabel.value = monster.speed;
			}
		}
		
		override protected function doDispose():void {
			GameMain.instance.dragLayer.removeEventListener(Event.CHANGE, _handleDragEvent);
			
			super.doDispose();
		}
	}
}
