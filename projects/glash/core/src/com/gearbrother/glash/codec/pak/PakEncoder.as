package com.gearbrother.glash.codec.pak {
	import com.adobe.images.JPGEncoder;
	import com.adobe.images.PNGEncoder;
	
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.FrameLabel;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**
	 * TODO
	 * 检索相同图片 使用同一BMD来减低内存与文件大小 
	 * @author yi.zhang
	 * 
	 */	
	public class PakEncoder extends EventDispatcher {
		public static const BITMAP_MAX_WIDTH:int = 8191;
		public static const BITMAP_MAX_HEIGHT:int = 8191;
		
		public var rgbBmb:BitmapData;
		
		public var alphaBmd:BitmapData;
		
		public function PakEncoder() {}

		public function encode(bmds:Array
							, regPoints:Array
							, labels:Array = null
							, quality:int = 50, alphaQuality:int = 50, alphaFilter:int = 50):ByteArray {
			var bytes:ByteArray = new ByteArray();
			
			var header:PakHeader = new PakHeader();
			header.quality = quality;
			header.alphaQuality = alphaQuality;
			header.alphaFilter = alphaFilter;
			header.labels = labels;
			header.regPoints = regPoints;

			var rowMaxHeight:int = 0;
			var rowMaxWidth:int = 0;
			var pixelRects:Array = [];
			
			//list bmp to grid, to avoid over the BitmapData's max width or height
			var from:Point = new Point;
			for (var i:int = 0; i < bmds.length; i++) {
				var checkBitmap:BitmapData = bmds[i].clone();
				checkBitmap.threshold(checkBitmap, checkBitmap.rect, new Point(), ">", 0, 0xFFFFFFFF, 0xFFFFFFFF);
				var pixelRect:Rectangle = checkBitmap.getColorBoundsRect(0xFFFFFFFF, 0xFFFFFFFF, true);
				//adjust reg point
				(regPoints[i] as Point).offset(-pixelRect.x, -pixelRect.y);
				pixelRects.push(pixelRect);
				checkBitmap.dispose();
				
				if ((from.x + pixelRect.width) > BITMAP_MAX_WIDTH) {
					from.x = 0;
					from.y += rowMaxHeight;
					rowMaxHeight = 0;
				}
				from.x += pixelRect.width;
				rowMaxWidth = Math.max(from.x, rowMaxWidth);
				rowMaxHeight = Math.max(rowMaxHeight, pixelRect.height);
			}

			rgbBmb = new BitmapData(rowMaxWidth, from.y + rowMaxHeight, true, 0);
			var x:int;
			var y:int;
			for (var j:int = 0; j < bmds.length; j++) {
				var realRect:Rectangle = pixelRects[j];
				header.cutRects.push(new Rectangle(x, y, realRect.width, realRect.height));
				rgbBmb.copyPixels(bmds[j], realRect, new Point(x, y));
				x += realRect.width;
				if (x > BITMAP_MAX_WIDTH) {
					x = 0;
					y + rowMaxHeight;
				}
			}
			
			var headBytes:ByteArray = new ByteArray;
			headBytes.writeObject(header.toObject());
			bytes.writeUnsignedInt(headBytes.length);
			bytes.writeBytes(headBytes);

			if (quality == alphaQuality) {
				alphaBmd = new BitmapData(rgbBmb.width, rgbBmb.height * 2, false, 0);
				alphaBmd.copyPixels(rgbBmb, rgbBmb.rect, new Point());
				alphaBmd.copyChannel(rgbBmb, rgbBmb.rect, new Point(0, rgbBmb.height), BitmapDataChannel.ALPHA, BitmapDataChannel.RED);
				alphaBmd.copyChannel(rgbBmb, rgbBmb.rect, new Point(0, rgbBmb.height), BitmapDataChannel.ALPHA, BitmapDataChannel.GREEN);
				alphaBmd.copyChannel(rgbBmb, rgbBmb.rect, new Point(0, rgbBmb.height), BitmapDataChannel.ALPHA, BitmapDataChannel.BLUE);

				var conData:ByteArray = quality == 100 ? PNGEncoder.encode(alphaBmd) : new JPGEncoder(quality).encode(alphaBmd);
				bytes.writeUnsignedInt(conData.length);
				bytes.writeBytes(conData);
			} else {
				var data:ByteArray = quality == 100 ? PNGEncoder.encode(rgbBmb) : new JPGEncoder(quality).encode(rgbBmb);
				bytes.writeUnsignedInt(data.length);
				bytes.writeBytes(data);

				if (alphaQuality) {
					var alphaBmd:BitmapData = new BitmapData(rgbBmb.width, rgbBmb.height, false, 0);
					alphaBmd.copyChannel(rgbBmb, rgbBmb.rect, new Point(), BitmapDataChannel.ALPHA, BitmapDataChannel.RED);
					alphaBmd.copyChannel(rgbBmb, rgbBmb.rect, new Point(), BitmapDataChannel.ALPHA, BitmapDataChannel.GREEN);
					alphaBmd.copyChannel(rgbBmb, rgbBmb.rect, new Point(), BitmapDataChannel.ALPHA, BitmapDataChannel.BLUE);
					var alphaData:ByteArray = alphaQuality == 100 ? PNGEncoder.encode(alphaBmd) : new JPGEncoder(alphaQuality).encode(alphaBmd);
					alphaBmd.dispose();

					bytes.writeUnsignedInt(alphaData.length);
					bytes.writeBytes(alphaData);
				} else {
					bytes.writeUnsignedInt(0);
				}
			}

//			if (alphaBmd)
//				alphaBmd.dispose();
//			newBmb.dispose();
			bytes.compress();
			return bytes;
		}
	}
}