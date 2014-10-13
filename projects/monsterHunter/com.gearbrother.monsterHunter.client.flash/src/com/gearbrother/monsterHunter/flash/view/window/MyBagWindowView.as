package com.gearbrother.monsterHunter.flash.view.window {
	import com.gearbrother.glash.display.container.GContainer;
	import com.gearbrother.glash.display.container.GRepeater;
	import com.gearbrother.glash.display.control.GVScrollBar;
	import com.gearbrother.glash.mvc.model.GBeanPropertyEvent;
	import com.gearbrother.monsterHunter.flash.model.GameModel;
	import com.gearbrother.monsterHunter.flash.model.HunterModel;
	import com.gearbrother.monsterHunter.flash.skin.window.MyBagWindowSkin;
	import com.gearbrother.monsterHunter.flash.view.common.BagItemView;
	import com.gearbrother.monsterHunter.flash.view.common.WindowView;
	
	import flash.display.DisplayObject;


	/**
	 * @author feng.lee
	 * create on 2013-2-21
	 */
	public class MyBagWindowView extends WindowView {
		public var scrollPane:GRepeater;

		public function MyBagWindowView() {
			var skin:MyBagWindowSkin = new MyBagWindowSkin();
			super(skin);

			_neighbourWindowClazz = [MyMonsterWindowView, MyBagWindowView];
			scrollPane = new GRepeater(BagItemView, 6);
			scrollPane.width = skin.list.width;
			scrollPane.height = skin.list.height;
			scrollPane.x = skin.list.x;
			scrollPane.y = skin.list.y;
			addChild(scrollPane);
			var scrollBar:GVScrollBar = new GVScrollBar(skin.vScrollBar);
			scrollBar.height = skin.list.height;
			scrollBar.scrollTarget = scrollPane;
			data = GameModel.instance.loginedUser;
		}

		override public function handleModelChanged(events:Object = null):void {
			if (!events || events.hasOwnProperty(HunterModel.BAG_ITEMS)) {
				scrollPane.data = GameModel.instance.loginedUser.bagItems;
			}
		}
	}
}
