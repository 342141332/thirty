package com.gearbrother.sheepwolf.view.layer.scene {
	import com.gearbrother.glash.common.oper.ext.GAliasFile;
	import com.gearbrother.glash.common.oper.ext.GFile;
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.control.GButton;
	import com.gearbrother.glash.display.event.GDndEvent;
	import com.gearbrother.sheepwolf.GameMain;
	import com.gearbrother.sheepwolf.model.AvatarModel;
	import com.gearbrother.sheepwolf.model.BattleModel;
	import com.gearbrother.sheepwolf.model.BattleRoomModel;
	import com.gearbrother.sheepwolf.model.BattleItemUserModel;
	import com.gearbrother.sheepwolf.model.GameModel;
	import com.gearbrother.sheepwolf.model.SkillModel;
	import com.gearbrother.sheepwolf.model.UserModel;
	import com.gearbrother.sheepwolf.rpc.event.RpcEvent;
	import com.gearbrother.sheepwolf.rpc.protocol.bussiness.BattleRoomSeatProtocol;
	import com.gearbrother.sheepwolf.rpc.protocol.bussiness.BattleSignalBeginProtocol;
	import com.gearbrother.sheepwolf.rpc.protocol.bussiness.BattleSignalReadyProtocol;
	import com.gearbrother.sheepwolf.view.common.ui.AvatarUiView;
	import com.gearbrother.sheepwolf.view.common.ui.SkillUiView;
	import com.gearbrother.sheepwolf.view.layer.scene.battle.BattleSceneView;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.as3commons.lang.ObjectUtils;


	/**
	 * @author lifeng
	 * @create on 2013-12-6
	 */
	public class RoomSceneView extends GNoScale {
		public var seatViews:Array;
		
		public var myWeaponViews:Array;
		
		public var myToolViews:Array;
		
		public var confirmBtn:GButton;

		private var switchMapBtn:GButton;

		override public function set skin(newValue:DisplayObject):void {
			super.skin = newValue;

			seatViews = [];
			for (var i:int = 0;;i++) {
				var child:Sprite = (skin as DisplayObjectContainer).getChildByName("seat" + i) as Sprite;
				if (child) {
					var seatView:AvatarUiView = new AvatarUiView(child);
					seatView.addEventListener(MouseEvent.CLICK, _handleMouseEvent);
					seatView.addEventListener(GDndEvent.Drop, _handleDndEvent);
					seatViews.push(seatView);
				} else {
					break;
				}
			}
			myWeaponViews = [];
			for (i = 0;;i++) {
				child = (skin as DisplayObjectContainer).getChildByName("weapon" + i) as Sprite;
				if (child)
					myWeaponViews.push(new SkillUiView(child));
				else
					break;
			}
			myToolViews = [];
			for (i = 0;;i++) {
				child = (skin as DisplayObjectContainer).getChildByName("skill" + i) as Sprite;
				if (child)
					myToolViews.push(new SkillUiView(child));
				else
					break;
			}
			confirmBtn = new GButton(skin["confirmBtn"]);
			confirmBtn.text = "开始";
			confirmBtn.addEventListener(MouseEvent.CLICK, _handleMouseEvent);
			switchMapBtn = new GButton(skin["switchMapBtn"]);
			switchMapBtn.text = "换地图";
			switchMapBtn.addEventListener(MouseEvent.CLICK, _handleMouseEvent);
		}
		
		public function RoomSceneView(room:BattleRoomModel) {
			super();
			
			bindData = room;
			//preload battle's libs
			libs = [new GAliasFile("static/asset/skin/battle.swf"), new GAliasFile("static/asset/item/block.swf")];
		}
		
		override protected function _handleLibsSuccess(res:*):void {
			var file:GFile = libsHandler.cachedOper[libs[0]];
			skin = file.getInstance("BattleSkin");
			revalidateBindData();
		}
		
		override protected function doInit():void {
			super.doInit();
			
			GameMain.instance.gameChannel.addEventListener(RpcEvent.DATA, _handleGameChannel);
		}
		
		override public function handleModelChanged(events:Object=null):void {
			var model:BattleRoomModel = bindData as BattleRoomModel;
			if (skin) {
				for (var i:int = 0; i < seatViews.length; i++) {
					if (model.seats.hasOwnProperty(i) && model.seats[i]) {
						(seatViews[i] as AvatarUiView).bindData = (model.seats[i] as BattleRoomSeatProtocol).avatar;
					} else {
						(seatViews[i] as AvatarUiView).bindData = null;
					}
				}
				if (!events) {
					var bagItems:Array = ObjectUtils.getProperties(GameModel.instance.loginedUser.bagItems);
					var weapons:Array = bagItems.filter(
						function(d:*, ...res):Boolean {
							if (d is SkillModel) {
								var skillModel:SkillModel = d;
								return skillModel.category == SkillModel.CATEGORY_WEAPON;
							}
							return false;
						}
					);
					for (i = 0; i < myWeaponViews.length; i++) {
						var toolUiView:SkillUiView = myWeaponViews[i] as SkillUiView;
						if (weapons.hasOwnProperty(i)) {
							toolUiView.dndData = toolUiView.bindData = weapons[i];
							toolUiView.dndable = true;
						} else {
							toolUiView.bindData = null;
							toolUiView.dndable = false;
						}
					}
					var tools:Array = bagItems.filter(
						function(d:*, ...res):Boolean {
							if (d is SkillModel) {
								var skillModel:SkillModel = d;
								return skillModel.category == SkillModel.CATEGORY_TOOL;
							}
							return false;
						}
					);
					for (i = 0; i < myToolViews.length; i++) {
						toolUiView = myToolViews[i];
						if (tools.hasOwnProperty(i)) {
							toolUiView.dndData = toolUiView.bindData = tools[i];
							toolUiView.dndable = true;
						} else {
							toolUiView.bindData = null;
							toolUiView.dndable = false;
						}
					}
				}
			}
		}
		
		private function _handleGameChannel(event:RpcEvent):void {
			if (event.response is BattleSignalBeginProtocol) {
				remove();
				var signal:BattleSignalBeginProtocol = event.response as BattleSignalBeginProtocol;
				var battle:BattleModel = signal.battle as BattleModel;
				if (battle.items.hasOwnProperty(GameModel.instance.loginedUser.uuid))
					battle.loginedBattleUser = battle.items[GameModel.instance.loginedUser.uuid];
				GameMain.instance.scenelayer.addChild(new BattleSceneView(battle));
			} else if (event.response is BattleRoomModel) {
				(bindData as BattleRoomModel).merge(event.response as BattleRoomModel);
				handleModelChanged();
			} else if (event.response is BattleSignalReadyProtocol) {
				var ready:BattleSignalReadyProtocol = event.response as BattleSignalReadyProtocol;
				((bindData as BattleRoomModel).battle.items[ready.readyUser.uuid] as BattleItemUserModel).merge(ready.readyUser);
			}
		}
		
		private function _handleMouseEvent(event:MouseEvent):void {
			if (event.currentTarget is AvatarUiView) {
				if ((event.currentTarget as AvatarUiView).bindData is AvatarModel) {
					var seatModel:AvatarModel = (event.currentTarget as AvatarUiView).bindData;
					var avatarKeys:Array = ObjectUtils.getKeys(GameModel.instance.loginedUser.avatars);
					if (GameModel.instance.loginedUser.avatars.hasOwnProperty(seatModel.uuid)) {
						var at:int = avatarKeys.indexOf(seatModel.uuid);
						GameMain.instance.roomService.switchAvatar(avatarKeys[(at + 1) % avatarKeys.length]);
						return;
					}
				}
				if (seatViews.indexOf(event.currentTarget) > -1) {
					GameMain.instance.roomService.switchSeat(seatViews.indexOf(event.currentTarget));
				}
			} else if (event.currentTarget == confirmBtn) {
				if (confirmBtn.enabled)
					GameMain.instance.roomService.startRoom((bindData as BattleRoomModel).uuid);
			} else if (event.currentTarget == switchMapBtn) {
				GameMain.instance.roomService.switchMap();
			}
		}
		
		private function _handleDndEvent(event:GDndEvent):void {
			if (event.target is SkillUiView && event.data is SkillModel) {
				var skill:SkillModel = event.data as SkillModel;
				var target:DisplayObject = event.target as DisplayObject;
				var seatView:AvatarUiView =event.currentTarget as AvatarUiView;
				if (seatView.bindData is AvatarModel && GameModel.instance.loginedUser.avatars.hasOwnProperty((seatView.bindData as AvatarModel).uuid)) {
					var at:int = seatView.weaponViews.indexOf(target);
					if (at > -1) {
						GameMain.instance.roomService.setWeapon((seatView.bindData as AvatarModel).uuid, skill.confId, at);
					}
					at = seatView.toolViews.indexOf(target);
					if (at > -1) {
						GameMain.instance.roomService.setTool((seatView.bindData as AvatarModel).uuid, skill.confId, at);
					}
				}
			}
		}

		override protected function doDispose():void {
			super.doDispose();
			
			GameMain.instance.gameChannel.removeEventListener(RpcEvent.DATA, _handleGameChannel);
		}
	}
}
