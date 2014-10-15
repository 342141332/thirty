package {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.FrameLabel;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import com.gearbrother.glash.GMain;
	import com.gearbrother.glash.display.GMovieBitmap;
	import com.gearbrother.glash.display.paper.display.item.GPaperMovieBitmap;


	/**
	 * @author feng.lee
	 * create on 2012-10-15 下午6:57:26
	 */
	[SWF(width = "1200", height = "700", frameRate = "60")]
	public class GDisplayMovieBmpSimpleCase extends GMain {
		[Embed(source = "../asset/avatar/walk.png")]
		public var clazz:Class;

		public function GDisplayMovieBmpSimpleCase() {
			super();
		}

		override protected function doInit():void {
			super.doInit();

			var bmp:Bitmap = new clazz() as Bitmap;
			var bmds:Array = separateBitmapData(bmp.bitmapData, 67, 91);
			var labels:Array = [];
			for (var i:int = 0; i < 8; i++) {
				labels.push(new FrameLabel(String(i), i * 8));
			}
			
			for (var j:int = 1; j < 31; j++) {
				for (var k:int = 1; k < 31; k++) {
					var movie:GMovieBitmap = new GPaperMovieBitmap(bmds, null, 10);
					movie.x = j * 30;
					movie.y = k * 20;
					stage.addChild(movie);
				}
			}
		}

		static public function separateBitmapData(source:BitmapData, width:int, height:int, toBitmap:Boolean = false):Array {
			var result:Array = [];
			for (var j:int = 0; j < Math.round(source.height / height); j++) {
				for (var i:int = 0; i < Math.round(source.width / width); i++) {
					var bitmap:BitmapData = new BitmapData(width, height, true, 0);
					bitmap.copyPixels(source, new Rectangle(i * width, j * height, width, height), new Point());
					if (toBitmap) {
						var bp:Bitmap = new Bitmap(bitmap);
						bp.x = i * width;
						bp.y = j * height;
						result.push(bp);
					} else
						result.push(bitmap)
				}
			}
			return result;
		}
	}
}
