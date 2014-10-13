package com.gearbrother.sheepwolf.view.layer.scene.battle {
	import com.gearbrother.glash.common.algorithm.GQuadtree;
	import com.gearbrother.glash.display.flixel.GPaper;
	import com.gearbrother.glash.display.flixel.input.Keyboard;
	import com.gearbrother.glash.mvc.model.GBean;
	import com.gearbrother.sheepwolf.GameMain;
	import com.gearbrother.sheepwolf.model.BattleColorModel;
	import com.gearbrother.sheepwolf.model.BattleItemModel;
	import com.gearbrother.sheepwolf.model.BattleItemUserModel;
	import com.gearbrother.sheepwolf.model.BattleModel;
	import com.gearbrother.sheepwolf.model.BattleUserActionWalkModel;
	import com.gearbrother.sheepwolf.model.BoundsModel;
	import com.gearbrother.sheepwolf.model.GameModel;
	import com.gearbrother.sheepwolf.model.IBattleCollisionModel;
	import com.gearbrother.sheepwolf.model.IBattleItemModel;
	import com.gearbrother.sheepwolf.model.IBattleItemThrowable;
	import com.gearbrother.sheepwolf.model.PointBeanModel;
	import com.gearbrother.sheepwolf.model.SkillModel;
	import com.gearbrother.sheepwolf.rpc.event.RpcEvent;
	import com.gearbrother.sheepwolf.rpc.protocol.bussiness.BattleProtocol;
	import com.gearbrother.sheepwolf.rpc.protocol.bussiness.BattleSignalBattleItemChangeProtocol;
	import com.gearbrother.sheepwolf.rpc.protocol.bussiness.BattleSignalEndProtocol;
	import com.gearbrother.sheepwolf.rpc.protocol.bussiness.BattleSignalMethodDoProtocol;
	import com.gearbrother.sheepwolf.rpc.protocol.bussiness.BattleSignalSkillUseProtocol;
	import com.gearbrother.sheepwolf.rpc.protocol.bussiness.BattleSignalUpdateProtocol;
	import com.gearbrother.sheepwolf.rpc.protocol.bussiness.BattleSignalUserUpdateProtocol;
	import com.gearbrother.sheepwolf.view.common.ui.TextAlert;
	import com.gearbrother.sheepwolf.view.layer.scene.IScene;
	import com.gearbrother.sheepwolf.view.util.RectUtil;
	
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;


	/**
	 * @author lifeng
	 * @create on 2013-12-11
	 */
	public class BattleSceneViewCanvas extends GPaper {
		static public const logger:ILogger = getLogger(BattleSceneViewCanvas);

		public var layerTerrian:BattleSceneLayerTerrian;
		
		public var layers:Object;
		
		public var keyboard:Keyboard2;

		private var _notes:Object;
		
		private	var _quadTree:GQuadtree;
		
		private var _lastBoardKey:Object;

		public function get model():BattleModel {
			return data as BattleModel;
		}

		/**
		 * 
		 * @param battle
		 */
		public function BattleSceneViewCanvas(battle:BattleModel) {
			super();

			data = battle;
			camera.bound.width = battle.col * battle.cellPixel;
			camera.bound.height = battle.row * battle.cellPixel;
			
			addChild(layerTerrian = new BattleSceneLayerTerrian(battle, camera));
			layers = {};
			layers["floor"] = addChild(new BattleSceneLayerOverland("floor", battle, camera)),
			layers["over"] = addChild(new BattleSceneLayerOverland("over", battle, camera));
			
			keyboard = new Keyboard2();
			_notes = {};
			_quadTree = new GQuadtree(new Rectangle(0, 0, model.col * model.cellPixel, model.row * model.cellPixel));
		}
		
		override protected function doInit():void {
			super.doInit();
			
			//add listener
			stage.addEventListener(KeyboardEvent.KEY_DOWN, _handleKeyEvent);
			stage.addEventListener(KeyboardEvent.KEY_UP, _handleKeyEvent);
			GameMain.instance.gameChannel.addEventListener(RpcEvent.DATA, _handleGameChannelEvent);
			enableTick = true;
		}

		private function _handleKeyEvent(event:KeyboardEvent):void {
			switch (event.type) {
				case KeyboardEvent.KEY_DOWN:
					keyboard.handleKeyDown(event);
					break;
				case KeyboardEvent.KEY_UP:
					keyboard.handleKeyUp(event);
					break;
			}
		}

		private function _handleGameChannelEvent(event:RpcEvent):void {
			if (event.response is BattleSignalUpdateProtocol) {
				var update:BattleSignalUpdateProtocol = event.response as BattleSignalUpdateProtocol;
				model.merge(update.battle as BattleModel);
			} else if (event.response is BattleSignalSkillUseProtocol) {
				var skillUsing:BattleSignalSkillUseProtocol = event.response as BattleSignalSkillUseProtocol;
			} else if (event.response is BattleSignalUserUpdateProtocol) {
				var userUpdate:BattleSignalUserUpdateProtocol = event.response as BattleSignalUserUpdateProtocol;
				(model.items[(userUpdate.user as BattleItemUserModel).uuid] as BattleItemUserModel).merge(userUpdate.user as GBean);
			} else if (event.response is BattleSignalBattleItemChangeProtocol) {
				var change:BattleSignalBattleItemChangeProtocol = event.response as BattleSignalBattleItemChangeProtocol;
				var battleItem:IBattleItemModel = change.item as IBattleItemModel;
				switch (change.type) {
					case 1:
						if (change.item is IBattleItemModel) {
							battleItem.battle = model;
							for each (var layer:BattleSceneLayerOverland in layers) {
								layer.addItem(change.item as IBattleItemModel, change.userPos as PointBeanModel);
							}
						}
						break;
					case 2:
						(model.items[battleItem.uuid] as GBean).merge(battleItem as GBean);
						break;
					case 3:
						battleItem = model.items[battleItem.uuid];
						battleItem.battle = null;
						for each (layer in layers) {
							layer.removeItem(battleItem);
						}
						break;
					default:
						throw new Error("unknown type");
						break;
				}
			} else if (event.response is BattleSignalMethodDoProtocol) {
				var doMethod:BattleSignalMethodDoProtocol = event.response as BattleSignalMethodDoProtocol;
				var methodFun:Function = this[doMethod.method];
				methodFun.apply(this, JSON.stringify(doMethod.argusJson));
			} else if (event.response is BattleSignalEndProtocol) {
				var end:BattleSignalEndProtocol = event.response as BattleSignalEndProtocol;
				var alert:TextAlert = new TextAlert(end.message);
				alert.open();
			}
		}

		override public function tick(interval:int):void {
			if (!_notes.hasOwnProperty("sleep") && model.startTime + model.sheepSleepAt < GameModel.instance.application.serverTime) {
				_notes["sleep"] = true;
				GameMain.instance.notelayer.showNode("羊羊可以行动了");
			}
			if (!_notes.hasOwnProperty("wolf") && model.startTime + model.wolfSleepAt < GameModel.instance.application.serverTime) {
				_notes["wolf"] = true;
				GameMain.instance.notelayer.showNode("狼狼可以行动了");
			}

			/*var dayTime:Number = (GameModel.instance.application.serverTime - model.startTime) % (model.dayTime + model.nightTime);
			if (dayTime - interval < 0 && dayTime < model.dayTime)
				GameMain.instance.notelayer.showNode("天亮了");
			if (dayTime - interval < model.dayTime && dayTime > model.dayTime)
				GameMain.instance.notelayer.showNode("天黑了");
			if (model.loginedBattleUser && model.loginedBattleUser.isSheep) {
				if ((GameModel.instance.application.currentTime - model.startTime) % (model.dayTime + model.nightTime) > model.dayTime) {
					if (!layerFog.parent) {
						addChild(layerFog);
					}
					layerFog.tick(interval);
				} else {
					if (layerFog.parent) {
						removeChild(layerFog);
					}
				}
			}*/

			//update Items
			layerTerrian.tick(interval);
			for each (var layer:BattleSceneLayerOverland in layers) {
				for (var child:* in layer.childrenDict) {
					if (child is BattleItemSceneView)
						(child as BattleItemSceneView).tick(interval);
				}
				layer.tick(interval);
			}
			camera.focusTo();

			if (!model.loginedBattleUser || model.loginedBattleUser.isCaptured) {
				return;	//当前是裁判或是播放录像
			}
			
			_quadTree.clear();
			for each (var item:IBattleItemModel in model.items) {
				_quadTree.insert(item);
			}
			var collisionBounds:Rectangle = new Rectangle();
			for (var userUuid:String in model.users) {
				var user:BattleItemUserModel = model.users[userUuid];
				collisionBounds.x = user.x;
				collisionBounds.y = user.y;
				collisionBounds.width = user.width;
				collisionBounds.height = user.height;
				var collisionItems:Array = _quadTree.retrieve(collisionBounds);
				var touchUuids:Array = [];
				for each (var collisionItem:IBattleItemModel in collisionItems) {
					if (collisionItem != user
						&& collisionItem.intersect(user)
						/*&& GameModel.instance.application.serverTime >= collisionItem.validTime1
						&& collisionItem.validTime2 > GameModel.instance.application.serverTime*/
						&& collisionItem.touchAutoRemoteCall && collisionItem.touchAutoRemoteCall.length > 0) 
						touchUuids.push(collisionItem.uuid);
				}
				if (touchUuids.length)
					GameMain.instance.battleService.touchAuto(userUuid, touchUuids);
			}

			//handle keyboard
			var skillKeys:Object = {};
			for each (var skill:SkillModel in model.loginedBattleUser.skills) {
				skillKeys[skill.shortCut] = skill;
			}
			for each (var pressedKeyCode:String in keyboard.justPresseds) {
				if (skillKeys.hasOwnProperty(pressedKeyCode)) {
					skill = skillKeys[pressedKeyCode];
					GameMain.instance.battleService.skillUse(model.loginedBattleUser.skills.indexOf(skill), {});
				}
			}
			if (model.loginedBattleUser && keyboard.justReleased("SPACE")) {
				collisionBounds.x = model.loginedBattleUser.x;
				collisionBounds.y = model.loginedBattleUser.y;
				collisionBounds.width = model.loginedBattleUser.width;
				collisionBounds.height = model.loginedBattleUser.height;
				var manualTouchItemUuids:Array = [];
//				var collisionUsersUuid:Array = [];
				collisionItems = _quadTree.retrieve(collisionBounds);
				for each (collisionItem in collisionItems) {
					if (manualTouchItemUuids && collisionItem.touchManualRemoteCall
						&& collisionItem.intersect(model.loginedBattleUser)
						&& collisionItem != model.loginedBattleUser) {
						manualTouchItemUuids.push(collisionItem);
					}
//					if (collisionItem is BattleItemUserModel
//						&& (collisionItem as BattleItemUserModel).color == model.loginedBattleUser.color
//						&& collisionItem != model.loginedBattleUser
//						&& collisionItem.intersect(model.loginedBattleUser)) {
//						collisionUsersUuid.push(collisionItem.uuid);
//					}
				}
				manualTouchItemUuids.sort(
					function(a:BattleItemModel, b:BattleItemModel, ...res):Boolean {
						return Math.pow(model.loginedBattleUser.x + model.loginedBattleUser.width / 2 - a.x - a.width / 2, 2) + Math.pow(model.loginedBattleUser.y + model.loginedBattleUser.height / 2 - a.y - a.height / 2, 2)
							> Math.pow(model.loginedBattleUser.x + model.loginedBattleUser.width / 2 - b.x - b.width / 2, 2) + Math.pow(model.loginedBattleUser.y + model.loginedBattleUser.height / 2 - b.y - b.height / 2, 2);
					}
				)
				if (manualTouchItemUuids && manualTouchItemUuids.length) {
					GameMain.instance.battleService.touchManual(model.loginedBattleUser.uuid, (manualTouchItemUuids[0] as BattleItemModel).uuid);
				}
//				if (collisionUsersUuid.length)
//					GameMain.instance.battleService.rescue(collisionUsersUuid);
			}
			
			/**
			 * 上下左右十字移动，位于格子一直线上可像素级移动，拐弯系统查找最近拐弯整除的格子做碰撞处理，如无碰撞则拐弯移动，有则停止
			 */
			var currentKeyInfo:Array;
			if (keyboard.pressed("UP")) {
				var keyUp:Object = keyboard.map[Keyboard.KEY_UP];
				if (!currentKeyInfo || currentKeyInfo[1].time < keyUp.time)
					currentKeyInfo = [Keyboard.KEY_UP, keyUp];
			}
			if (keyboard.pressed("RIGHT")) {
				var keyRight:Object = keyboard.map[Keyboard.KEY_RIGHT];
				if (!currentKeyInfo || currentKeyInfo[1].time < keyRight.time)
					currentKeyInfo = [Keyboard.KEY_RIGHT, keyRight];
			}
			if (keyboard.pressed("DOWN")) {
				var keyDown:Object = keyboard.map[Keyboard.KEY_DOWN];
				if (!currentKeyInfo || currentKeyInfo[1].time < keyDown.time)
					currentKeyInfo = [Keyboard.KEY_DOWN, keyDown];
			}
			if (keyboard.pressed("LEFT")) {
				var keyLeft:Object = keyboard.map[Keyboard.KEY_LEFT];
				if (!currentKeyInfo || currentKeyInfo[1].time < keyLeft.time)
					currentKeyInfo = [Keyboard.KEY_LEFT, keyLeft];
			}
			var currentKey:Object;
			if (currentKeyInfo) {
				currentKey = currentKeyInfo[0];
			}
			if (_lastBoardKey != currentKey) {
				if (currentKey == Keyboard.KEY_UP) {
					GameMain.instance.battleService.move(BattleUserActionWalkModel.DIRECTION_UP);
					_lastBoardKey = currentKey;
				} else if (currentKey == Keyboard.KEY_RIGHT) {
					GameMain.instance.battleService.move(BattleUserActionWalkModel.DIRECTION_RIGHT);
					_lastBoardKey = currentKey;
				} else if (currentKey == Keyboard.KEY_DOWN) {
					GameMain.instance.battleService.move(BattleUserActionWalkModel.DIRECTION_DOWN);
					_lastBoardKey = currentKey;
				} else if (currentKey == Keyboard.KEY_LEFT) {
					GameMain.instance.battleService.move(BattleUserActionWalkModel.DIRECTION_LEFT);
					_lastBoardKey = currentKey;
				} else {
					GameMain.instance.battleService.stop();
					_lastBoardKey = null;
				}
			}
			keyboard.update();
		}
		
		override protected function doValidateLayout():void {
			camera.screenRect.width = width;
			camera.screenRect.height = height;
			camera.setChanged();
			
			super.doValidateLayout();
		}
	}
}
import com.gearbrother.glash.display.flixel.input.Keyboard;

import flash.events.KeyboardEvent;
import flash.utils.getTimer;

class Keyboard2 extends Keyboard {
	public function get map():Array {
		return _map;
	}
	
	public function get justPresseds():Array {
		var res:Array = [];
		for (var key:String in _map) {
			if (_map[key].current == 2)
				res.push(key);
		}
		return res;
	}
	
	public function Keyboard2() {
		super();
	}
	
	override public function handleKeyDown(FlashEvent:KeyboardEvent):void {
		var object:Object = _map[FlashEvent.keyCode];
		if (object == null)
			return;
		if (object.current > 0)
			object.current = 1;
		else {
			object.current = 2;
			object.time = getTimer();
		}
		this[object.name] = true;
	}
	
	override public function handleKeyUp(FlashEvent:KeyboardEvent):void {
		var object:Object = _map[FlashEvent.keyCode];
		if (object == null)
			return;
		if (object.current > 0)
			object.current = -1;
		else
			object.current = 0;
		this[object.name] = false;
	}
}

