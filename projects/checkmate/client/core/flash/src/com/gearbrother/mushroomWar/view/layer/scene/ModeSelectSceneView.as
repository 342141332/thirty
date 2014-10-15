package com.gearbrother.mushroomWar.view.layer.scene {
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.control.GButton;
	import com.gearbrother.glash.display.layout.impl.BorderLayout;
	import com.gearbrother.mushroomWar.GameMain;
	import com.gearbrother.mushroomWar.model.HallModel;
	import com.gearbrother.mushroomWar.view.layer.NavigatorBar;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;


	/**
	 * @author lifeng
	 * @create on 2013-11-27
	 */
	public class ModeSelectSceneView extends GNoScale implements IScene {
		private var _storyModeBtn:GButton;
		
		private var _competeModeBtn:GButton;

		public function ModeSelectSceneView(skin:DisplayObject = null) {
			super(skin);

			addChild(_storyModeBtn = new GButton());
			_storyModeBtn.text = "Story";
			addChild(_competeModeBtn = new GButton());
			_competeModeBtn.text = "compete";
			addEventListener(MouseEvent.CLICK, _handleMouseEvent);
		}
		
		public function active():void {
			NavigatorBar.show();
		}
		
		private function _handleMouseEvent(event:MouseEvent):void {
			switch (event.target) {
				case _storyModeBtn:
					break;
				case _competeModeBtn:
					GameMain.instance.roomService.enterHall(function (res:*):void {
						GameMain.instance.scenelayer.addChild(new HallSceneView(res as HallModel));
					});
					break;
			}
		}
		
		override protected function doValidateLayout():void {
			super.doValidateLayout();
			
			_storyModeBtn.x = ((width >> 1) - _storyModeBtn.width) >> 1;
			_storyModeBtn.y = (height - _storyModeBtn.height) >> 1;
			_competeModeBtn.x = (width >> 1) + (((width >> 1) - _competeModeBtn.width) >> 1);
			_competeModeBtn.y = (height - _storyModeBtn.height) >> 1;
		}
	}
}
