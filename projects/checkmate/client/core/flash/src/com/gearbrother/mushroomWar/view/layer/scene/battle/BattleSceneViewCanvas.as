package com.gearbrother.mushroomWar.view.layer.scene.battle {
	import com.gearbrother.glash.common.algorithm.GQuadtree;
	import com.gearbrother.glash.display.IGTickable;
	import com.gearbrother.glash.display.flixel.GPaper;
	import com.gearbrother.glash.display.flixel.GPaperLayer;
	import com.gearbrother.glash.display.flixel.GPaperLayerDebug;
	import com.gearbrother.glash.display.flixel.input.Keyboard;
	import com.gearbrother.glash.mvc.model.GBean;
	import com.gearbrother.glash.util.display.GPen;
	import com.gearbrother.mushroomWar.GameMain;
	import com.gearbrother.mushroomWar.model.BattleItemModel;
	import com.gearbrother.mushroomWar.model.BattleModel;
	import com.gearbrother.mushroomWar.model.BattlePlayerModel;
	import com.gearbrother.mushroomWar.model.CharacterModel;
	import com.gearbrother.mushroomWar.model.GameModel;
	import com.gearbrother.mushroomWar.rpc.event.RpcEvent;
	import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BattleForceProtocol;
	import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BattleSignalEndProtocol;
	import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BattleSignalMethodDoProtocol;
	import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BattleSignalSkillUseProtocol;
	import com.gearbrother.mushroomWar.rpc.protocol.bussiness.PropertyEventProtocol;
	import com.gearbrother.mushroomWar.view.common.ui.TextAlert;
	import com.gearbrother.mushroomWar.view.layer.scene.SceneLayer;
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
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
		
		public var layerDebug:BattleSceneLayerDebug;
		
		public var layers:Object;
		
		public var layerDispatch:GPaperLayer;
		
		public var lineShape:DisplayObject;
		
		public var pen:GPen;
		
		public var keyboard:Keyboard2;

		private	var _quadTree:GQuadtree;
		
		private var _lastBoardKey:Object;

		public function get model():BattleModel {
			return data as BattleModel;
		}
		
		private var _dispatchAvatar:CharacterModel;
		public function set dispatchAvatar(newValue:CharacterModel):void {
			_dispatchAvatar = newValue;
			if (_dispatchAvatar) {
			} else {
				layerDispatch.removeAllChildren();
			}
		}

		/**
		 * 
		 * @param battle
		 */
		public function BattleSceneViewCanvas(battle:BattleModel) {
			super();

			data = battle;
			camera.bound.x = -battle.width;
			camera.bound.y = -battle.height;
			camera.bound.width = battle.width * 3;
			camera.bound.height = battle.height * 3;
			camera.center = new Point(battle.left + ((battle.col * battle.cellPixel) >> 1), battle.top + ((battle.row * battle.cellPixel) >> 1));

			addChild(layerTerrian = new BattleSceneLayerTerrian(battle, camera));
			addChild(layerDebug = new BattleSceneLayerDebug(battle, camera));
			layers = {};
			layers["floor"] = addChild(new BattleSceneLayerOverland("floor", battle, camera)),
			layers["over"] = addChild(new BattleSceneLayerOverland("over", battle, camera));
			addChild(layerDispatch = new GPaperLayer(camera));
			lineShape = new LineShape(model);

			keyboard = new Keyboard2();
			_quadTree = new GQuadtree(new Rectangle(0, 0, model.col, model.row));
			dispatchAvatar = null;
		}
		
		override protected function doInit():void {
			super.doInit();
			
			//add listener
			addEventListener(KeyboardEvent.KEY_DOWN, _handleKeyEvent);
			addEventListener(KeyboardEvent.KEY_UP, _handleKeyEvent);
			addEventListener(MouseEvent.MOUSE_DOWN, _handleMouseEvent);
			addEventListener(MouseEvent.MOUSE_MOVE, _handleMouseEvent);
			GameMain.instance.gameChannel.addEventListener(RpcEvent.DATA, _handleGameChannelEvent);
			enableTick = true;
		}

		private function _handleMouseEvent(event:MouseEvent):void {
			var c:int = (camera.screenRect.x + mouseX - model.left) / model.cellPixel;
			var r:int = (camera.screenRect.y + mouseY - model.top) / model.cellPixel;
			switch (event.type) {
				case MouseEvent.MOUSE_MOVE:
					if (_dispatchAvatar) {
						if (c < 0 || c >= model.col) {
							if (lineShape.parent)
								lineShape.parent.removeChild(lineShape);
						} else {
							lineShape.x = model.left + c * model.cellPixel;
							lineShape.y = model.top;
							layerDispatch.addChild(lineShape);
						}
					}
					break;
				case MouseEvent.MOUSE_DOWN:
					if (_dispatchAvatar && c >= 0 && c < model.col)
						GameMain.instance.battleService.dispatch(_dispatchAvatar.confId, c, r);
					break;
			}
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
			if (event.response is BattleSignalSkillUseProtocol) {
				var skillUsing:BattleSignalSkillUseProtocol = event.response as BattleSignalSkillUseProtocol;
			} else if (event.response is PropertyEventProtocol) {
				var change:PropertyEventProtocol = event.response as PropertyEventProtocol;
				if (change.item is BattleItemModel) {
					var battleItem:BattleItemModel = change.item as BattleItemModel;
					switch (change.type) {
						case 1:
							if (change.item is BattleItemModel) {
								battleItem.battle = model;
								for each (var layer:BattleSceneLayerOverland in layers) {
									layer.addItem(change.item as BattleItemModel);
								}
							}
							break;
						case 2:
							(model.items[battleItem.instanceId] as GBean).merge(battleItem as GBean);
							break;
						case 3:
							battleItem = model.items[battleItem.instanceId];
							battleItem.battle = null;
							for each (layer in layers) {
								layer.removeItem(battleItem, .7);
							}
							break;
						case 4:
							battleItem = model.items[battleItem.instanceId];
							break;
						case 5:
							battleItem = model.items[battleItem.instanceId];
							battleItem.battle = null;
							var view:*;
							for each (layer in layers) {
								view ||= layer.removeItem(battleItem, .7);
							}
							var skillView:SkillSceneView = new SkillSceneView(null);
							skillView.x = view.x;
							skillView.y = view.y;
							(layers["over"] as BattleSceneLayerOverland).addChild(skillView);
							break;
						default:
							throw new Error("unknown type");
							break;
					}
				} else if (change.item is BattlePlayerModel) {
					var sourcePlayerModel:BattlePlayerModel = change.item as BattlePlayerModel;
					for each (var force:BattleForceProtocol in model.forces) {
						for each (var playerModel:BattlePlayerModel in force.players) {
							if (playerModel.instanceId == sourcePlayerModel.instanceId) {
								playerModel.merge(sourcePlayerModel);
								break;
							}
						}
					}
				} else if (change.item is BattleForceProtocol) {
					var sourceForce:BattleForceProtocol = change.item as BattleForceProtocol;
					(model.forces[sourceForce.id] as BattleForceProtocol).merge(sourceForce);
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
			/*var serverNow:Number = GameModel.instance.application.serverTime;
			var heap:GBinaryHeap = model.taskHeap;
			while (heap.size) {
				var head:ITaskModel = heap.content[0];
				if (serverNow > head.nextExecuteTime) {
					heap.pop();
					head.execute(serverNow);
				} else {
					break;
				}
			}*/
			
			//update Items
			layerTerrian.tick(interval);
			for each (var layer:BattleSceneLayerOverland in layers) {
				for (var child:* in layer.childrenDict) {
					if (child is IGTickable)
						(child as IGTickable).tick(interval);
				}
				layer.tick(interval);
			}

			//handle keyboard
			/*var skillKeys:Object = {};
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
				collisionItems = _quadTree.retrieve(collisionBounds);
				manualTouchItemUuids.sort(
					function(a:BattleItemModel, b:BattleItemModel, ...res):Boolean {
						return Math.pow(model.loginedBattleUser.x + model.loginedBattleUser.width / 2 - a.x - a.width / 2, 2) + Math.pow(model.loginedBattleUser.y + model.loginedBattleUser.height / 2 - a.y - a.height / 2, 2)
							> Math.pow(model.loginedBattleUser.x + model.loginedBattleUser.width / 2 - b.x - b.width / 2, 2) + Math.pow(model.loginedBattleUser.y + model.loginedBattleUser.height / 2 - b.y - b.height / 2, 2);
					}
				)
			}*/
			
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
					_lastBoardKey = currentKey;
				} else if (currentKey == Keyboard.KEY_RIGHT) {
					_lastBoardKey = currentKey;
				} else if (currentKey == Keyboard.KEY_DOWN) {
					_lastBoardKey = currentKey;
				} else if (currentKey == Keyboard.KEY_LEFT) {
					_lastBoardKey = currentKey;
				} else {
					_lastBoardKey = null;
				}
			}
			keyboard.update();
		}
		
		override protected function doValidateLayout():void {
			camera.screenRect = new Rectangle(camera.screenRect.x, camera.screenRect.y, width, height);
			camera._refreshCenter();
			
			super.doValidateLayout();
		}
	}
}
import com.gearbrother.glash.display.GDisplaySprite;
import com.gearbrother.glash.display.flixel.input.Keyboard;
import com.gearbrother.mushroomWar.model.BattleModel;
import com.greensock.TweenLite;
import com.greensock.TweenMax;

import flash.display.Shape;
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

class LineShape extends GDisplaySprite {
	private var tween:TweenMax;

	public function LineShape(model:BattleModel) {
		graphics.beginFill(0x00ff33, 1);
		graphics.drawRect(0, 0, model.cellPixel, model.row * model.cellPixel);
		graphics.endFill();
	}

	override protected function doInit():void {
		super.doInit();

		this.alpha = .2;
		this.tween = TweenMax.to(this, .7, {colorTransform: {brightness: 1.3}, "alpha": .3, yoyo: true, repeat: -1});
	}
	
	override protected function doDispose():void {
		this.tween.kill();
	}
}