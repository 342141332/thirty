package com.gearbrother.mushroomWar.view.layer.scene.battle {
	import com.gearbrother.glash.common.algorithm.astar.Grid;
	import com.gearbrother.glash.common.oper.ext.GAliasFile;
	import com.gearbrother.glash.common.oper.ext.GFile;
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.container.GContainer;
	import com.gearbrother.glash.display.container.GHBox;
	import com.gearbrother.glash.display.container.GVBox;
	import com.gearbrother.glash.display.control.GProgress;
	import com.gearbrother.glash.display.control.text.GText;
	import com.gearbrother.glash.display.layout.impl.GridLayout;
	import com.gearbrother.glash.display.propertyHandler.GPropertyBindDataHandler;
	import com.gearbrother.glash.util.lang.GDateUtil;
	import com.gearbrother.mushroomWar.GameMain;
	import com.gearbrother.mushroomWar.model.BattleModel;
	import com.gearbrother.mushroomWar.model.BattlePlayerModel;
	import com.gearbrother.mushroomWar.model.CharacterModel;
	import com.gearbrother.mushroomWar.model.GameModel;
	import com.gearbrother.mushroomWar.model.SkillModel;
	import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BattleForceProtocol;
	import com.gearbrother.mushroomWar.rpc.service.bussiness.BattleService;
	import com.gearbrother.mushroomWar.view.common.ui.AvatarUiView;
	import com.gearbrother.mushroomWar.view.common.ui.ProgressView;
	import com.gearbrother.mushroomWar.view.common.ui.SkillUiView;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	import org.as3commons.lang.ObjectUtils;


	/**
	 * @author lifeng
	 * @create on 2014-2-27
	 */
	public class BattleSceneViewUi extends GContainer {
		public var titleUi:TitleUi;
		
		public var force0HeroList:GContainer;
		
		public var force1HeroList:GContainer;
		
		public var heroList:GContainer;
		
		public var soldierList:GContainer;

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
			addChild(titleUi = new TitleUi(skinFile.getInstance("TitleSkin")));
			titleUi.bindData = battle;
			addChild(force0HeroList = new GHBox());
			for each (var player:BattlePlayerModel in (battle.forces[0] as BattleForceProtocol).players) {
				var group:GHBox = new GHBox();
				for each (var hero:CharacterModel in player.choosedHeroes) {
					var characterUiSkin:DisplayObjectContainer = skinFile.getInstance("CharacterUiSkin");
					characterUiSkin.scaleX = characterUiSkin.scaleY = .5
					var characterUi:AvatarUiView = new AvatarUiView(characterUiSkin);
					characterUi.bindData = hero;
					group.addChild(characterUi);
				}
				force0HeroList.addChild(group);
			}
			addChild(force1HeroList = new GHBox());
			for each (player in (battle.forces[1] as BattleForceProtocol).players) {
				group = new GHBox();
				for each (hero in player.choosedHeroes) {
					characterUiSkin = skinFile.getInstance("CharacterUiSkin");
					characterUiSkin.scaleX = characterUiSkin.scaleY = .5
					characterUi = new AvatarUiView(characterUiSkin);
					characterUi.bindData = hero;
					group.addChild(characterUi);
				}
				force1HeroList.addChild(group);
			}
			addChild(heroList = new GHBox);
			for each (hero in battle.loginedPlayer.choosedHeroes) {
				characterUi = new AvatarUiView(skinFile.getInstance("CharacterUiSkin"));
				characterUi.bindData = hero;
				heroList.addChild(characterUi);
			}
			addChild(soldierList = new GContainer());
			soldierList.layout = new GridLayout(0, 2);
			for each (hero in battle.loginedPlayer.choosedSoilders) {
				characterUi = new AvatarUiView(skinFile.getInstance("CharacterUiSkin"));
				characterUi.bindData = hero;
				soldierList.addChild(characterUi);
			}
			soldierList.addEventListener(MouseEvent.CLICK, _handleSoldierMouseEvent);
		}

		private function _handleSoldierMouseEvent(event:MouseEvent):void {
			if (event.target is AvatarUiView) {
				var avatarUiView:AvatarUiView = event.target as AvatarUiView;
				GameMain.instance.battleService.dispatch((avatarUiView.bindData as CharacterModel).confId);
			}
		}
		
		override public function handleModelChanged(events:Object=null):void {
			var skinFile:GFile  = libsHandler.cachedOper[libs[0]] as GFile;
		}

		override protected function doValidateLayout():void {
			if (titleUi) {
				titleUi.x = (width - titleUi.width) >> 1;
				titleUi.y = 10;
			}
			if (force0HeroList) {
				force0HeroList.width = force0HeroList.preferredSize.width;
				force0HeroList.height = force0HeroList.preferredSize.height;
				force0HeroList.validateLayoutNow();
				force0HeroList.x = (width >> 1) - force0HeroList.width - 30;
				force0HeroList.y = titleUi.y + titleUi.height - 10;
			}
			if (force1HeroList) {
				force1HeroList.width = force1HeroList.preferredSize.width;
				force1HeroList.height = force1HeroList.preferredSize.height;
				force1HeroList.validateLayoutNow();
				force1HeroList.x = (width >> 1) + 30;
				force1HeroList.y = titleUi.y + titleUi.height - 10;
			}
			if (heroList) {
				heroList.width = heroList.preferredSize.width;
				heroList.height = heroList.preferredSize.height;
				heroList.validateLayoutNow();
				heroList.x = (width - heroList.width) >> 1;
				heroList.y = (height - heroList.height) - 10;
			}
			if (soldierList) {
				soldierList.width = soldierList.preferredSize.width;
				soldierList.height = soldierList.preferredSize.height;
				soldierList.validateLayoutNow();
				soldierList.x = 0;
				soldierList.y = height - soldierList.height;
			}
		}
	}
}
import com.gearbrother.glash.display.GNoScale;
import com.gearbrother.glash.display.GSkinSprite;
import com.gearbrother.glash.display.container.GHBox;
import com.gearbrother.glash.display.control.GProgress;
import com.gearbrother.glash.display.control.text.GText;
import com.gearbrother.glash.util.lang.GDateUtil;
import com.gearbrother.mushroomWar.model.BattleModel;
import com.gearbrother.mushroomWar.model.BattlePlayerModel;
import com.gearbrother.mushroomWar.model.GameModel;
import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BattleForceProtocol;
import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BattlePlayerProtocol;
import com.gearbrother.mushroomWar.view.common.ui.AvatarUiView;
import com.greensock.TweenLite;
import com.greensock.easing.Linear;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;

