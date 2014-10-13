package {
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	import com.gearbrother.glash.manager.RootManager;
	import com.gearbrother.glash.oper.display.cache.BmdCacheOper;


	/**
	 * @author feng.lee
	 * 创建时间：2012-5-7 上午11:03:29
	 */
	public class PakEncoderTest extends Sprite {
		[Embed(source = "5.swf", symbol = "Character")]
		public var clazz:Class;

		private var __render:BmdCacheOper;

		public function PakEncoderTest() {
			super();
			
			RootManager.register(this);
			
			__render = new BmdCacheOper(new clazz() as MovieClip);
		}

	}
}