package {

	import com.adobe.images.PNGEncoder;
	import com.gearbrother.glash.GMain;
	import com.gearbrother.glash.display.GMovieBitmap;
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.GSkinSprite;
	import com.gearbrother.glash.display.container.GContainer;
	import com.gearbrother.glash.display.container.GHBox;
	import com.gearbrother.glash.display.container.GScrollBase;
	import com.gearbrother.glash.display.layout.impl.EmptyLayout;
	import com.gearbrother.glash.display.layout.impl.FillLayout;
	import com.gearbrother.glash.display.layout.impl.FlowLayout;
	import com.gearbrother.glash.display.mouseMode.GDragScrollMode;
	import com.gearbrother.glash.manager.RootManager;
	import com.joyct.td.core.Action;
	import com.joyct.td.core.TdFile;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;

	/**
	 * @author feng.lee
	 * @E-mail: streetpoet.p@gmail.com
	 * @version 1.0.0
	 * 创建时间：2012-5-7 上午11:03:29
	 */
	[SWF(width = "1000", height = "500")]
	public class GFomatPakDecoderCase extends GMain {
		//http://s82.app100637550.qqopenapp.com/images/data/10001.pak?ver=380ee3dc5a89db02a9b579c007384a6a
		[Embed(source = "10001.pak", mimeType = "application/octet-stream")]
		public var clazz:Class;
		
		private var _pane:GScrollBase;

		private var _loader:URLLoader;
		
		private var _index:int = 10007;
		
		public function GFomatPakDecoderCase() {
			super();
			
			RootManager.register(this);
			rootLayer.layout = new FillLayout();
			rootLayer.addChild(_pane = new GScrollBase());
			new GDragScrollMode(_pane);
			_pane.layout = new FlowLayout();
			_loader = new URLLoader();
			_loader.dataFormat = URLLoaderDataFormat.BINARY;
			_loader.addEventListener(Event.COMPLETE, handleLoadEvent);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, handleLoadEvent);
			handleLoadEvent();
		}
		
		private function handleLoadEvent(event:Event = null):void {
			if (event) {
				switch (event.type) {
					case Event.COMPLETE:
						if (_loader.data is ByteArray) {
							var decoder:TdFile = new TdFile();
							decoder.addEventListener(Event.COMPLETE, __onDecoderComplete);
							decoder.loadFromBytes(_loader.data as ByteArray);
						}
						break;
					case IOErrorEvent.IO_ERROR:
						break;
				}
			}
			_loader.load(new URLRequest("http://s82.app100637550.qqopenapp.com/images/data/" + _index++ + ".pak"));
		}

		private function __onDecoderComplete(e:Event):void {
			var decoder:TdFile = e.target as TdFile;
			var mWidth:int = 1000;
			var mHeight:int;
			var offset:Point = new Point;
			var keys:Array = decoder.actionList.keys();
			for (var i:int = 0; i < 1/*keys.length*/; i++) {
				var key:int = keys[1];
				var action:Action = decoder.actionList.getValue(key) as Action;
				var bmds:Array = [];
				var offsets:Array = [];
				for each (var index:int in action.indexs) {
					var info:Array = decoder.imageList.get(index) as Array;
					bmds.push(info[0]);
					offsets.push(new Point(info[1] - decoder.imageList.left, info[2] - (decoder.imageList.height - decoder.imageList.bottom)));
				}
				var movie:GMovieBitmap = new GMovieBitmap();
				movie.bitmapOffsets = offsets;
				movie.bitmapDatas = bmds;
				var s:GNoScale = new GNoScale(movie);
				s.width = (bmds[0] as BitmapData).width;
				s.height = (bmds[0] as BitmapData).height;
				var shape:Shape = new Shape();
				shape.graphics.beginFill(0x0000FF);
				shape.graphics.drawRect(0, 0, 3, 3);
				shape.graphics.endFill();
				s.addChild(shape);
				s.x = s.y = 200;
				_pane.addChild(s);
			}
		}
	}
}
