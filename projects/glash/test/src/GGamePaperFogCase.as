package {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import com.gearbrother.glash.GMain;
	import com.gearbrother.glash.display.GSprite;
	import com.gearbrother.glash.display.flixel.GPaper;
	import com.gearbrother.glash.display.flixel.display.layer.GPaperFogLayer;


	/**
	 * @author feng.lee
	 * create on 2012-9-5 下午11:59:56
	 */
	[SWF(width = "1000", height = "500")]
	public class GGamePaperFogCase extends GMain {
		[Embed(source = "fog.png")]
		public var clazz:Class;

		public var layer:GPaperFogLayer;

		public function GGamePaperFogCase() {
			super();
		}
		
		override protected function doInit():void {
			super.doInit();
			
			var paper:GPaper = new GPaper();
			layer = new GPaperFogLayer(paper, 2000, 500, (new clazz() as Bitmap).bitmapData);
			paper.addChild(layer);
			addChild(paper);
			enableTick = true;
		}

		override public function tick(interval:int):void {
			layer.clear(new Point(stage.mouseX, stage.mouseY));

			super.tick(interval);
		}
	}
}
