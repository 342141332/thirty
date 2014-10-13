package com.gearbrother.mushroomWar.view.window {
	import com.gearbrother.glash.common.oper.ext.GAliasFile;
	import com.gearbrother.glash.common.oper.ext.GFile;
	import com.gearbrother.glash.display.container.GWindow;
	import com.gearbrother.glash.display.event.GDndEvent;
	import com.gearbrother.glash.display.layer.GWindowLayer;
	import com.gearbrother.mushroomWar.GameMain;
	import com.gearbrother.mushroomWar.model.GameModel;
	import com.gearbrother.mushroomWar.view.common.ui.AvatarUiView;
	
	import flash.display.DisplayObject;


	/**
	 * @author lifeng
	 * @create on 2014-1-10
	 */
	public class TankDialog extends GWindow {
		override public function canBeNeighbour(window:*):Boolean {
			return window is BagDialog;
		}
		
		override public function compareNeighbour(neighbour:*):int {
			return 1;
		}
		
		public var view:AvatarUiView;
		
		override public function set skin(newValue:DisplayObject):void {
			super.skin = newValue;

			view = new AvatarUiView(skin["tankView"]);
			this.dragable = false;
			addEventListener(GDndEvent.Drop, _handleDrop);
		}

		public function TankDialog(container:GWindowLayer) {
			super(container);

			libs = [new GAliasFile("static/asset/skin/bag.swf")];
		}
		
		override protected function _handleLibsSuccess(res:*):void {
			var file:GFile = libsHandler.cachedOper[libs[0]];
			skin = file.getInstance("TankWindowSkin");
		}
		
		private function _handleDrop(event:GDndEvent):void {
			if (view.equipIcons.indexOf(event.target) != -1 && GameModel.instance.loginedUser.bagItems.indexOf(event.data) != -1) {
				/*GameMain.instance.tankService.setWeapon(view.weaponIcons.indexOf(event.target)
					, (event.data as WeaponModel).uuid
					, (data as SoilderModel).uuid
					, function(res:Object):void {
						var weapons:Array = (data as SoilderModel).weapons.concat();
						weapons[view.weaponIcons.indexOf(event.target)] = event.data;
						(data as SoilderModel).weapons = weapons;
						var bagWeapons:Array = GameModel.instance.loginedUser.bagItems.concat();
						bagWeapons[GameModel.instance.loginedUser.bagItems.indexOf(event.data)] = null;
						GameModel.instance.loginedUser.bagItems = bagWeapons;
					});*/
			}
		}
	}
}
