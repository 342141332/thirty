package com.gearbrother.mushroomWar.view.layer.scene.battle {
	import com.gearbrother.glash.common.oper.ext.GAliasFile;
	import com.gearbrother.glash.common.oper.ext.GFile;
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.container.GContainer;
	import com.gearbrother.glash.display.container.GHBox;
	import com.gearbrother.glash.display.container.GVBox;
	import com.gearbrother.glash.display.control.GProgress;
	import com.gearbrother.glash.display.control.text.GText;
	import com.gearbrother.glash.display.propertyHandler.GPropertyBindDataHandler;
	import com.gearbrother.glash.util.lang.GDateUtil;
	import com.gearbrother.mushroomWar.model.CharacterModel;
	import com.gearbrother.mushroomWar.model.BattleModel;
	import com.gearbrother.mushroomWar.model.BattleRoomSeatModel;
	import com.gearbrother.mushroomWar.model.GameModel;
	import com.gearbrother.mushroomWar.model.SkillModel;
	import com.gearbrother.mushroomWar.rpc.protocol.bussiness.AvatarLevelProtocol;
	import com.gearbrother.mushroomWar.view.common.ui.AvatarUiView;
	import com.gearbrother.mushroomWar.view.common.ui.ProgressView;
	import com.gearbrother.mushroomWar.view.common.ui.SkillUiView;
	
	import flash.events.MouseEvent;


	/**
	 * @author lifeng
	 * @create on 2014-2-27
	 */
	public class BattleSceneViewUi extends GContainer {
		public var topCenter:GVBox;

		public var clockText:GText;

		public var coinView:Coin;

		private var hp:GProgress;
		
		public var bottomBox:GHBox;
		
		public var skillIcons:GHBox;
		
		public var battle:BattleModel;
		
		private var _bindDataHandler2:GPropertyBindDataHandler;
		public function get bindData2():* {
			return _bindDataHandler2 ? _bindDataHandler2.value : null;
		}
		public function set bindData2(newValue:*):void {
			_bindDataHandler2 ||= new GPropertyBindDataHandler(handleModelChanged, this);
			_bindDataHandler2.value = newValue;
		}
		
		private var _canvas:BattleSceneViewCanvas;
		
		public function BattleSceneViewUi(battle:BattleModel, canvas:BattleSceneViewCanvas) {
			super();

			this.battle = battle;
			_canvas = canvas;
			libs = [new GAliasFile("static/asset/skin/battle.swf")];
		}

		override protected function _handleLibsSuccess(res:*):void {
			var skinFile:GFile  = libsHandler.cachedOper[libs[0]] as GFile;
			var hbox:GHBox = new GHBox();
//			hbox.addChild(new GNoScale(skinFile.getInstance("PRODUCE_TIME_ICON")));
//			hbox.addChild(clockText = new GText());
//			clockText.fontColor = 0xffffff;
//			clockText.fontSize = 14;
//			clockText.fontBold = true;
//			clockText.text = "00:00:00";
			topCenter = new GVBox();
			topCenter.addChild(hbox);
			addChild(topCenter);
			addChild(bottomBox = new GHBox());
			bottomBox.addChild(skillIcons = new GHBox());
			skillIcons.addEventListener(MouseEvent.CLICK, _handleMouseEvent);
			bottomBox.addChild(coinView = new Coin(skinFile.getInstance("BattleCoin")));
			bottomBox.addChild(hp = new GProgress(skinFile.getInstance("ProgressSkin")));
			
			enableTick = true;
			bindData = battle.loginedBattleUser;
			bindData2 = battle;
		}

		override public function tick(interval:int):void {
//			clockText.text = GDateUtil.formatSeconds(Math.max(0, GameModel.instance.application.serverTime - battle.startTime) / 1000);
		}

		override public function handleModelChanged(events:Object = null):void {
			var model:BattleRoomSeatModel = bindData as BattleRoomSeatModel;
			if (!events) {
				//update shortCut
				skillIcons.removeAllChildren();
				var skinFile:GFile = libsHandler.cachedOper[libs[0]] as GFile;
				for (var characterId:String in model.choosedSoilders) {
					var s:* = skinFile.getInstance("CharacterUiSkin");
					var skillIcon:AvatarUiView = new AvatarUiView(s);
					skillIcon.mouseChildren = false;
					skillIcon.avatar.enableTick = false;
					skillIcon.bindData = model.choosedSoilders[characterId];
					addChild(skillIcon);
					skillIcons.addChild(skillIcon);
				}
				coinView.textLabel.text = 44;
			}
		}
		
		private function _handleMouseEvent(event:MouseEvent):void {
			if (event.target is AvatarUiView) {
				var avatarUiView:AvatarUiView = event.target as AvatarUiView;
				_canvas.dispatchAvatar = avatarUiView.bindData as CharacterModel;
			}
		}

		override protected function doValidateLayout():void {
			super.doValidateLayout();

			topCenter.width = topCenter.preferredSize.width;
			topCenter.height = topCenter.preferredSize.height;
			topCenter.x = (topCenter.preferredSize.width + width) >> 1;
			topCenter.y = 30;

			bottomBox.x = width - bottomBox.preferredSize.width - 100;
			bottomBox.y = height - bottomBox.preferredSize.height - 30;
			bottomBox.width = bottomBox.preferredSize.width;
			bottomBox.height = bottomBox.preferredSize.height;
		}
	}
}
import com.gearbrother.glash.display.GNoScale;
import com.gearbrother.glash.display.GSkinSprite;
import com.gearbrother.glash.display.control.text.GText;

import flash.display.DisplayObjectContainer;

class Coin extends GNoScale {
	public var textLabel:GText;
	
	public function Coin(skin:DisplayObjectContainer) {
		super(skin);
		
		textLabel = new GText(skin["textLabel"]);
	}
}