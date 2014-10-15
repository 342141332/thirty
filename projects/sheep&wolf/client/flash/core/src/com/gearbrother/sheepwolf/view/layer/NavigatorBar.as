package com.gearbrother.sheepwolf.view.layer {
	import com.gearbrother.glash.common.geom.GDimension;
	import com.gearbrother.glash.display.container.GContainer;
	import com.gearbrother.glash.display.control.text.GText;
	import com.gearbrother.glash.display.layout.impl.BorderLayout;
	import com.gearbrother.glash.display.layout.impl.FlowLayout;
	import com.gearbrother.sheepwolf.GameMain;
	import com.gearbrother.sheepwolf.model.GameModel;
	import com.gearbrother.sheepwolf.view.window.BagDialog;
	import com.gearbrother.sheepwolf.view.window.TankDialog;
	
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;

	/**
	 * @author lifeng
	 * @create on 2013-11-26
	 */
	public class NavigatorBar extends GContainer {
		static private const instance:NavigatorBar = new NavigatorBar();
		static public function show():NavigatorBar {
			if (!instance.parent) {
				GameMain.instance.uilayer.bottom.append(instance, BorderLayout.CENTER);
			}
			return instance;
		}
		static public function hide():NavigatorBar {
			if (instance.parent)
				instance.parent.removeChild(instance);
			return instance;
		}
		
		private var _leftPane:GContainer;

		private var _rightPane:GContainer;

		private var _publicChat:GText;

		private var _teamChat:GText;

		private var _personalChat:GText;

		private var _nameLabel:GText;

		private var _avatarBtn:GText;

		private var _bagBtn:GText;

		private var _shopBtn:GText;

		private var _configBtn:GText;

		private var _timeLabel:GText;
		
		override public function get preferredSize():GDimension {
			return super.preferredSize;
		}

		public function NavigatorBar() {
			super();

			height = 30;
			layout = new BorderLayout();

			append(_leftPane = new GContainer(), BorderLayout.WEST);
			_leftPane.layout = new FlowLayout(0, 0);
			_leftPane.addChild(_publicChat = new TextButton("Public"));
			_leftPane.addChild(_teamChat = new TextButton("Team"));
			_leftPane.addChild(_personalChat = new TextButton("Personal"));

			append(_rightPane = new GContainer(), BorderLayout.EAST);
			_rightPane.layout = new FlowLayout(0, 0);
			_rightPane.addChild(_nameLabel = new TextButton(GameModel.instance.loginedUser.name));
			_rightPane.addChild(new TextButton("|"));
			_rightPane.addChild(_avatarBtn = new TextButton("Tank"));
			_rightPane.addChild(new TextButton("|"));
			_rightPane.addChild(_bagBtn = new TextButton("Bag"));
			_rightPane.addChild(new TextButton("|"));
			_rightPane.addChild(_shopBtn = new TextButton("Shop"));
			_rightPane.addChild(new TextButton("|"));
			_rightPane.addChild(_configBtn = new TextButton("Config"));
			_rightPane.addChild(new TextButton("|"));
			_rightPane.addChild(_timeLabel = new TextButton("19:01"));
			addEventListener(MouseEvent.CLICK, _handleMouseClick);
		}

		private function _handleMouseClick(event:MouseEvent):void {
			switch (event.target) {
				case _publicChat:
					break;
				case _teamChat:
					break;
				case _personalChat:
					break;
				case _avatarBtn:
					new TankDialog(GameMain.instance.windowLayer).open();
					break;
				case _bagBtn:
					new BagDialog(GameMain.instance.windowLayer).open();
					break;
			}
		}
	}
}
