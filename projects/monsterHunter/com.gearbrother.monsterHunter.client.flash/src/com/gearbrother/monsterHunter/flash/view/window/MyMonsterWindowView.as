package com.gearbrother.monsterHunter.flash.view.window {
	import com.gearbrother.glash.display.container.GRepeater;
	import com.gearbrother.glash.display.control.GButtonLite;
	import com.gearbrother.glash.display.control.GVScrollBar;
	import com.gearbrother.monsterHunter.flash.model.GameModel;
	import com.gearbrother.monsterHunter.flash.model.HunterModel;
	import com.gearbrother.monsterHunter.flash.skin.window.MyMonsterWindowSkin;
	import com.gearbrother.monsterHunter.flash.view.common.MonsterInfoView;
	import com.gearbrother.monsterHunter.flash.view.common.WindowView;


	/**
	 * @author feng.lee
	 * create on 2013-1-4 下午5:37:30
	 */
	public class MyMonsterWindowView extends WindowView {
		public var repeater:GRepeater;
		
		public var expandBtn:GButtonLite;
		
		public function MyMonsterWindowView() {
			var skin:MyMonsterWindowSkin = new MyMonsterWindowSkin();
			super(skin);

			_neighbourWindowClazz = [MyMonsterWindowView, MyFomatWindowView, MyBagWindowView];
			repeater = new GRepeater(MonsterInfoView, 1);
			repeater.width = skin.list.width;
			repeater.height = skin.list.height;
			repeater.x = skin.list.x;
			repeater.y = skin.list.y;
			addChild(repeater);
			var scrollBar:GVScrollBar = new GVScrollBar(skin.vScrollBar);
			scrollBar.height = skin.list.height;
			scrollBar.scrollTarget = repeater;
			
			expandBtn = new GButtonLite(skin.expandBtn);
			data = GameModel.instance.loginedUser;
		}

		override public function compareNeighbour(neighbour:*):int {
			if (neighbour is MyFomatWindowView)
				return 1;
			else
				return -1;
		}
		
		override public function handleModelChanged(events:Object = null):void {
			if (!events || events.hasOwnProperty(HunterModel.MONSTERS)) {
				repeater.data = GameModel.instance.loginedUser.monsters;
			}
		}
	}
}
