package com.gearbrother.mushroomWar.view.layer.scene {
	import com.gearbrother.glash.display.container.GContainer;
	import com.gearbrother.glash.display.container.GHBox;
	import com.gearbrother.glash.display.container.GVBox;
	import com.gearbrother.glash.display.control.GButton;
	import com.gearbrother.glash.display.control.text.GText;
	import com.gearbrother.glash.display.layout.impl.BorderLayout;
	import com.gearbrother.glash.mvc.model.GBean;
	import com.gearbrother.mushroomWar.GameMain;
	import com.gearbrother.mushroomWar.model.BattleRoomModel;
	import com.gearbrother.mushroomWar.model.HallModel;
	import com.gearbrother.mushroomWar.rpc.event.RpcEvent;
	import com.gearbrother.mushroomWar.rpc.protocol.bussiness.HallProtocol;
	import com.gearbrother.mushroomWar.rpc.protocol.bussiness.PropertyEventProtocol;
	
	import flash.events.MouseEvent;
	
	import org.as3commons.lang.ObjectUtils;



	/**
	 * @author lifeng
	 * @create on 2013-12-6
	 */
	public class HallSceneView extends GContainer {
		private var _roomList:GVBox;
		private var _mapId:GButton;
		private var _createRoomBtn:GButton;
		
		public function HallSceneView(hall:HallModel) {
			super();
			
			layout = new BorderLayout();
			append(_roomList = new GVBox(), BorderLayout.CENTER);
			var hbox:GContainer = new GContainer();
			hbox.layout = new BorderLayout();
			hbox.append(_mapId = new GButton(), BorderLayout.WEST);
			_mapId.text = hall.mapIds[0];
			hbox.append(_createRoomBtn = new GButton(), BorderLayout.CENTER);
			_createRoomBtn.text = "Create Hall";
			append(hbox, BorderLayout.SOUTH);
			addEventListener(MouseEvent.CLICK, _handleMouseEvent);
			bindData = hall;
		}
		
		override protected function doInit():void {
			super.doInit();

			GameMain.instance.gameChannel.addEventListener(RpcEvent.DATA, _handleGameChannel);
		}
		
		private function _handleMouseEvent(event:MouseEvent):void {
			if (event.target == _createRoomBtn) {
				GameMain.instance.roomService.createRoom(_mapId.text
					, function(res:*):void {
						var room:BattleRoomModel = res;
						GameMain.instance.scenelayer.addChild(new RoomSceneView(room));
					}
				);
			} else if (event.target == _mapId) {
				var mapIds:Array = (bindData as HallModel).mapIds;
				var at:int = mapIds.indexOf(_mapId.text);
				at++;
				at = at % mapIds.length;
				_mapId.text = mapIds[at];
				_mapId.revalidateLayout();
			} else if (event.target is GButton && (event.target as GButton).data is BattleRoomModel) {
				var room:BattleRoomModel = (event.target as GButton).data;
				GameMain.instance.roomService.enterRoom(room.uuid
					, function(res:*):void {
						GameMain.instance.scenelayer.addChild(new RoomSceneView(res as BattleRoomModel));
					}
				);
			}
		}
		
		private function _handleGameChannel(event:RpcEvent):void {
			var model:HallModel = bindData;
			if (event.response is PropertyEventProtocol) {
				var propertyEvent:PropertyEventProtocol = event.response as PropertyEventProtocol;
				switch (propertyEvent.type) {
					case 1:
						if (propertyEvent.item is BattleRoomModel) {
							var roomModel:BattleRoomModel = propertyEvent.item as BattleRoomModel;
							model.rooms[roomModel.uuid] = roomModel;
							model.setPropertyChanged(HallProtocol.ROOMS);
						}
						break;
					case 2:
						if (propertyEvent.item is BattleRoomModel) {
							roomModel = propertyEvent.item as BattleRoomModel;
							(model.rooms[roomModel.uuid] as GBean).merge(roomModel);
							model.setPropertyChanged(HallProtocol.ROOMS);
						}
						break;
					case 3:
						if (propertyEvent.item is BattleRoomModel) {
							roomModel = propertyEvent.item as BattleRoomModel;
							delete model.rooms[roomModel.uuid];
							model.setPropertyChanged(HallProtocol.ROOMS);
						}
						break;
				}
			}
		}
		
		override public function handleModelChanged(events:Object=null):void {
			var hall:HallModel = bindData;
			if (!events || events.hasOwnProperty(HallProtocol.ROOMS)) {
				_roomList.removeAllChildren();
				for each (var room:BattleRoomModel in hall.rooms) {
					var line:GHBox = new GHBox();
					var label:GText;
					line.addChild(label = new GText());
					label.fontColor = 0xFFFFFF;
					label.text = room.name + "(" + ObjectUtils.getProperties(room.battle.items).length + ")";
					var enterBtn:GButton;
					line.addChild(enterBtn = new GButton());
					enterBtn.text = "enter";
					enterBtn.data = room;
					_roomList.addChild(line);
				}
			}
		}
		
		override protected function doDispose():void {
			super.doDispose();
			
			GameMain.instance.gameChannel.removeEventListener(RpcEvent.DATA, _handleGameChannel);
		}
	}
}
