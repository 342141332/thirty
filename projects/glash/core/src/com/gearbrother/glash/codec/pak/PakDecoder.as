package com.gearbrother.glash.codec.pak {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.FrameLabel;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import org.as3commons.lang.IDisposable;
	import com.gearbrother.glash.display.GBitmapFrame;
	import flash.geom.Point;
	import flash.geom.Rectangle;


	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * 
	 * @author feng.lee
	 * 
	 */	
	public class PakDecoder extends EventDispatcher implements IDisposable {
		public var result:Vector.<BitmapData>;
		public function get frames():Vector.<GBitmapFrame> {
			var frames:Vector.<GBitmapFrame> = new <GBitmapFrame>[];
			for (var i:int = 0; i < result.length; i++) {
				var res:BitmapData = result[i];
				var regPoint:Point = __header.regPoints[i];
				var frame:GBitmapFrame = new GBitmapFrame;
				frame.bmd = res;
				frame.label;
				frame.regPoint = regPoint;
				frames.push(frame);
			}
			return frames;
		}

		private var __isReadCompleted:Boolean;
		public function get readComplete():Boolean {
			return __isReadCompleted;
		}
		public var quality:int;
		public var alphaQuality:int;
		public var alphaFilter:int;

		private var __header:PakHeader;
		public function get header():PakHeader {
			return __header;
		}
		private var __loadList:Array;
		private var __bmds:Array;

		public function PakDecoder() {}

		public function decode(bytes:ByteArray):void {
			var allData:ByteArray = new ByteArray();

			bytes.position = 0;
			bytes.readBytes(allData, 0, bytes.length);
			allData.position = 0;
			allData.uncompress();

			var headLength:uint = allData.readUnsignedInt();
			var headBytes:ByteArray = new ByteArray;
			allData.readBytes(headBytes, 0, headLength);
			__header = new PakHeader(headBytes.readObject());
			quality = __header.quality;
			alphaQuality = __header.alphaQuality;
			alphaFilter = __header.alphaFilter;

			__bmds = [];
			__loadList = [];

			/*offests = [];
			sizes = [];
			for (var i:int = 0; i < length; i++) {
				var offX:int = allData.readShort();
				var offY:int = allData.readShort();
				var w:int = allData.readShort();
				var h:int = allData.readShort();
				offests.push(new Point(offX, offY));
				sizes.push(new Point(w, h));
			}*/
			readData(allData);

			loadNext();
		}

		private function readData(allData:ByteArray):void {
			var len:int = allData.readUnsignedInt();
			var data:ByteArray = new ByteArray();
			allData.readBytes(data, 0, len);
			__loadList.push(data);

			if (alphaQuality != 0 && quality != alphaQuality) {
				var alphaData:ByteArray = new ByteArray();
				len = allData.readUnsignedInt();
				if (len)
					allData.readBytes(alphaData, 0, len);
				__loadList.push(alphaData);
			}
		}

		private var loadNum:int;
		private function loadNext():void {
			loadNum = 0;

			for each (var data:ByteArray in __loadList) {
				loadData(data);
			}
		}

		private function loadData(data:ByteArray):void {
			var loader:Loader = new Loader();
			loader.loadBytes(data);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadCompleteHandler);

			function loadCompleteHandler(e:Event):void {
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadCompleteHandler);
				var index:int = __loadList.indexOf(data);
				__bmds[index] = (loader.content as Bitmap).bitmapData;

				loadNum++;

				if (loadNum >= __loadList.length)
					loadAllComplete();
			}
		}

		private function loadAllComplete():void {
			result = new <BitmapData>[];
			var bmd:BitmapData = __bmds[0];
			if (alphaQuality != 0 && quality != alphaQuality)
				var alphaBmd:BitmapData = __bmds[1];
			for (var i:int = 0; i < __header.cutRects.length; i++) {
				var bmdRect:Rectangle = __header.cutRects[i];//new Rectangle(dx, 0, size.x, size.y);
				var newBmd:BitmapData = new BitmapData(bmdRect.width == 0 ? 1 : bmdRect.width
					, bmdRect.height == 0 ? 1 : bmdRect.height, true, 0);
				newBmd.copyPixels(bmd, bmdRect, new Point());
				if (alphaQuality != 0 && quality != alphaQuality)
					newBmd.copyChannel(alphaBmd, bmdRect, new Point(), BitmapDataChannel.RED, BitmapDataChannel.ALPHA);
				else
					newBmd.copyChannel(bmd, new Rectangle(bmdRect.x, bmdRect.y + bmd.height / 2, bmdRect.width, bmdRect.height)
						, new Point(), BitmapDataChannel.RED, BitmapDataChannel.ALPHA);

				doAlphaFilter(newBmd);
				result.push(newBmd);
			}

			bmd.dispose();
			if (alphaBmd)
				alphaBmd.dispose();

			__bmds = null;
			__loadList = null;

			__isReadCompleted = true;
			dispatchEvent(new Event(Event.COMPLETE));
		}

		private function doAlphaFilter(bmd:BitmapData):void {
			if (alphaFilter)
				bmd.threshold(bmd, bmd.rect, new Point(), "<", alphaFilter << 24, 0x00000000, 0xFF000000, true);
		}

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------
		
		private var _isDisposed:Boolean;

		/**
		 * Returns <code>true</code> if the <code>dispose()</code> has already been invoked before.
		 */
		public function get isDisposed():Boolean {
			return _isDisposed;
		}
		
		// --------------------------------------------------------------------
		//
		// Methods
		//
		// --------------------------------------------------------------------
		
		/**
		 * Release any resources that the current object might hold a reference to.
		 */
		public function dispose():void {
			if (result) {
				for each (var bmd:BitmapData in this.result)
				bmd.dispose();
			}
		}
	}
}
