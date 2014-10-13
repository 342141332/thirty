package com.gearbrother.mushroomWar.view.layer.scene {
	import com.gearbrother.glash.common.oper.ext.GAliasFile;
	import com.gearbrother.glash.common.oper.ext.GFile;
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.control.GButton;
	import com.gearbrother.glash.display.event.GDndEvent;
	import com.gearbrother.glash.mvc.model.GBean;
	import com.gearbrother.mushroomWar.GameMain;
	import com.gearbrother.mushroomWar.model.CharacterModel;
	import com.gearbrother.mushroomWar.model.BattleModel;
	import com.gearbrother.mushroomWar.model.BattleRoomModel;
	import com.gearbrother.mushroomWar.model.BattleRoomSeatModel;
	import com.gearbrother.mushroomWar.model.GameModel;
	import com.gearbrother.mushroomWar.model.SkillModel;
	import com.gearbrother.mushroomWar.rpc.event.RpcEvent;
	import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BattleRoomProtocol;
	import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BattleRoomSeatProtocol;
	import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BattleSignalBeginProtocol;
	import com.gearbrother.mushroomWar.rpc.protocol.bussiness.PropertyEventProtocol;
	import com.gearbrother.mushroomWar.view.common.ui.AvatarUiView;
	import com.gearbrother.mushroomWar.view.common.ui.RoomSeatUiView;
	import com.gearbrother.mushroomWar.view.common.ui.SkillUiView;
	import com.gearbrother.mushroomWar.view.layer.scene.battle.BattleSceneView;
	
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
		
		public var myHeroViews:Array;
		
		public var myToolViews:Array;
		
		public var confirmBtn:GButton;

		private var switchMapBtn:GButton;

		override public function set skin(newValue:DisplayObject):void {
			super.skin = newValue;

			seatViews = [];
			for (var i:int = 0;;i++) {
				var child:Sprite = (skin as DisplayObjectContainer).getChildByName("seat" + i) as Sprite;
				if (child) {
					var seatView:RoomSeatUiView = new RoomSeatUiView(child);
					seatView.addEventListener(MouseEvent.CLICK, _handleMouseEvent);
					seatView.addEventListener(GDndEvent.Drop, _handleDndEvent);
					seatViews.push(seatView);
				} else {
					break;
				}
			}
			myHeroViews = [];
			for (i = 0;;i++) {
				child = (skin as DisplayObjectContainer).getChildByName("hero" + i) as Sprite;
				if (child)
					myHeroViews.push(new AvatarUiView(child));
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
			libs = [new GAliasFile("static/asset/skin/battle.swf")];
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
						(seatViews[i] as RoomSeatUiView).bindData = model.seats[i];
					} else {
						(seatViews[i] as RoomSeatUiView).bindData = null;
					}
				}
				if (!events) {
					var heroes:Array = ObjectUtils.getProperties(GameModel.instance.loginedUser.heroes);
					/*for (i = 0; i < myHeroViews.length; i++) {
						var avatarUiView:AvatarUiView = myHeroViews[i] as AvatarUiView;
						if (heroes.hasOwnProperty(i)) {
							avatarUiView.dndData = avatarUiView.bindData = heroes[i];
							avatarUiView.dndable = true;
						} else {
							avatarUiView.bindData = null;
							avatarUiView.dndable = false;
						}
					}*/
					var bagItems:Array = ObjectUtils.getProperties(GameModel.instance.loginedUser.bagItems);
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
						var toolUiView:SkillUiView = myToolViews[i];
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
			var model:BattleRoomModel = bindData;
			if (event.response is BattleSignalBeginProtocol) {
				remove();
				var signal:BattleSignalBeginProtocol = event.response as BattleSignalBeginProtocol;
				var battle:BattleModel = signal.battle as BattleModel;
				for each (var seat:BattleRoomSeatModel in model.seats) {
					if (seat && seat.instanceId == GameModel.instance.loginedUser.uuid)
						battle.loginedBattleUser = seat;
				}
				GameMain.instance.scenelayer.addChild(new BattleSceneView(battle));
			} else if (event.response is BattleRoomModel) {
				(bindData as BattleRoomModel).merge(event.response as BattleRoomModel);
			} else if (event.response is PropertyEventProtocol) {
				var propertyEvent:PropertyEventProtocol = event.response as PropertyEventProtocol;
				switch (propertyEvent.type) {
					case 1:
						if (propertyEvent.item is BattleRoomSeatModel) {
							var seatModel:BattleRoomSeatModel = propertyEvent.item as BattleRoomSeatModel;
							model.seats[seatModel.index] = seatModel;
							model.setPropertyChanged(BattleRoomProtocol.SEATS);
						}
						break;
					case 2:
						if (propertyEvent.item is BattleRoomSeatModel) {
							seatModel = propertyEvent.item as BattleRoomSeatModel;
							(model.seats[seatModel.index] as GBean).merge(seatModel);
							model.setPropertyChanged(BattleRoomProtocol.SEATS);
						} else if (propertyEvent.item is BattleRoomModel) {
							model.merge(propertyEvent.item as GBean);
						}
						break;
					case 3:
						if (propertyEvent.item is BattleRoomSeatModel) {
							seatModel = propertyEvent.item as BattleRoomSeatModel;
							delete model.seats[seatModel.index];
							model.setPropertyChanged(BattleRoomProtocol.SEATS);
						}
						break;
				}
			}
		}
		
		private function _handleMouseEvent(event:MouseEvent):void {
			if (event.currentTarget is AvatarUiView) {
				if ((event.currentTarget as AvatarUiView).bindData is CharacterModel) {
					var seatModel:CharacterModel = (event.currentTarget as AvatarUiView).bindData;
					var avatarKeys:Array = ObjectUtils.getKeys(GameModel.instance.loginedUser.heroes);
					if (GameModel.instance.loginedUser.heroes.hasOwnProperty(seatModel.uuid)) {
						var at:int = avatarKeys.indexOf(seatModel.uuid);
//						GameMain.instance.roomService.switchAvatar(avatarKeys[(at + 1) % avatarKeys.length]);
						return;
					}
				}
			} else if (event.currentTarget is RoomSeatUiView) {
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
			if (event.target is AvatarUiView && event.data is CharacterModel) {
				var avatarModel:CharacterModel = event.data as CharacterModel;
				var target:DisplayObject = event.target as DisplayObject;
				var seatUiView:RoomSeatUiView = event.currentTarget as RoomSeatUiView;
				if (seatUiView.bindData is BattleRoomSeatModel) {
					var at:int = seatUiView.choosedHeroViews.indexOf(target);
					if (at > -1) {
						GameMain.instance.roomService.setHero(avatarModel.uuid, at);
					}
					at = seatUiView.toolViews.indexOf(target);
					if (at > -1) {
						GameMain.instance.roomService.setTool((seatUiView.bindData as CharacterModel).uuid, avatarModel.uuid, at);
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
