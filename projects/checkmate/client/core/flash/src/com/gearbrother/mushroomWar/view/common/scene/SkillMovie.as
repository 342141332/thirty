package com.gearbrother.mushroomWar.view.common.scene {
	import com.gearbrother.glash.display.GMovieBitmap;
	import com.gearbrother.glash.display.flixel.GPaper;
	import com.gearbrother.glash.display.flixel.GPaperLayer;
	
	import flash.display.BitmapData;


	/**
	 * @author lifeng
	 * @create on 2014-6-4
	 */
	public class SkillMovie extends GMovieBitmap {
		public function SkillMovie(frameRate:Number = NaN, bitmapData:BitmapData = null, pixelSnapping:String = "auto", smoonthing:Boolean = false) {
			super(frameRate, bitmapData, pixelSnapping, smoonthing);
		}
		
		override public function remove():void {
			if (parent is GPaperLayer)
				(parent as GPaperLayer).removeObject(this);
			else
				super.remove();
		}
	}
}
