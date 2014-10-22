package com.gearbrother.mushroomWar.view.layer.scene {
	import com.gearbrother.glash.common.oper.GOper;
	import com.gearbrother.glash.common.oper.ext.GAliasFile;
	import com.gearbrother.glash.common.oper.ext.GFile;
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.container.GContainer;
	import com.gearbrother.glash.display.container.GHBox;
	import com.gearbrother.glash.display.control.GButton;
	import com.gearbrother.glash.display.control.GButtonLite;
	import com.gearbrother.glash.display.control.GSelectGroup;
	import com.gearbrother.glash.display.event.GDndEvent;
	import com.gearbrother.glash.display.layout.impl.BorderLayout;
	import com.gearbrother.glash.display.layout.impl.CenterLayout;
	import com.gearbrother.glash.display.layout.impl.FlowLayout;
	import com.gearbrother.glash.display.layout.impl.GridLayout;
	import com.gearbrother.glash.mvc.model.GBean;
	import com.gearbrother.mushroomWar.GameMain;
	import com.gearbrother.mushroomWar.model.BattleModel;
	import com.gearbrother.mushroomWar.model.BattlePlayerModel;
	import com.gearbrother.mushroomWar.model.CharacterModel;
	import com.gearbrother.mushroomWar.model.GameModel;
	import com.gearbrother.mushroomWar.model.NationModel;
	import com.gearbrother.mushroomWar.model.SkillModel;
	import com.gearbrother.mushroomWar.rpc.event.RpcEvent;
	import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BattleForceProtocol;
	import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BattlePlayerProtocol;
	import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BattleProtocol;
	import com.gearbrother.mushroomWar.rpc.protocol.bussiness.BattleSignalBeginProtocol;
	import com.gearbrother.mushroomWar.rpc.protocol.bussiness.PropertyEventProtocol;
	import com.gearbrother.mushroomWar.view.common.ui.AvatarUiView;
	import com.gearbrother.mushroomWar.view.common.ui.RoomPlayerUiView;
	import com.gearbrother.mushroomWar.view.common.ui.SkillUiView;
	import com.gearbrother.mushroomWar.view.layer.scene.battle.BattleSceneView;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import org.as3commons.lang.ObjectUtils;


	/**
	 * @author lifeng
	 * @create on 2013-12-6
	 */
	public class RoomSceneView extends GContainer {
		public var leftPane:GContainer;
		public var leftPlayerList:GContainer;
		
		public var centerPane:GContainer;
		
		public var rightPane:GContainer;
		public var rightPlayerList:GContainer;
		
		public var playerUIs:Object;
		
		public var filterGroup:GSelectGroup;

		private var sortAll:GButton;
		private var sort1:GButton;
		private var sort2:GButton;
		private var sort3:GButton;
		private var sort4:GButton;
		public var myHeroPane:GContainer;
		
		public var confirmBtn:GButton;
		public var switchMapBtn:GButton;
		
		public function RoomSceneView(room:BattleModel) {
			super();
			
			libs = [new GAliasFile("static/asset/skin/battle.swf")];
			layout = new BorderLayout();
			append(leftPane = new GContainer(), BorderLayout.WEST);
			leftPane.layout = new CenterLayout();
			leftPane.append(leftPlayerList = new GContainer());
			leftPlayerList.layout = new GridLayout(0, 1, 0, 7);
			append(centerPane = new GContainer(), BorderLayout.CENTER);
			centerPane.layout = new BorderLayout();
			var hbox:GHBox = new GHBox();
			sortAll = new GButton();
			sortAll.bindData = [1, 2, 3];
			sortAll.text = "所有";
			hbox.addChild(sortAll);
			sort1 = new GButton();
			sort1.bindData = [NationModel.WEI.id];
			sort1.text = "魏";
			hbox.addChild(sort1);
			sort2 = new GButton();
			sort2.bindData = [NationModel.SHU.id];
			sort2.text = "蜀";
			hbox.addChild(sort2);
			sort3 = new GButton();
			sort3.text = "吴";
			sort3.bindData = [NationModel.WU.id];
			hbox.addChild(sort3);
			sort4 = new GButton();
			sort4.text = "群";
			sort4.bindData = [NationModel.QUN.id];
			hbox.addChild(sort4);
			sortAll.toggle = sort1.toggle = sort2.toggle = sort3.toggle = sort4.toggle = true;
			filterGroup = sortAll.selectedGroup = sort1.selectedGroup = sort2.selectedGroup = sort3.selectedGroup = sort4.selectedGroup = new GSelectGroup();
			filterGroup.addEventListener(Event.CHANGE, _handleFilterChanged);
			filterGroup.selectedItem = sortAll;
			centerPane.append(hbox, BorderLayout.NORTH);
			centerPane.append(myHeroPane = new GContainer(), BorderLayout.CENTER);
			myHeroPane.layout = new FlowLayout();
			myHeroPane.wheelScroll = true;
			hbox = new GHBox();
			hbox.addChild(confirmBtn = new GButton());
			confirmBtn.text = "ready";
			hbox.addChild(switchMapBtn = new GButton());
			switchMapBtn.text = "换地图";
			centerPane.append(hbox, BorderLayout.SOUTH);
			append(rightPane = new GContainer(), BorderLayout.EAST);
			rightPane.layout = new CenterLayout();
			rightPane.append(rightPlayerList = new GContainer());
			rightPlayerList.layout = new GridLayout(0, 1, 0, 5);
			addEventListener(MouseEvent.CLICK, _handleMouseEvent);
			bindData = room;
		}
		
		override protected function doInit():void {
			super.doInit();
			
			GameMain.instance.gameChannel.addEventListener(RpcEvent.DATA, _handleGameChannel);
		}
		
		override protected function _handleLibsSuccess(res:*):void {
			var file:GFile = libsHandler.cachedOper[libs[0]];
			playerUIs = {};
			playerUIs[0] = [];
			playerUIs[1] = [];
			var model:BattleModel = bindData as BattleModel;
			var forces:Array = ObjectUtils.getProperties(model.forces);
			for (var i:int = 0; i < forces.length; i++) {
				var force:BattleForceProtocol = forces[i];
				for (var j:int = 0; j < force.maxPlayer; j++) {
					switch (i) {
						case 0:
							var playerUi:RoomPlayerUiView = leftPlayerList.addChild(new RoomPlayerUiView(file.getInstance("PlayerSkin"))) as RoomPlayerUiView;
							playerUi.addEventListener(MouseEvent.CLICK, _handleMouseEvent);
							(playerUIs[0] as Array).push(playerUi);
							break;
						case 1:
							playerUi = rightPlayerList.addChild(new RoomPlayerUiView(file.getInstance("PlayerSkin"))) as RoomPlayerUiView;
							playerUi.addEventListener(MouseEvent.CLICK, _handleMouseEvent);
							(playerUIs[1] as Array).push(playerUi);
							break;
						default:
							throw new Error("unknown force");
							break;
					}
				}
			}
			_handleFilterChanged();
			revalidateBindData();
		}

		override public function handleModelChanged(events:Object=null):void {
			var model:BattleModel = bindData as BattleModel;
			var file:GFile = libsHandler.cachedOper[libs[0]];
			if (file.resultType == GOper.RESULT_TYPE_SUCCESS) {
				if (!events || events.hasOwnProperty(BattleProtocol.FORCES)) {
					for (var key:String in playerUIs) {
						var players:Array = (model.forces[key] as BattleForceProtocol).players;
						for (var i:int = 0; i < (playerUIs[key] as Array).length; i++) {
							var playerUi:RoomPlayerUiView = (playerUIs[key] as Array)[i];
							playerUi.bindData = players.hasOwnProperty(i) ? players[i] : null;
						}
					}
				}
			}
		}

		private function _handleFilterChanged(event:Event = null):void {
			var file:GFile = libsHandler.cachedOper[libs[0]];
			if (file && file.resultType == GOper.RESULT_TYPE_SUCCESS) {
				var filteredNations:Array = filterGroup.selectedItem.bindData;
				myHeroPane.removeAllChildren();
				var heroes:Array = ObjectUtils.getProperties(GameModel.instance.loginedUser.heroes);
				for (var i:int = 0; i < heroes.length; i++) {
					var hero:CharacterModel = heroes[i];
					if (filteredNations.indexOf(hero.nation) > -1) {
						var avatarUiView:AvatarUiView = new AvatarUiView(file.getInstance("CharacterUiSkin"));//myHeroViews[i] as AvatarUiView;
						/*avatarUiView.dndData = */avatarUiView.bindData = hero;
//						avatarUiView.dndable = true;
						myHeroPane.addChild(avatarUiView);
					}
				}
			}
		}
		
		private function _handleGameChannel(event:RpcEvent):void {
			var model:BattleModel = bindData;
			if (event.response is BattleSignalBeginProtocol) {
				remove();
				var signal:BattleSignalBeginProtocol = event.response as BattleSignalBeginProtocol;
				var battle:BattleModel = signal.battle as BattleModel;
				GameMain.instance.scenelayer.addChild(new BattleSceneView(battle));
			} else if (event.response is BattleModel) {
				(bindData as BattleModel).merge(event.response as BattleModel);
			} else if (event.response is PropertyEventProtocol) {
				var propertyEvent:PropertyEventProtocol = event.response as PropertyEventProtocol;
				var remotePlayer:BattlePlayerModel;
				switch (propertyEvent.type) {
					case 1:
						if (propertyEvent.item is BattlePlayerModel) {
							remotePlayer = propertyEvent.item as BattlePlayerModel;
							(model.forces[remotePlayer.forceId] as BattleForceProtocol).players.push(remotePlayer);
							model.setPropertyChanged(BattleProtocol.FORCES);
						}
						break;
					case 2:
						if (propertyEvent.item is BattlePlayerModel) {
							remotePlayer = propertyEvent.item as BattlePlayerModel;
							for (var key:String in model.forces) {
								var force:BattleForceProtocol = model.forces[key];
								for each (var player2:BattlePlayerModel in force.players) {
									if (player2.instanceId == remotePlayer.instanceId) {
										player2.merge(remotePlayer);
										break;
									}
								}
							}
						}
						break;
					case 3:
						if (propertyEvent.item is BattlePlayerModel) {
							remotePlayer = propertyEvent.item as BattlePlayerModel;
							force = model.forces[remotePlayer.forceId] as BattleForceProtocol;
							for (var i:int = 0; i < force.players.length; i++) {
								if ((force.players[i] as BattlePlayerModel).instanceId == remotePlayer.instanceId) {
									force.players.splice(i, 1);
									break;
								}
							}
							model.setPropertyChanged(BattleProtocol.FORCES);
						}
						break;
				}
			}
		}
		
		private function _handleMouseEvent(event:MouseEvent):void {
			var model:BattleModel = bindData as BattleModel;
			if (event.target is AvatarUiView) {
				if ((event.target as AvatarUiView).bindData is CharacterModel) {
					var heroModel:CharacterModel = (event.target as AvatarUiView).bindData;
					for (var i:int = 0; i < leftPlayerList.numChildren; i++) {
						var playerUi:RoomPlayerUiView = leftPlayerList.getChildAt(i) as RoomPlayerUiView;
						if (playerUi.choosedHeroViews.indexOf(event.target) > -1) {
							GameMain.instance.roomService.removeHero(heroModel.uuid);
							break;
						}
					}
					for (i = 0; i < rightPlayerList.numChildren; i++) {
						playerUi = rightPlayerList.getChildAt(i) as RoomPlayerUiView;
						if (playerUi.choosedHeroViews.indexOf(event.target) > -1) {
							GameMain.instance.roomService.removeHero(heroModel.uuid);
							break;
						}
					}
					GameMain.instance.roomService.addHero(heroModel.uuid);
				}
			} else if (event.target == confirmBtn) {
				GameMain.instance.roomService.ready();
			} else if (event.target == switchMapBtn) {
				GameMain.instance.roomService.switchMap();
			} else if (event.currentTarget is RoomPlayerUiView) {
				var playerUiView:RoomPlayerUiView = event.currentTarget as RoomPlayerUiView;
				for (var key:String in playerUIs) {
					if ((playerUIs[key] as Array).indexOf(playerUiView) > -1) {
						GameMain.instance.roomService.switchForce(key);
						break;
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
