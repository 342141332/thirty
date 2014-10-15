package com.gearbrother.glash.display.control {
	import com.gearbrother.glash.display.GNoScale;
	import com.greensock.TimelineMax;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;


	/**
	 * @author feng.lee
	 * @create on 2013-3-6
	 */
	public class GProgress extends GRange {
		public static const POLICY_LEFT_TO_RIGHT:int = 0;
		
		public static const POLICY_RIGHT_TO_LEFT:int = 1;
		
		private var _policy:int;
		public function set policy(newValue:int):void {
			if (_policy != newValue) {
				_policy = newValue;
				repaint();
			}
		}
		
		public function GProgress(skin:DisplayObject = null) {
			super(skin);
		}
		
		override public function paintNow():void {
			if (_policy == POLICY_LEFT_TO_RIGHT) {
				skin.scrollRect = new Rectangle(0, 0, percent * width, height);
				skin.x = 0;
			} else if (_policy == POLICY_RIGHT_TO_LEFT) {
				skin.scrollRect = new Rectangle((1 - percent) * width, 0, width, height);
				skin.x = (1 - percent) * width;
			}
		}
	}
}
