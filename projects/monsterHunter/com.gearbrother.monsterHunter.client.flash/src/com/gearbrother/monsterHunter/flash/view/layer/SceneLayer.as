package com.gearbrother.monsterHunter.flash.view.layer {
	import com.gearbrother.glash.display.container.GContainer;
	import com.gearbrother.glash.display.layout.impl.FillLayout;
	import com.gearbrother.monsterHunter.flash.view.scene.SceneView;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;


	/**
	 * @author 		lifeng
	 * @version 	1.0.0
	 * create on	2012-12-7 下午11:18:15
	 */
	public class SceneLayer extends GContainer {
		private var _scene:DisplayObject;
		public function set scene(newValue:DisplayObject):void {
			if (_scene)
				removeChild(_scene);
			addChildAt(_scene = newValue, 0);
		}

		public function SceneLayer() {
			super();

			layout = new FillLayout();
		}
		
		override protected function doInit():void {
			super.doInit();
			
			stage.addEventListener(MouseEvent.CLICK, _handleClick);
		}
		
		private function _handleClick(event:MouseEvent):void {
			
		}
	}
}
