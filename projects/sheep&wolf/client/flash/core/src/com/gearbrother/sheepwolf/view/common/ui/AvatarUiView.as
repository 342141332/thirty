package com.gearbrother.sheepwolf.view.common.ui {
	import com.gearbrother.glash.display.GMovieBitmap;
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.control.GLoader;
	import com.gearbrother.glash.display.control.text.GText;
	import com.gearbrother.glash.util.display.GDisplayUtil;
	import com.gearbrother.sheepwolf.model.AvatarModel;
	import com.gearbrother.sheepwolf.model.SkillModel;
	import com.gearbrother.sheepwolf.rpc.protocol.bussiness.AvatarProtocol;
	import com.gearbrother.sheepwolf.rpc.protocol.bussiness.EquipProtocol;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;


	/**
	 * @author lifeng
	 * @create on 2014-1-6
	 */
	public class AvatarUiView extends GNoScale {
		public var headPortraint:GLoader;
		
		public var avatar:AvatarView;
		
		public var stars:Array;

		public var nameLabel:GText;
		
		public var expLabel:GText;
		
		public var hpLabel:GText;

		public var armorLabel:GText;
		
		public var powerLabel:GText;
		
		public var speedLabel:GText;
		
		public var parts:Array;

		public var equipIcons:Array;
		
		public var weaponViews:Array;
		
		public var toolViews:Array;
		
		override public function set data(newValue:*):void {
			super.data = bindData = newValue;
		}

		public function AvatarUiView(skin:DisplayObjectContainer) {
			super(skin);

			if (skin["avatar"]) {
				avatar = new AvatarView();
				GDisplayUtil.replace(skin["avatar"], avatar);
			}
			if (skin["headPortraint"]) {
				headPortraint = new GLoader();
				headPortraint.scalePolicy = GLoader.SCALE_POLICY_SCALE;
				headPortraint.replace(skin["headPortraint"]);
			}
			if (skin["nameLabel"])
				nameLabel = new GText(skin["nameLabel"]);
			if (skin["expLabel"])
				expLabel = new GText(skin["expLabel"]);
			if (skin["hpLabel"])
				hpLabel = new GText(skin["hpLabel"]);
			if (skin["armorLabel"])
				armorLabel = new GText(skin["armorLabel"]);
			if (skin["powerLabel"])
				powerLabel = new GText(skin["powerLabel"]);
			if (skin["speedLabel"])
				speedLabel = new GText(skin["speedLabel"]);
			parts = [];
			equipIcons = [];
			for (var i:int = 0; ; i++) {
				var child:DisplayObject = skin.getChildByName("equip" + i);
				if (child) {
					equipIcons.push(new SkillUiView(child));
				} else {
					break;
				}
			}
			weaponViews = [];
			for (i = 0;;i++) {
				child = skin.getChildByName("weapon" + i);
				if (child) {
					weaponViews.push(new SkillUiView(child)); 
				} else {
					break;
				}
			}
			toolViews = [];
			for (i = 0;;i++) {
				child = skin.getChildByName("tool" + i);
				if (child) {
					toolViews.push(new SkillUiView(child)); 
				} else {
					break;
				}
			}
		}

		override public function handleModelChanged(events:Object = null):void {
			var model:AvatarModel = bindData as AvatarModel;
			if (model) {
				if (avatar) {
					avatar.bindData = model;
				}
				if (nameLabel)
					nameLabel.text = model.name;
				if (expLabel)
					expLabel.text = model.exp;
				if (hpLabel)
					hpLabel.text = String(model.level.hp);
				if (armorLabel)
					armorLabel.text = String(model.level.armor);
				if (speedLabel)
					speedLabel.text = String(model.level.move);
				if (!events || events.hasOwnProperty(AvatarProtocol.EQUIPS)) {
					for (var i:int = 0; i < equipIcons.length; i++) {
						var equipView:SkillUiView = equipIcons[i];
						if (model.equips && model.equips.length > i) {
							var weaponModel:EquipProtocol = model.equips[i];
							equipView.bindData = weaponModel;
						} else {
							equipView.bindData = null;
						}
					}
				}
				if (!events || events.hasOwnProperty(AvatarProtocol.SKILLS)) {
					for (i = 0; i < toolViews.length; i++) {
						equipView = toolViews[i];
						if (model.skills && model.skills.length > i) {
							equipView.bindData = model.skills[i];
						} else {
							equipView.bindData = null;
						}
					}
				}
			} else {
				if (avatar)
					avatar.bindData = null;
				if (nameLabel)
					nameLabel.text = "";
				for (i = 0; i < equipIcons.length; i++) {
					equipView = equipIcons[i];
					equipView.bindData = null;
				}
				for (i = 0; i < weaponViews.length; i++) {
					equipView = weaponViews[i];
					equipView.bindData = null;
				}
				for (i = 0; i < toolViews.length; i++) {
					equipView = toolViews[i];
					equipView.bindData = null;
				}
			}
		}
	}
}
