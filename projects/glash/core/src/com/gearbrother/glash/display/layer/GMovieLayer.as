package com.gearbrother.glash.display.layer {
	import com.gearbrother.glash.display.GMovieClip;
	import com.gearbrother.glash.display.container.GContainer;
	import com.gearbrother.glash.common.oper.ext.GDefinition;


	/**
	 * 游戏中播放动画层
	 *
	 * @author feng.lee
	 * create on 2012-11-7 下午8:55:43
	 */
	public class GMovieLayer extends GContainer {
		private var _queue:Array;

		private var _sleep:Boolean;

		public function set sleep(value:Boolean):void {
			_sleep = value;
		}

		public function GMovieLayer() {
			super();

			layout = new CenterLayout2();
			_queue = [];
		}

		public function queue(definition:GDefinition, playOnce:Boolean = true):void {
			_queue.push([definition, playOnce]);
		}

		private function play(definition:GDefinition, playOnce:Boolean = true):void {
//			var movie:GMovieClip = new GMovieClip(definition, 24);
//			movie.playOnce = playOnce;
//			addChild(movie);
		}

		override protected function doValidateLayout():void {
			super.doValidateLayout();

			if (_queue.length > 0 && numChildren == 0 && !_sleep) {
				var task:Array = _queue.shift();
				play(task[0], task[1]);
			}
		}
	}
}
import com.gearbrother.glash.common.algorithm.GBoxsGrid;
import com.gearbrother.glash.display.container.GContainer;
import com.gearbrother.glash.display.layout.impl.EmptyLayout;

import flash.display.DisplayObject;
import flash.geom.Rectangle;

class CenterLayout2 extends EmptyLayout {
	override public function layoutContainer(target:GContainer):void {
		if (target.numChildren > 0) {
			var rd:Rectangle = new Rectangle(target.x, target.y, target.width, target.height);
			for (var i:int = 0; i < target.numChildren; i++) {
				var c:DisplayObject = target.getChildAt(i) as DisplayObject;
				c.x = rd.width >> 1;
				c.y = rd.height >> 1;
			}
		}
	}
}
