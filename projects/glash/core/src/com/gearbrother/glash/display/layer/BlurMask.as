package  com.gearbrother.glash.display.layer {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class BlurMask extends Sprite {
		private var __bmp:Bitmap;

		public function BlurMask() {
			addEventListener(Event.ADDED_TO_STAGE, __onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, __onRemoveFromStage);
		}

		private function __onAddedToStage(e:Event):void {
			var bmp:BitmapData = new BitmapData(stage.stageWidth, stage.stageHeight, false, 0x000000);
//			bmp.draw(stage);
//			bmp.applyFilter(bmp, new Rectangle(0, 0, bmp.width, bmp.height), new Point(), new BlurFilter(4, 4, 4));
			__bmp = new Bitmap(bmp);
			addChild(__bmp);
		}

		private function __onRemoveFromStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, __onAddedToStage);
			removeEventListener(Event.REMOVED_FROM_STAGE, __onRemoveFromStage);
			
			removeChild(__bmp);
			__bmp.bitmapData.dispose();
		}
	}
}
