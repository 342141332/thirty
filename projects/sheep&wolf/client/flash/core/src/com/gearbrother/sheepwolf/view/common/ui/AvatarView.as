package com.gearbrother.sheepwolf.view.common.ui {
	import com.gearbrother.glash.common.oper.ext.GAliasFile;
	import com.gearbrother.glash.common.oper.ext.GBmdDefinition;
	import com.gearbrother.glash.common.oper.ext.GDefinition;
	import com.gearbrother.glash.display.GMovieBitmap;
	import com.gearbrother.glash.display.propertyHandler.GPropertyPoolOperHandler;
	import com.gearbrother.sheepwolf.model.AvatarModel;


	/**
	 *
	 * @author 	Neo.Zhang
	 * @create 	2014-8-19 下午1:55:53
	 *
	 */
	public class AvatarView extends GMovieBitmap {
		public function AvatarView() {
			super();
			
			frameRate = 10;
		}

		override public function handleModelChanged(events:Object = null):void {
			var model:AvatarModel = bindData;
			if (model)
				definition = new GBmdDefinition(new GDefinition(new GAliasFile(model.cartoon), "MoveDown"));
			else
				definition = null;
		}
	}
}
