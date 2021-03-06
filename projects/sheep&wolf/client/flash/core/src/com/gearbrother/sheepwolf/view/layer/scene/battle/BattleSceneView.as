package com.gearbrother.sheepwolf.view.layer.scene.battle {
	import com.gearbrother.glash.display.container.GContainer;
	import com.gearbrother.glash.display.layout.impl.BorderLayout;
	import com.gearbrother.glash.display.layout.impl.FillLayout;
	import com.gearbrother.sheepwolf.GameMain;
	import com.gearbrother.sheepwolf.model.BattleModel;
	import com.gearbrother.sheepwolf.model.SkillModel;
	import com.gearbrother.sheepwolf.view.layer.scene.IScene;


	/**
	 * @author lifeng
	 * @create on 2014-2-27
	 */
	public class BattleSceneView extends GContainer implements IScene {
		public var battleSceneViewInner:BattleSceneViewCanvas;

		public var bottomUi:BattleSceneViewUi;

		public function BattleSceneView(battle:BattleModel) {
			super();

			layout = new FillLayout()
			addChild(battleSceneViewInner = new BattleSceneViewCanvas(battle));
			addChild(new BattleSceneViewUi(battle));
		}
		
		public function active():void {
			//initialize ui layer
			
		}
	}
}
