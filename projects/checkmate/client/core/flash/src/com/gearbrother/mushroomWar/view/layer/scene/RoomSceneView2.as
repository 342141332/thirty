package com.gearbrother.mushroomWar.view.layer.scene {
	import com.gearbrother.glash.display.container.GContainer;
	import com.gearbrother.glash.display.layout.impl.BorderLayout;
	import com.gearbrother.glash.display.layout.impl.CenterLayout;
	import com.gearbrother.mushroomWar.model.BattleRoomModel;
	import com.gearbrother.mushroomWar.view.layer.NavigatorBar;


	/**
	 *
	 * @author 	Neo.Zhang
	 * @create 	2014-8-14 下午7:39:24
	 *
	 */
	public class RoomSceneView2 extends GContainer implements IScene {
		public function RoomSceneView2(model:BattleRoomModel) {
			super();
			
			layout = new CenterLayout();
			append(new RoomSceneView(model));
		}		

		public function active():void {
			NavigatorBar.show();
		}
	}
}
