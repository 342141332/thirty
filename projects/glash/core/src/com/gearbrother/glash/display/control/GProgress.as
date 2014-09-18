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
		public function GProgress(skin:DisplayObject = null) {
			super(skin);
		}
		
		override public function paintNow():void {
			var timeline:TimelineMax = new TimelineMax();
			timeline.append(TweenMax.to(skin, .3, {colorTransform: {brightness: 1.2}}));
			timeline.append(TweenMax.to(skin, .4, {colorTransform: {brightness: 1}}));
			scrollRect = new Rectangle(0, 0, skin.width * percent, skin.height);
		}
	}
}
