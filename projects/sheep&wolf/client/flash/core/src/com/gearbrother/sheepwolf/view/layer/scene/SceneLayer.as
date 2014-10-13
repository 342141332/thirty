package com.gearbrother.sheepwolf.view.layer.scene {
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.container.GContainer;
	import com.gearbrother.glash.display.control.GButton;
	import com.gearbrother.glash.display.layout.impl.FillLayout;
	
	import flash.display.DisplayObject;


	/**
	 * @author lifeng
	 * @create on 2013-11-27
	 */
	public class SceneLayer extends GContainer {
		public function SceneLayer() {
			super();

			layout = new FillLayout();
		}

		override public function addChild(child:DisplayObject):DisplayObject {
			removeAllChildren();

			super.addChild(child);
			if (child is IScene)
				(child as IScene).active();
			return child;
		}
	}
}