import org.as3commons.lang.ObjectUtils;

class TitleUi extends GNoScale {
	public var timeLabel:GText;
	
	public var force0Progress:GProgress;
	
	public var force0Label:GText;
	
	public var force1Progress:GProgress;
	
	public var force1Label:GText;
	
	public function TitleUi(skin:DisplayObjectContainer) {
		super(skin);
		
		timeLabel = new GText(skin["timeLabel"]);
		timeLabel.useHtml = true;
		force0Progress = new GProgress(skin["force0Progress"]);
		force0Progress.policy = GProgress.POLICY_LEFT_TO_RIGHT;
		force0Label = new GText(skin["force0Label"]);
		force1Progress = new GProgress(skin["force1Progress"]);
		force1Progress.policy = GProgress.POLICY_RIGHT_TO_LEFT;
		force1Label = new GText(skin["force1Label"]);
	}
	
	override public function handleModelChanged(events:Object=null):void {
		if (bindData is BattleForceProtocol) {
			var model:BattleForceProtocol = bindData;
			if (!events) {
				timeLabel.valueFormater = function(value:*):String {
					return "<font size=\"22\">" + int(value) + "</font>" + "/" + model.maxHp;
				};
				timeLabel.text = 0;
			}
			if (!events
				|| events.hasOwnProperty(BattleForceProtocol.HP)) {
				TweenLite.to(timeLabel, 1.7, {"text": model.hp, "ease": Linear.easeNone});
			}
		}
		enableTick = true;
	}
	
	override public function tick(interval:int):void {
		var battle:BattleModel = bindData;
		timeLabel.text = GDateUtil.formatSeconds(Math.max(0, GameModel.instance.application.serverTime - battle.startTime) / 1000);
	}
}

class PlayerUi extends GNoScale {
	public var nameLabel:GText;

	public var coinLabel:GText;

	public function PlayerUi(skin:DisplayObjectContainer) {
		super(skin);

		nameLabel = new GText(skin["nameLabel"]);
		coinLabel = new GText(skin["coinLabel"]);
	}
	
	override public function handleModelChanged(events:Object=null):void {
		if (bindData is BattlePlayerModel) {
			var model:BattlePlayerModel = bindData;
			if (!events || events.hasOwnProperty(BattlePlayerProtocol.COIN)) {
				coinLabel.text = model.coin;
			}
			/*if (!events || events.hasOwnProperty(BattlePlayerProtocol.CHOOSED_HEROES)) {
				var choosedHeroes:Array = ObjectUtils.getProperties(model.choosedHeroes);
				for (var i:int = 0; i < characterUiViews.length; i++) {
					var avatarUiView:AvatarUiView = characterUiViews[i];
					if (choosedHeroes.hasOwnProperty(i))
						avatarUiView.bindData = (choosedHeroes[i] as BattleRoomSeatCharacterProtocol).character;
				}
			}*/
		}
	}
	
}

class CharacterDetailUi extends GHBox {
	public function CharacterDetailUi() {
		super();
	}
}

class SkinUi extends GNoScale {
	public function SkinUi(skin:DisplayObjectContainer) {
		super(skin);
		
		
	}
	
	override public function handleModelChanged(events:Object=null):void {
	}
}
