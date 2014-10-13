package com.gearbrother.mushroomWar.view.common.ui {
	import com.gearbrother.glash.display.GMovieBitmap;
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.IGDndable;
	import com.gearbrother.glash.display.control.GLoader;
	import com.gearbrother.glash.display.control.text.GText;
	import com.gearbrother.glash.util.display.GDisplayUtil;
	import com.gearbrother.mushroomWar.model.CharacterModel;
	import com.gearbrother.mushroomWar.model.BattleRoomSeatModel;
	import com.gearbrother.mushroomWar.model.SkillModel;
	import com.gearbrother.mushroomWar.rpc.protocol.bussiness.EquipProtocol;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;


	/**
	 * @author lifeng
	 * @create on 2014-1-6
	 */
	public class RoomSeatUiView extends GNoScale implements IGDndable {
		public var headPortraint:GLoader;
		
		public var stars:Array;

		public var nameLabel:GText;
		
		public var expLabel:GText;
		
		public var hpLabel:GText;

		public var armorLabel:GText;
		
		public var powerLabel:GText;
		
		public var speedLabel:GText;
		
		public var choosedHeroViews:Vector.<AvatarUiView>;
		
		public var weaponViews:Array;
		
		public var toolViews:Array;
		
		override public function set data(newValue:*):void {
			super.data = bindData = newValue;
		}
		
		private var _dndable:Boolean;
		public function get dndable():Boolean {
			return _dndable;
		}
		public function set dndable(newValue:Boolean):void {
			_dndable = newValue;
		}

		public function RoomSeatUiView(skin:DisplayObjectContainer) {
			super(skin);

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
			choosedHeroViews = new Vector.<AvatarUiView>();
			for (var i:int = 0;;i++) {
				var avatarSkin:DisplayObject = skin.getChildByName("choosedHero" + i);
				if (avatarSkin) {
					choosedHeroViews.push(new AvatarUiView(avatarSkin as Sprite));
				} else {
					break;
				}
			}
			weaponViews = [];
			for (i = 0;;i++) {
				var child:DisplayObject = skin.getChildByName("weapon" + i);
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
			var model:BattleRoomSeatModel = bindData as BattleRoomSeatModel;
			for (var i:int = 0; i < choosedHeroViews.length; i++) {
				var choosedHeroUiView:AvatarUiView = choosedHeroViews[i];
				choosedHeroUiView.bindData = model ? model.choosedHeroes[i] : null;
			}
			if (nameLabel)
				nameLabel.text = model ? model.name : "";
		}
	}
}
