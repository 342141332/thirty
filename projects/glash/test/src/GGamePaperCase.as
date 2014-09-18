package {
	import com.gearbrother.glash.GMain;
	import com.gearbrother.glash.algorithm.router.GDirectionConst;
	import com.gearbrother.glash.common.algorithm.GBoxsGrid;
	import com.gearbrother.glash.display.mouseMode.GDragScrollMode;
	import com.gearbrother.glash.display.flixel.GPaper;
	import com.gearbrother.glash.display.flixel.display.GPaperLayerBackground;
	import com.gearbrother.glash.display.paper.display.item.GPaperMovieBitmap;
	import com.gearbrother.glash.display.flixel.display.layer.GPaperLayer;
	import com.gearbrother.glash.display.flixel.sort.SortYManager;
	import com.gearbrother.glash.util.math.GRandomUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.FrameLabel;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;


	/**
	 * @author feng.lee
	 * create on 2012-10-25 下午7:38:56
	 */
	[SWF(width = "800", height = "600", frameRate = "60", backgroundColor = "0xFFFFFF")]
	public class GGamePaperCase extends GMain {
		static public const RUNX:Array = [0, -1, 1, 0, -1, 1, -1, 1];
		static public const RUNY:Array = [1, 0, 0, -1, 1, 1, -1, -1];

		static public const ALL_DIRECT:Array = [GDirectionConst.DOWN
			, GDirectionConst.DOWN | GDirectionConst.LEFT
			, GDirectionConst.LEFT
			, GDirectionConst.LEFT | GDirectionConst.UP
			, GDirectionConst.UP
			, GDirectionConst.UP | GDirectionConst.RIGHT
			, GDirectionConst.RIGHT];

		[Embed(source = "../asset/avatar/walk.png")]
		public var clazz:Class;

		[Embed(source = "../asset/map.jpg", mimeType = "image/jpeg")]
		public var mapClazz:Class;

		public var paper:GPaper;
		public var layer:GPaperLayer;

		public function GGamePaperCase() {
			super();
			
			RUNX[GDirectionConst.DOWN] = 0;
			RUNX[GDirectionConst.DOWN | GDirectionConst.LEFT] = -1;
			RUNX[GDirectionConst.LEFT] = -1;
			RUNX[GDirectionConst.LEFT | GDirectionConst.UP] = -1;
			RUNX[GDirectionConst.UP] = 0;
			RUNX[GDirectionConst.UP | GDirectionConst.RIGHT] = 1;
			RUNX[GDirectionConst.RIGHT] = 1;
			RUNX[GDirectionConst.DOWN | GDirectionConst.RIGHT] = 1;
			
			RUNY[GDirectionConst.DOWN] = 1;
			RUNY[GDirectionConst.DOWN | GDirectionConst.LEFT] = 1;
			RUNY[GDirectionConst.LEFT] = 0;
			RUNY[GDirectionConst.LEFT | GDirectionConst.UP] = -1;
			RUNY[GDirectionConst.UP] = -1;
			RUNY[GDirectionConst.UP | GDirectionConst.RIGHT] = -1;
			RUNY[GDirectionConst.RIGHT] = 0;
			RUNY[GDirectionConst.DOWN | GDirectionConst.RIGHT] = 1;
		}
		
		override protected function doInit():void {
			super.doInit();
			
			var bmp:Bitmap = new clazz() as Bitmap;
			var bmds:Array = separateBitmapData(bmp.bitmapData, 67, 91);
			var labels:Array = [];
			for (var i:int = 0; i < 8; i++) {
				labels.push(new FrameLabel(String(i), i * 8 + 1));
			}
			
			paper = new GPaper();
			paper.camera.bound = new Rectangle(0, 0, 5000, 4000);
			paper.camera.screenRect.x = paper.camera.screenRect.y = 400;
			addChild(paper);
			var background:GPaperLayerBackground = new GPaperLayerBackground(paper.camera);
			background.bitmapData = (new mapClazz() as Bitmap).bitmapData;
			paper.addChild(background);
			layer = new GPaperLayer(paper.camera);
			layer.boxsGrid = new GBoxsGrid(paper.camera.bound.clone(), 300, 300);
			layer.sortManager = new SortYManager(layer);
			paper.addChild(layer);
			for (var j:int = 0; j < 2000; j++) {
				var direction:int = GRandomUtil.integer(0, 7);
				var runner:Runner = new Runner(bmds, direction);
				runner.$position.x = runner.x = GRandomUtil.integer(0, 5000);
				runner.$position.y = runner.y = GRandomUtil.integer(0, 4000);
				runner.labels = labels;
				runner.setLabel(String(direction));
				layer.addObject(runner);
				layer.updateObjectPosition(runner);
			}
			new GDragScrollMode(paper);
			
			enableTick = true;
			addEventListener(MouseEvent.CLICK, handleClick);
		}

		public function handleClick(e:MouseEvent):void {
			var ar:Array = layer.getObjectsUnderPoint(new Point(layer.mouseX, layer.mouseY));
			trace(ar);
		}

		override public function tick(interval:int):void {
			var bound:Rectangle = layer.camera.bound;
			var now:int = getTimer();
			for (var key:* in layer.childrenDict) {
				var runner:Runner = key;
				var position:Point = runner.$position;
				position.x += RUNX[runner.direction] * interval / 20;
				position.y += RUNY[runner.direction] * interval / 20;
				if (position.x > bound.right)
					position.x = bound.left;
				if (position.x < bound.left)
					position.x = bound.right;
				if (position.y > bound.bottom)
					position.y = bound.top;
				if (position.y < bound.top)
					position.y = bound.bottom;
				runner.x = position.x;
				runner.y = position.y;
				layer.updateObjectPosition(runner);
				if (layer.childrenInScreenDict[runner])
					runner.tick(interval);
			}
			//trace(layer.numChildren, " tick ", getTimer() - now);
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
import com.gearbrother.glash.display.paper.display.item.GPaperMovieBitmap;
import com.gearbrother.glash.util.math.GRandomUtil;

import flash.geom.Point;

class Runner extends GPaperMovieBitmap {
	public var $position:Point;
	
	public var direction:uint;

	function Runner(bmds:Array, type:int) {
		super(bmds);

		$position = new Point();
		frameRate = 10;
		enableTick = false;
		direction = type;
	}
}
