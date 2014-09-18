package com.gearbrother.monsterHunter.flash.view.mainUI {
	import com.gearbrother.glash.common.resource.type.GAliasFile;
	import com.gearbrother.glash.common.resource.type.GDefinition;
	import com.gearbrother.glash.common.resource.type.GFile;
	import com.gearbrother.glash.display.container.GContainer;
	import com.gearbrother.glash.display.control.GButtonLite;
	import com.gearbrother.glash.display.layout.impl.FlowLayout;
	import com.gearbrother.monsterHunter.flash.GameMain;
	import com.gearbrother.monsterHunter.flash.command.GameCommandMap;
	import com.gearbrother.monsterHunter.flash.event.BagEvent;
	import com.gearbrother.monsterHunter.flash.event.MonsterEvent;
	import com.gearbrother.monsterHunter.flash.skin.mainUI.BagButtonSkin;
	import com.gearbrother.monsterHunter.flash.skin.mainUI.FomatButtonSkin;
	import com.gearbrother.monsterHunter.flash.skin.mainUI.MapButtonSkin;
	import com.gearbrother.monsterHunter.flash.skin.mainUI.MonsterButtonSkin;
	import com.gearbrother.monsterHunter.flash.view.scene.SceneGlobalMapView;
	import com.gearbrother.monsterHunter.flash.view.window.MyBagWindowView;
	import com.gearbrother.monsterHunter.flash.view.window.MyFomatWindowView;
	import com.gearbrother.monsterHunter.flash.view.window.MyMonsterWindowView;
	
	import flash.events.MouseEvent;


	/**
	 * @author feng.lee
	 * create on 2013-1-4 下午2:13:43
	 */
	public class UiMainToolbar extends GContainer {
		static public const BTN_MONSTER:int = 1 << 0;

		static public const BTN_FOMAT:int = 1 << 1;

		static public const BTN_BAG:int = 1 << 2;

		static public const BTN_MAP:int = 1 << 3;

		public function set btns(newValue:Array):void {
			if (newValue.indexOf(BTN_MONSTER) != -1) {
				if (!monsterBtn)
					addChild(monsterBtn = new GButtonLite(new MonsterButtonSkin()));
			} else {
				if (monsterBtn) {
					removeChild(monsterBtn);
					monsterBtn = null;
				}
			}
			if (newValue.indexOf(BTN_FOMAT) != -1) {
				if (!fomatBtn)
					addChild(fomatBtn = new GButtonLite(new FomatButtonSkin()));
			} else {
				if (fomatBtn) {
					removeChild(fomatBtn);
					fomatBtn = null;
				}
			}
			if (newValue.indexOf(BTN_BAG) != -1) {
				if (!bagBtn)
					addChild(bagBtn = new GButtonLite(new BagButtonSkin()));
			} else {
				if (bagBtn) {
					removeChild(bagBtn);
					bagBtn = null;
				}
			}
			if (newValue.indexOf(BTN_MAP) != -1) {
				if (!mapBtn)
					addChild(mapBtn = new GButtonLite(new MapButtonSkin()));
			} else {
				if (mapBtn) {
					removeChild(mapBtn);
					mapBtn = null;
				}
			}
		}

		public var monsterBtn:GButtonLite;

		public var fomatBtn:GButtonLite;

		public var bagBtn:GButtonLite;

		public var mapBtn:GButtonLite;

		public function UiMainToolbar() {
			super();

			layout = new FlowLayout();

			addEventListener(MouseEvent.CLICK, _handleMouseEvent);
		}

		private function _handleMouseEvent(event:MouseEvent):void {
			switch (event.target) {
				case monsterBtn:
					GameCommandMap.instance._eventDispatcher.dispatchEvent(new MonsterEvent(MonsterEvent.SHOW));
					break;
				case fomatBtn:
					GameCommandMap.instance._eventDispatcher.dispatchEvent(new MonsterEvent(MonsterEvent.GET_FOMAT));
					break;
				case bagBtn:
					GameCommandMap.instance._eventDispatcher.dispatchEvent(new BagEvent(BagEvent.GET));
					break;
				case mapBtn:
					GameMain.instance.sceneLayer.scene = new SceneGlobalMapView();
					break;
			}
		}
	}
}
