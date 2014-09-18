package com.gearbrother.glash.display.control {
	import com.gearbrother.glash.display.GSkinSprite;
	import com.greensock.TweenLite;
	import com.greensock.plugins.FrameLabelPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.DisplayObject;
	import flash.text.TextField;
	

	/**
	 * 百分比条
	 * 
	 * @author feng.lee
	 * create on 2012-8-20 下午11:49:01
	 */
	public class GPercentBar extends GRange {
		{
			TweenPlugin.activate([FrameLabelPlugin]);
		}

		static public const MODE_MOVIECLIP:int = 1 << 0;
		static public const MODE_SCALE_X:int = 1 << 1;
		static public const MODE_SCALE_Y:int = 1 << 2;
		static public const MODE_X:int = 1 << 3;
		static public const MODE_Y:int = 1 << 4;
		
		public var label:TextField;
		
		public var duration:Number;
		
		public var thumb:DisplayObject;
		
		private var _mode:int;

		public function GPercentBar(skin:DisplayObject) {
			super(skin);
			
			thumb = skin["thumb"];
			label = skin["label"];
		}
		
		override protected function doValidateLayout():void {
			var percent:Number = (maxValue - value) / (value - minValue);
			percent = Math.min(1, Math.max(percent, 0));
			TweenLite.killTweensOf(thumb);
			switch (_mode) {
				case MODE_MOVIECLIP:
					TweenLite.to(thumb, duration, {frame: int(percent * 100)});
					break;
				case MODE_SCALE_X:
					TweenLite.to(thumb, duration, {scaleX: int(percent * 100)});
					break;
				case MODE_SCALE_Y:
					TweenLite.to(thumb, duration, {scaleY: int(percent * 100)});
					break;
				case MODE_X:
					break;
				case MODE_Y:
					break;
			}
		}
	}
}
