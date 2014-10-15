package com.gearbrother.mushroomWar.view.layer.scene.battle {
	import com.gearbrother.glash.common.oper.GOper;
	import com.gearbrother.glash.common.oper.ext.GAliasFile;
	import com.gearbrother.glash.common.oper.ext.GBmdDefinition;
	import com.gearbrother.glash.common.oper.ext.GDefinition;
	import com.gearbrother.glash.common.oper.ext.GFile;
	import com.gearbrother.glash.display.GBmdMovieInfo;
	import com.gearbrother.glash.display.GMovieBitmap;
	import com.gearbrother.glash.display.GSprite;
	import com.gearbrother.glash.display.event.GDisplayEvent;
	import com.gearbrother.glash.display.propertyHandler.GPropertyPoolOperHandler;
	import com.gearbrother.mushroomWar.model.SkillModel;
	
	import flash.events.Event;


	/**
	 *
	 * @author 	Neo.Zhang
	 * @create 	2014-9-17 下午8:05:25
	 *
	 */
	public class SkillSceneView extends GMovieBitmap {
		private var _libsHandler:GPropertyPoolOperHandler;
		public function get libsHandler():GPropertyPoolOperHandler {
			return _libsHandler;
		}
		public function get libs():Array {
			return _libsHandler ? _libsHandler.value : null;
		}
		public function set libs(newValue:Array):void {
			_libsHandler ||= new GPropertyPoolOperHandler(null, this);
			_libsHandler.succHandler = _handleLibsSuccess;
			_libsHandler.value = newValue;
		}
		protected function _handleLibsSuccess(res:*):void {
			var file:GOper = _libsHandler.cachedOper[libs[0]];
			var result:GBmdMovieInfo = file.result;
			bitmapOffsets = result.offsets;
			bitmapDatas = result.bmds;
			setLabel(null, 1);
			frameRate = 7;
			addEventListener(GDisplayEvent.LABEL_QUEUE_END, _handleMovieEvent);
		}
		private function _handleMovieEvent(event:Event):void {
			remove();
		}
		
		public function SkillSceneView(model:SkillModel) {
			super();
			
			libs = [new GBmdDefinition(new GDefinition(new GAliasFile("static/asset/skill/11.swf"), "Main"))];
		}
	}
}
