package com.gearbrother.mushroomWar.view.layer.scene.battle {
	import com.gearbrother.glash.common.oper.ext.GAliasFile;
	import com.gearbrother.glash.common.oper.ext.GBmdDefinition;
	import com.gearbrother.glash.common.oper.ext.GDefinition;
	import com.gearbrother.glash.display.GMovieBitmap;
	import com.gearbrother.glash.display.GMovieClip;
	import com.gearbrother.glash.display.GSkinSprite;
	import com.gearbrother.glash.display.control.GButton;
	import com.gearbrother.glash.display.control.GProgress;
	import com.gearbrother.glash.display.control.text.GText;
	import com.gearbrother.glash.display.filter.GFilter;
	import com.gearbrother.glash.util.math.GMathUtil;
	import com.gearbrother.glash.util.math.GPointUtil;
	import com.gearbrother.mushroomWar.GameMain;
	import com.gearbrother.mushroomWar.model.BattleItemBuildingModel;
	import com.gearbrother.mushroomWar.model.BattleItemModel;
	import com.gearbrother.mushroomWar.model.BattleItemSoilderModel;
	import com.gearbrother.mushroomWar.model.GameModel;
	import com.gearbrother.mushroomWar.model.IBattleItemModel;
	import com.gearbrother.mushroomWar.model.TaskArriveModel;
	import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BattleItemBuildingProtocol;
	import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BattleItemProtocol;
	import com.gearbrother.mushroomWar.rpc.protocol.bussiness.TaskAttackProtocol;
	import com.gearbrother.mushroomWar.rpc.protocol.bussiness.TaskProduceProtocol;
	import com.gearbrother.mushroomWar.view.common.ui.AvatarView;
	import com.greensock.TweenLite;
	
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextFormatAlign;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import org.as3commons.lang.ObjectUtils;


	/**
	 *
	 * @author 	Neo.Zhang
	 * @create 	2014-7-28 下午5:46:29
	 *
	 */
	public class BattleItemSceneView extends GSkinSprite {
		static public const coupleFilter:GFilter = new GFilter(new DropShadowFilter(0, 0, 0xFDCE1E, 1, 3, 3, 200));
		
		static public const ownerFilter:GFilter = new GFilter(new GlowFilter(0x92D050, 1, 3, 3, 200));
		
		static public const enemyFilter:GFilter = new GFilter(new GlowFilter(0xFF3300, 1, 3, 3, 200));
		
		private var _brightFilter:GFilter = GFilter.getBright(170);
		
		private var _unBrightDelayID:int;
		
		public var hp:GProgress;

		public var troopText:GText;

		public var upgradeBtn:GButton;

		public var produceBtn:GButton;

		public var _avatar:AvatarView;
		
		public var settledAvatar:AvatarView;
		
		protected var _oldProperties:Object;

		public function BattleItemSceneView(model:IBattleItemModel) {
			super();

			bindData = model;
			_oldProperties = {};
			/*this.graphics.beginFill(0xffffff, .1);
			this.graphics.drawRect(0, 0, model.battle.cellPixel * model.width, model.battle.cellPixel * model.height);
			this.graphics.endFill();*/
			
			addChild(_avatar = new AvatarView());
			_avatar.enableTick = false;

			if (model is BattleItemBuildingModel) {
				var progressSkin:Shape = new Shape();
				progressSkin.graphics.beginFill(0x009900, 1);
				progressSkin.graphics.drawRect(0, 0, 20, 1);
				progressSkin.graphics.endFill();
				addChild(hp = new GProgress(progressSkin));
				hp.mouseEnabled = hp.mouseChildren = false;
				hp.maxValue = model.maxHp;
				hp.minValue = 0;
				hp.value = model.hp;
				hp.x = -hp.width >> 1;
				hp.y = 10;
				addChild(upgradeBtn = new GButton());
				upgradeBtn.text = "升级";
				upgradeBtn.validateLayoutNow();
				upgradeBtn.x = -upgradeBtn.width >> 1;
				upgradeBtn.y = 50;
			} else {
				mouseChildren = mouseEnabled = false;
			}
			addEventListener(MouseEvent.CLICK, _handleMouseEvent);
		}
		
		private function _handleMouseEvent(event:MouseEvent):void {
			var model:IBattleItemModel = bindData;
			switch (event.target) {
				case upgradeBtn:
					GameMain.instance.battleService.upgrade(model.instanceId);
					break;
			}
		}

		override public function handleModelChanged(events:Object=null):void {
			var model:IBattleItemModel = bindData;
			if (events && (events.hasOwnProperty(BattleItemProtocol.HP) || events.hasOwnProperty(BattleItemProtocol.MAX_HP))) {
				var changedHp:int = model.hp - _oldProperties[BattleItemProtocol.HP];
				if (changedHp > 0) {
					popup("+ " + changedHp + " HP", 0x66cc00);
				} else if (changedHp < 0) {
					popup(changedHp + " HP", 0xff3333);
				}
				if (hp) {
					hp.value = model.hp;
				}
				_oldProperties[BattleItemProtocol.HP] = model.hp;
				_brightFilter.apply(_avatar);
				clearTimeout(_unBrightDelayID);
				_unBrightDelayID = setTimeout(_brightFilter.unapply, 200, _avatar);
			}
			/*if (!events || events.hasOwnProperty(BattleItemBuildingProtocol.SETTLED_TROOPS)) {
				if (model is BattleItemBuildingModel) {
					var building:BattleItemBuildingModel = model as BattleItemBuildingModel;
					if (!troopText) {
						addChild(troopText = new GText());
						troopText.align = TextFormatAlign.CENTER;
						troopText.mouseEnabled = troopText.mouseChildren = false;
						troopText.fontColor = 0xffffff;
						troopText.filters = [new GlowFilter(0x000000, 1, 3, 3, 200)];
					}
					troopText.htmlText = "<font color=\"#92D050\">Lv." + (model as BattleItemBuildingModel).level + "</font>";
					troopText.x = -troopText.preferredSize.width >> 1;
					troopText.y = -70;
					troopText.width = troopText.preferredSize.width;
					troopText.height = troopText.preferredSize.height;
					troopText.validateLayoutNow();
				}
			}*/
			if ((!events || events.hasOwnProperty(BattleItemBuildingProtocol.OWNER_ID))/* && model is BattleItemBuildingModel*/) {
				if (GameModel.instance.loginedUser && model.ownerId) {
					if (GameModel.instance.loginedUser.uuid == model.ownerId) {
						enemyFilter.unapply(_avatar);
						ownerFilter.apply(_avatar);
					} else {
						enemyFilter.apply(_avatar);
						ownerFilter.unapply(_avatar);
					}
				}
			}
			if (!events
				|| events.hasOwnProperty(BattleItemProtocol.TASK)
				|| events.hasOwnProperty(BattleItemProtocol.CARTOON)) {
				if (model.task is TaskArriveModel) {
					var move:TaskArriveModel = model.task as TaskArriveModel;
					_avatar.setCartoon(model.cartoon, AvatarView.running);
					if (move.targetX > x)
						_avatar.scaleX = 1;
					else if (move.targetX < x)
						_avatar.scaleX = -1;
				} else if (model.task is TaskAttackProtocol) {
					var attack:TaskAttackProtocol = model.task as TaskAttackProtocol;
					_avatar.setCartoon(model.cartoon, AvatarView.fighting);
					var target:IBattleItemModel = model.battle.items[attack.targetId] as IBattleItemModel;
					if (target) {
						if (target.x > x)
							_avatar.scaleX = 1;
						else if (target.x < x)
							_avatar.scaleX = -1;
					}
				} else {
					_avatar.setCartoon(model.cartoon, AvatarView.idle);
				}
			}
			if ((!events || events.hasOwnProperty(BattleItemBuildingProtocol.SETTLED_HERO)) && bindData is BattleItemBuildingModel) {
				var buildingModel:BattleItemBuildingModel = bindData;
				if (buildingModel.settledHero) {
					if (!settledAvatar) {
						addChild(settledAvatar = new AvatarView());
						settledAvatar.setCartoon(buildingModel.settledHero.cartoon, AvatarView.idle);
					}
				} else {
					if (settledAvatar) {
						settledAvatar.remove();
						settledAvatar = null;
					}
				}
			}
		}

		private var _texts:Array;
		public function popup(text:String, fontColor:uint = 0xffffff, fontSize:int = 13):void {
//			_texts ||= [];
//			if (!_texts.length) {
//				var msg:Object = _texts.shift();
				var popup:GText = new GText();
				popup.fontBold = true;
				popup.text = text;
				popup.fontColor = fontColor;
				popup.fontSize = fontSize;
				popup.filters = [new GlowFilter(0x000000, 1, 3, 3, 300)];
				addChild(popup);
				TweenLite.to(popup, 1.3, {y: - 70, alpha: .1, onComplete: removeChild, onCompleteParams: [popup]});
//			}
//			_texts.push({"text": text, "fontColor": fontColor, "fontSize": fontSize});
		}
		
		static public const RADIAN:Array = [-20, -16, -12, -8, -2, 2, 8, 12, 16, 20];
		
		override public function tick(interval:int):void {
			var model:IBattleItemModel = bindData;
			if (model.task is TaskArriveModel) {
				var move:TaskArriveModel = model.task as TaskArriveModel;
				var progress:Number = Math.min(1, (GameModel.instance.application.serverTime - move.startTime) / (move.endTime - move.startTime));
				x = move.startX + (move.targetX - move.startX) * progress;
				y = move.startY + (move.targetY - move.startY) * progress;
			}
			_avatar.tick(interval);
			if (settledAvatar)
				settledAvatar.tick(interval);
		}
	}
}
