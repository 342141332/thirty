package {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import com.gearbrother.glash.GMain;
	import com.gearbrother.glash.display.control.GScale9Bitmap;
	import com.gearbrother.glash.display.layout.impl.FillLayout;


	/**
	 * @author feng.lee
	 * create on 2012-10-8 下午9:36:13
	 */
	[SWF(widthPercent="100", heightPercent="100")]
	public class GDisplayScale9BitmapCase extends GMain {
		[Embed(source = "war/bg_download_client.png")]
		public var clazz:Class;

		public var bmp:GScale9Bitmap;

		public function GDisplayScale9BitmapCase() {
			super();
		}

		override protected function doInit():void {
			super.doInit();

			var source:BitmapData = new BitmapData(650, 73, false, 0x000000);
			source.draw((new clazz() as Bitmap).bitmapData, new Matrix(1, 0, 0, 1, -11, -11));
			bmp = new GScale9Bitmap(source);
			bmp.scale9Grid = new Rectangle(130, 30, 420, 30);
			bmp.isTileGrid9 = false;
			rootLayer.layout = new FillLayout();
			rootLayer.addChild(bmp);
		}
	}
}
