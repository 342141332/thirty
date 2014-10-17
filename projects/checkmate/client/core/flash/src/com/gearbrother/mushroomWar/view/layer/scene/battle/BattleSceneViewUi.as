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
	import com.gearbrother.mushroomWar.model.BattleModel;
	import com.gearbrother.mushroomWar.model.BattleRoomSeatModel;
	import com.gearbrother.mushroomWar.model.CharacterModel;
	import com.gearbrother.mushroomWar.model.GameModel;
	import com.gearbrother.mushroomWar.model.SkillModel;
	import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BattleRoomSeatCharacterProtocol;
	import com.gearbrother.mushroomWar.rpc.service.bussiness.BattleService;
	import com.gearbrother.mushroomWar.view.common.ui.AvatarUiView;
	import com.gearbrother.mushroomWar.view.common.ui.ProgressView;
	import com.gearbrother.mushroomWar.view.common.ui.SkillUiView;
	
	import flash.events.MouseEvent;


	/**
	 * @author lifeng
	 * @create on 2014-2-27
	 */
	public class BattleSceneViewUi extends GContainer {
		public var clockText:GText;
		
		public var topPlayerUi:PlayerUi;
		
		public var bottomPlayerUi:PlayerUi;

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
			addEventListener(MouseEvent.CLICK, _handleMouseEvent);
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
			addChild(topPlayerUi = new PlayerUi(skinFile.getInstance("PlayerTopSkin")));
			topPlayerUi.bindData = battle.seats[0];
			topPlayerUi.hpProgress.policy = GProgress.POLICY_RIGHT_TO_LEFT;
			addChild(bottomPlayerUi = new PlayerUi(skinFile.getInstance("PlayerBottomSkin")));
			bottomPlayerUi.bindData = battle.seats[1];
			enableTick = true;
		}

		override public function tick(interval:int):void {
//			clockText.text = GDateUtil.formatSeconds(Math.max(0, GameModel.instance.application.serverTime - battle.startTime) / 1000);
		}
		
		private function _handleMouseEvent(event:MouseEvent):void {
			if (event.target is AvatarUiView) {
				var avatarUiView:AvatarUiView = event.target as AvatarUiView;
				_canvas.dispatchAvatar = avatarUiView.bindData as CharacterModel;
			}
		}

		override protected function doValidateLayout():void {
			super.doValidateLayout();

			if (topPlayerUi && bottomPlayerUi) {
				var offset:Number = Math.min((width - Math.max(topPlayerUi.width, bottomPlayerUi.width)) >> 1, 70); 
				if (topPlayerUi) {
					topPlayerUi.x = ((width - topPlayerUi.width) >> 1) + offset;
					topPlayerUi.y = 10;
				}
				if (bottomPlayerUi) {
					bottomPlayerUi.x = ((width - topPlayerUi.width) >> 1) - offset;
					bottomPlayerUi.y = height - bottomPlayerUi.height - 10;
				}
			}
		}
	}
}
import com.gearbrother.glash.display.GNoScale;
import com.gearbrother.glash.display.GSkinSprite;
import com.gearbrother.glash.display.control.GProgress;
import com.gearbrother.glash.display.control.text.GText;
import com.gearbrother.mushroomWar.model.BattleRoomModel;
import com.gearbrother.mushroomWar.model.BattleRoomSeatModel;
import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BattleRoomSeatCharacterProtocol;
import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BattleRoomSeatProtocol;
import com.gearbrother.mushroomWar.view.common.ui.AvatarUiView;
import com.greensock.TweenLite;
import com.greensock.easing.Linear;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;

import org.as3commons.lang.ObjectUtils;

class PlayerUi extends GNoScale {
	public var nameLabel:GText;

	public var hpLabel:GText;

	public var hpProgress:GProgress;

	public var soilders:Array;

	public var coinLabel:GText;

	public function PlayerUi(skin:DisplayObjectContainer) {
		super(skin);

		nameLabel = new GText(skin["nameLabel"]);
		hpLabel = new GText(skin["hpLabel"]);
		hpLabel.useHtml = true;
		hpProgress = new GProgress(skin["hpProgress"]);
		soilders = [];
		for (var i:int = 0; ; i++) {
			var child:DisplayObject = skin["soilder" + i];
			if (child)
				soilders.push(new AvatarUiView(child as DisplayObjectContainer));
			else
				break;
		}
		coinLabel = new GText(skin["coinLabel"]);
	}
	
	override public function handleModelChanged(events:Object=null):void {
		if (bindData is BattleRoomSeatModel) {
			var model:BattleRoomSeatModel = bindData;
			if (!events) {
				nameLabel.text = "Lv." + model.level + " " + model.name;
				hpLabel.valueFormater = function(value:*):String {
					return "<font size=\"22\">" + int(value) + "</font>" + "/" + model.maxHp;
				};
				hpLabel.text = 0;
				hpProgress.minValue = 0;
				hpProgress.maxValue = model.maxHp;
			}
			if (!events
				|| events.hasOwnProperty(BattleRoomSeatProtocol.HP)) {
				TweenLite.to(hpLabel, 1.7, {"text": model.hp, "ease": Linear.easeNone});
				TweenLite.to(hpProgress, 1.7, {"value": model.hp, "ease": Linear.easeNone});
			}
			if (!events || events.hasOwnProperty(BattleRoomSeatProtocol.COIN)) {
				coinLabel.text = model.coin;
			}
			if (!events || events.hasOwnProperty(BattleRoomSeatProtocol.CHOOSED_SOILDERS)) {
				var choosedSoilders:Array = ObjectUtils.getProperties(model.choosedSoilders);
				for (var i:int = 0; i < soilders.length; i++) {
					var avatarUiView:AvatarUiView = soilders[i];
					if (choosedSoilders.hasOwnProperty(i)) {
						avatarUiView.bindData = (choosedSoilders[i] as BattleRoomSeatCharacterProtocol).character;
					}
				}
			}
			if (!events || events.hasOwnProperty(BattleRoomSeatProtocol.CHOOSED_HEROES)) {
				
			}
		}
	}
}