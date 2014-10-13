package com.gearbrother.glash.display.flixel {
	import com.gearbrother.glash.util.camera.Camera;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Point;



	/**
	 * @author feng.lee
	 * create on 2012-9-5 下午3:39:27
	 */
	public class GPaperFogLayer extends GPaperLayer {
		public var maskBmd:BitmapData;
		
		public var maskShape:DisplayObject;

		public var bmd:BitmapData;

		public function GPaperFogLayer(camera:Camera, width:int, height:int, maskBmd:BitmapData, color:uint = 0xFF000000) {
			super(camera);
			
			var shape:Shape = new Shape;
			shape.graphics.beginBitmapFill(maskBmd);
			shape.graphics.drawRect(0, 0, maskBmd.width, maskBmd.height);
			shape.graphics.endFill();
			maskShape = shape;
			this.maskBmd = maskBmd;

			bmd = new BitmapData(width, height, true, color);
			var fog:Bitmap = new Bitmap(bmd);
			addChild(fog);
			mouseEnabled = mouseChildren = false;
		}

		public function clear(dest:Point):void {
			dest.x -= maskShape.width >> 1;
			dest.y -= maskShape.height >> 1;
			var matrix:Matrix = new Matrix(1, 0, 0, 1, dest.x, dest.y);
			bmd.draw(maskShape, matrix, null, BlendMode.ERASE);
//			bmd.threshold(maskBmd, new Rectangle(0, 0, maskBmd.width, maskBmd.height), dest, "==", 0xFF000000, 0x00000000, 0xFFFFFFFF, true);
		}

		override protected function doDispose():void {
			if (bmd)
				bmd.dispose();
			
			super.doDispose();
		}
	}
}