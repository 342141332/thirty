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
	import com.gearbrother.mushroomWar.model.BattleItemActionMoveModel;
	import com.gearbrother.mushroomWar.model.BattleItemBuildingModel;
	import com.gearbrother.mushroomWar.model.BattleItemModel;
	import com.gearbrother.mushroomWar.model.GameModel;
	import com.gearbrother.mushroomWar.model.IBattleItemModel;
	import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BattleItemBuildingProtocol;
	import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BattleItemProtocol;
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
		
		public var _avatar:AvatarView;
		
		public var settledAvatar:AvatarView;
		
		protected var _oldProperties:Object;

		public function BattleItemSceneView(model:IBattleItemModel) {
			super();

			bindData = model;
			/*this.graphics.beginFill(0xffffff, .1);
			this.graphics.drawRect(0, 0, model.battle.cellPixel * model.width, model.battle.cellPixel * model.height);
			this.graphics.endFill();*/
			
			addChild(_avatar = new AvatarView());
			_avatar.enableTick = false;

			if (model is BattleItemBuildingModel) {
				var progressSkin:Shape = new Shape();
				progressSkin.graphics.beginFill(0x00cc00, 1);
				progressSkin.graphics.drawRect(0, 0, 50, 2);
				progressSkin.graphics.endFill();
				/*addChild(hp = new GProgress(progressSkin));
				hp.mouseEnabled = hp.mouseChildren = false;
				hp.filters = [new GlowFilter(0x000000, 1, 4, 4, 300)];
				hp.maxValue = model.maxHp;
				hp.minValue = 0;
				hp.value = model.hp;
				hp.x = 0;
				hp.y = -23;*/
				_oldProperties = {};
				addChild(upgradeBtn = new GButton());
				upgradeBtn.tipData = "消耗一定数量的兵，缩短造兵时间0.1S";
				upgradeBtn.text = "upgrade";
				upgradeBtn.validateLayoutNow();
				upgradeBtn.x = -upgradeBtn.width >> 1;
				upgradeBtn.y = 50;
				upgradeBtn.visible = false;
			} else {
				_avatar.scaleX = _avatar.scaleY = .7;
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
			/*if (events && hp && (events.hasOwnProperty(BattleItemProtocol.HP) || events.hasOwnProperty(BattleItemProtocol.MAX_HP))) {
				var changedHp:int = model.hp - _oldProperties[BattleItemProtocol.HP];
				if (changedHp > 0) {
					popup("+ " + changedHp + " HP", 0x66cc00);
				} else if (changedHp < 0) {
					popup(changedHp + " HP", 0xff3333);
				}
				hp.maxValue = model.maxHp;
				_oldProperties[BattleItemProtocol.HP] = hp.value = model.hp;
				_brightFilter.apply(_avatar);
				clearTimeout(_unBrightDelayID);
				_unBrightDelayID = setTimeout(_brightFilter.unapply, 200, _avatar);
			}*/
			if (!events || events.hasOwnProperty(BattleItemBuildingProtocol.TROOPS)) {
				if (model is BattleItemBuildingModel) {
					var building:BattleItemBuildingModel = model as BattleItemBuildingModel;
					if (!troopText) {
						addChild(troopText = new GText());
						troopText.align = TextFormatAlign.CENTER;
						troopText.mouseEnabled = troopText.mouseChildren = false;
						troopText.fontColor = 0xffffff;
						troopText.filters = [new GlowFilter(0x000000, 1, 3, 3, 200)];
					}
					var values:Array = ObjectUtils.getProperties(building.troops);
					troopText.htmlText = (values.length > 0 ? values[0] : 0) + "\r<font color=\"#92D050\">Lv." + (model as BattleItemBuildingModel).level + "</font>";
					troopText.x = -troopText.preferredSize.width >> 1;
					troopText.y = -troopText.preferredSize.height >> 1;
					troopText.width = troopText.preferredSize.width;
					troopText.height = troopText.preferredSize.height;
					troopText.validateLayoutNow();
				}
			}
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
			if (!events || events.hasOwnProperty(BattleItemProtocol.CARTOON)) {
				if (model is BattleItemBuildingModel) {
					_avatar.setCartoon(model.cartoon, AvatarView.STATE_STOP_DOWN);
				} else {
					_avatar.setCartoon(model.cartoon, AvatarView.STATE_MOVE_DOWN);
				}
			}
			if ((!events || events.hasOwnProperty(BattleItemBuildingProtocol.SETTLED_HERO)) && model is BattleItemBuildingModel) {
				var buildingModel:BattleItemBuildingModel = bindData;
				if (buildingModel.settledHero) {
					if (!settledAvatar) {
						addChild(settledAvatar = new AvatarView());
						settledAvatar.setCartoon(buildingModel.settledHero.cartoon, AvatarView.STATE_STOP_DOWN);
					}
				} else {
					if (settledAvatar) {
						settledAvatar.remove();
						settledAvatar = null;
					}
				}
			}
			if (!events || events.hasOwnProperty(BattleItemProtocol.CURRENT_ACTION)) {
				if (model.currentAction == "skill") {
					settledAvatar.setCartoon((model as BattleItemBuildingModel).settledHero.cartoon, AvatarView.STATE_SKILL_DOWN);
				}
			}
		}

		private var _texts:Array;
		public function popup(text:String, fontColor:uint = 0xffffff, fontSize:int = 13):void {
			_texts ||= [];
			_texts.push({"text": text, "fontColor": fontColor, "fontSize": fontSize});
			refreshTimer = 500;
		}
		
		static public const RADIAN:Array = [-20, -16, -12, -8, -2, 2, 8, 12, 16, 20];
		
		private var _lastPos:Array;
		override public function tick(interval:int):void {
			var model:IBattleItemModel = bindData;
			if (model.currentAction is BattleItemActionMoveModel) {
				var move:BattleItemActionMoveModel = model.currentAction as BattleItemActionMoveModel;
				if (move.endTime > GameModel.instance.application.serverTime) {
					var progress:Number = Math.min(1, (GameModel.instance.application.serverTime - move.startTime) / (move.endTime - move.startTime));
					var startBuilding:BattleItemBuildingModel = model.battle.items[move.startBuildingId];
					var targetBuilding:BattleItemBuildingModel = model.battle.items[move.targetBuildingId];
					var distance:Number = GPointUtil.distance2(startBuilding.x, startBuilding.y, targetBuilding.x, targetBuilding.y);
					var offset:Number = Math.sin(Math.PI * progress);
					var radian:Number = GMathUtil.getRadian2(startBuilding.x, startBuilding.y, targetBuilding.x, targetBuilding.y) + offset * 0/*RADIAN[move.offset] */* Math.PI / 180;
					x = (startBuilding.x + Math.cos(radian) * distance * progress);
					y = (startBuilding.y + Math.sin(radian) * distance * progress);
					/*var pos:Point = Point.interpolate(
						new Point(move.startPos.x, move.startPos.y), new Point(move.targetPos.x, move.targetPos.y)
						, 1 - progress
					);
					x = pos.x * model.battle.cellPixel;
					y = pos.y * model.battle.cellPixel;*/
				} else {
					model.battle = null;
					(parent as BattleSceneLayerOverland).removeItem(model);
				}
			}
			if (_lastPos) {
				var offsetX:Number = x - _lastPos[0];
				var offsetY:Number = y - _lastPos[1];
				if (offsetX == 0 && offsetY == 0) {
//					_avatar.setCartoon(model.cartoon, AvatarView.STATE_STOP_DOWN);
				} else {
					if (Math.abs(offsetX) > Math.abs(offsetY)) {
						if (offsetX > 0)
							_avatar.setCartoon(model.cartoon, AvatarView.STATE_MOVE_RIGHT);
						else
							_avatar.setCartoon(model.cartoon, AvatarView.STATE_MOVE_LEFT);
					} else {
						if (offsetY > 0)
							_avatar.setCartoon(model.cartoon, AvatarView.STATE_MOVE_DOWN);
						else
							_avatar.setCartoon(model.cartoon, AvatarView.STATE_MOVE_UP);
					}
				}
			} else {
//				_avatar.setCartoon(model.cartoon, AvatarView.STATE_STOP_DOWN);
				_lastPos = [x, y];
			}
			_avatar.tick(interval);
			if (bindData is BattleItemBuildingModel) {
				var buildingModel:BattleItemBuildingModel = bindData;
				if (buildingModel.produce) {
					var values:Array = ObjectUtils.getProperties(buildingModel.troops);
					troopText.htmlText = (values.length > 0 ? values[0] : 0) + int((GameModel.instance.application.serverTime - buildingModel.produce.lastIntervalTime) / buildingModel.produce.interval * buildingModel.produce.num)
						+ "\r<font color=\"#92D050\">Lv." + buildingModel.level + "</font>";
				}
			}
			if (settledAvatar)
				settledAvatar.tick(interval);
		}
		
		override public function refresh(time:int):void {
			if (_texts.length) {
				var msg:Object = _texts.shift();
				var popup:GText = new GText();
				popup.fontBold = true;
				popup.text = msg.text;
				popup.fontColor = msg.fontColor;
				popup.fontSize = msg.fontSize;
				popup.filters = [new GlowFilter(0x000000, 1, 3, 3, 300)];
				addChild(popup);
				TweenLite.to(popup, 1.3, {y: - 70, alpha: .1, onComplete: removeChild, onCompleteParams: [popup]});
			} else {
				refreshTimer = 0;
			}
		}
	}
}
