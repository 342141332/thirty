package com.gearbrother.sheepwolf.view.layer.scene {
	import com.gearbrother.glash.display.container.GContainer;
	import com.gearbrother.glash.display.container.GHBox;
	import com.gearbrother.glash.display.control.GButton;
	import com.gearbrother.glash.display.control.text.GTextInput;
	import com.gearbrother.glash.display.layout.impl.CenterLayout;
	import com.gearbrother.sheepwolf.GameMain;
	import com.gearbrother.sheepwolf.model.GameModel;
	import com.gearbrother.sheepwolf.model.HallModel;
	
	import flash.events.MouseEvent;


	/**
	 * @author lifeng
	 * @create on 2013-12-8
	 */
	public class LoginSceneView extends GContainer {
		private var nameLabel:GTextInput;
		private var enterBtn:GButton;
		public function LoginSceneView() {
			super();
			
			layout = new CenterLayout();
			var hbox:GHBox = new GHBox();
			hbox.addChild(nameLabel = new GTextInput());
			nameLabel.width = 100;
			nameLabel.height = 30;
			nameLabel.text = "neo";
			hbox.addChild(enterBtn = new GButton());
			enterBtn.text = "go";
			addEventListener(MouseEvent.CLICK, _handleClick);
			addChild(hbox);
		}
		
		private function _handleClick(event:MouseEvent):void {
			switch (event.target) {
				case enterBtn:
					GameMain.instance.userService.login(nameLabel.text
						, function (res:*):void {
							GameModel.instance.loginedUser = res;
//							GameMain.instance.scenelayer.addChild(new ModeSelectSceneView());
							GameMain.instance.roomService.enterHall(
								function (res:*):void {
									GameMain.instance.scenelayer.addChild(new HallSceneView(res as HallModel));
								}
							);
						}
					);
					break;
			}
		}
	}
}
