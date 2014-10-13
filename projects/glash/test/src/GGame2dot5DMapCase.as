package {
	import com.gearbrother.glash.GMain;
	import com.gearbrother.glash.common.oper.ext.GFile;
	import com.gearbrother.glash.display.manager.GPaintManager;
	import com.gearbrother.glash.display.manager.GTickEvent;
	import com.gearbrother.glash.display.flixel.GPaper;
	import com.gearbrother.glash.display.flixel.control.MoveTask;
	import com.gearbrother.glash.display.paper.display.item.GPaperSprite;
	import com.gearbrother.glash.display.flixel.display.layer.GPaperLayer;
	import com.gearbrother.glash.display.flixel.display.layer.GPaperTileLayer;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;


	/**
	 * @author feng.lee
	 * create on 2012-5-9 上午10:39:11
	 */
	[SWF(width = "1200", height = "700", frameRate = "60")]
	public class GGame2dot5DMapCase extends GMain {
		public static const grid:uint = 20;

		private var paper:GPaper;

		private var finder:D2PathFinder;

		public var avator:GPaperSprite;
		
		public var backgroundLayer:GPaperTileLayer;

		public var avatarLayer:GPaperLayer;

		public var nameLayer:GPaperLayer;
		
		private var __startPt:Point;
		
		private var __clickPt:Point;
		
		private var __isClick:Boolean;

		public function GGame2dot5DMapCase() {
			super();
			
			paper = new GPaper();
			paper.camera.bound.width = paper.camera.bound.height = 9600;
			backgroundLayer = new GPaperTileLayer(paper.camera, new TileLayerImpl
				, new GFile("http://fr2cdn.xunwan.com/relServer_2.0.1.8_20131030_1/otherRes/maps/300103/300103_mini.jpg?"), 10);
			backgroundLayer.cacheAsBitmap = true;
			paper.addChild(backgroundLayer);
			addChild(paper);
			
			/*finder = new D2PathFinder(layer);*/
			
			/*var gridLayer:GridRender = new GridRender(layer, paper.camera);
			gridLayer.positionTransformer = new TilePositionManager(20, 20);
			paper.addLayer(gridLayer);*/
			
			avatarLayer = new GPaperLayer(paper.camera);
			avator = new AvatarView(avatarLayer);//new GPaperMovieBitmap(20);
			avator.x = 9000;
			avator.y = 9000;
			avatarLayer.addChild(avator);
			paper.addChild(avatarLayer);
			paper.camera.focus = avator;
//			GPaintManager.instance.tickGameChannel.addEventListener(GTickEvent.TICK, _onTick);
		}

		private function _onTick(e:GTickEvent):void {
			var stagePt:Point = avator.localToGlobal(new Point);
			var global:Point = new Point(avator.x, avator.y);
			var offsetX:int = avatarLayer.mouseX - global.x;
			var offsetY:int = avatarLayer.mouseY - global.y;
			if (Math.abs(offsetX) >= 5)
				avator.x += int(offsetX / Math.abs(offsetX) * e.interval / 1000 * 210);
			if (Math.abs(offsetY) >= 5)
				avator.y += int(offsetY / Math.abs(offsetY) * e.interval / 1000 * 100);
			
			avatarLayer.tick(e.interval);
			backgroundLayer.tick(e.interval);
//			trace(e.interval);
		}

		private function __onClick(e:MouseEvent):void {
//			var toPoint:Point = new Point(int(paper.mouseX / grid), int(paper.mouseY / grid));
//			var prevTime:int = getTimer();
//			var path:D2Path = finder.findPath(new Point(int(avator.x / grid), int(avator.y / grid)), toPoint);
//			trace("search cost = ", getTimer() - prevTime);
//			return;
			__isClick = true;
			__startPt = new Point(paper.camera.screenRect.x, paper.camera.screenRect.y);
			__clickPt = new Point(stage.mouseX, stage.mouseY);
			var rect:Rectangle = paper.camera.screenRect;
			var leftTop:Point = new Point(rect.left, rect.top);
			leftTop.offset(stage.mouseX, stage.mouseY);
			avator.task = new MoveTask([new Point(avator.x, avator.y), leftTop], 100, avator);
		}
	}
}
import com.gearbrother.glash.common.geom.GDimension;
import com.gearbrother.glash.common.oper.ext.GFile;
import com.gearbrother.glash.display.flixel.display.layer.IGPaperTile;

class TileLayerImpl implements IGPaperTile {
	static public const WIDTH:int = 300;
	static public const HEIGHT:int = 300;

	/**
	 * Returns the size of the tiles.
	 */
	public function getTileSize(zoom:int):GDimension {
		return new GDimension(WIDTH, HEIGHT);
	}

	/**
	 * Returns the URL of the tile to display at the specified location (in
	 * pixels) and zoom. Returns <code>null</code> if there is no tile at the
	 * specified location, if, for example, it is outside the boundaries of the
	 * map.
	 */
	public function getTile(x:int, y:int, zoom:int):GFile {
//			http://fr2cdn.xunwan.com/relServer_1.0.5.1_20120614_1/otherRes/maps/300103/300103_mini.jpg?v=2
//			http://fr2cdn.xunwan.com/relServer_1.0.5.1_20120614_1/otherRes/maps/300103/300103_14_21.jpg?v=2
//			http://fr2cdn.xunwan.com/relServer_1.0.5.1_20120614_1/otherRes/maps/100101/100101_0_11.jpg?v=16
		return new GFile("http://fr2cdn.xunwan.com/relServer_2.0.1.8_20131030_1/otherRes/maps/err/300103/300103_" + int(y / HEIGHT) + "_" + int(x / WIDTH) + ".jpg");
	}
}

import com.gearbrother.glash.util.math.GPointUtil;
import com.gearbrother.glash.common.oper.ext.GAliasFile;
import com.gearbrother.glash.common.oper.ext.GBmdDefinition;
import com.gearbrother.glash.display.GMovieBitmap;
import com.gearbrother.glash.display.GMovieClip;
import com.gearbrother.glash.display.GSkinSprite;
import com.gearbrother.glash.display.GSprite;
import com.gearbrother.glash.display.control.text.GText;
import com.gearbrother.glash.display.paper.display.IGPaperTask;
import com.gearbrother.glash.display.paper.display.item.GPaperSprite;
import com.gearbrother.glash.display.flixel.display.layer.GPaperLayer;

import flash.display.Sprite;
import flash.filters.GlowFilter;
import flash.geom.Point;
import flash.utils.getTimer;
import com.gearbrother.glash.common.oper.ext.GDefinition;


/**
 * @author feng.lee
 * create on 2013-1-29
 */
class AvatarView extends GPaperSprite {
	static public const NAME_FILTER:GlowFilter = new GlowFilter(0x000000, 1, 2, 2, 300);
	
	static public const DIRECTION_LEFT:int = 1;
	static public const DIRECTION_RIGHT:int = 2;
	
	public function get direction():int {
		return movie.scaleX == 1 ? DIRECTION_LEFT : DIRECTION_RIGHT;
	}
	
	public function set direction(value:int):void {
		movie.scaleX = value == DIRECTION_LEFT ? 1 : -1;
	}
	
	protected var _name:GText;
	
	public var movie:GMovieBitmap;
	
	override public function set data(newValue:*):void {
		super.data = newValue;
		movie.data = newValue;
		movie.definition = new GBmdDefinition(new GDefinition(new GFile("/asset/avatar/1.swf"), "Rest"));
		_name.text = data.name;
		_name.x = -_name.width >> 1;
	}
	
	public var speed:int = 145;
	
	public function AvatarView(layer:GPaperLayer = null) {
		super(layer);
		
		movie = new GMovieBitmap();
		movie.enableTick = false;
		addChild(movie);
		direction = DIRECTION_RIGHT;
		
		addChild(_name = new GText());
		_name.filters = [NAME_FILTER];
		_name.fontColor = 0xFFFFFF;
		_name.fontBold = true;
	}
	
	override public function tick(interval:int):void {
		if (task)
			task.process(this, interval);
		
		var moved:Boolean = x != lastTickX || y != lastTickY;
		var position:Point = new Point(x, y);
		if (position.x > lastTickX)
			direction = DIRECTION_RIGHT;
		else if (position.x < lastTickX)
			direction = DIRECTION_LEFT;
		if (direction == DIRECTION_LEFT) {
			movie.scaleX = -1;
		} else if (direction == DIRECTION_RIGHT) {
			movie.scaleX = 1;
		}
		
		if (moved) {
			movie.definition = new GBmdDefinition(new GDefinition(new GFile("/asset/avatar/1.swf"), "Move"));
		} else {
			movie.definition = new GBmdDefinition(new GDefinition(new GFile("/asset/avatar/1.swf"), "Rest"));
		}
		
		movie.tick(interval);
		
		super.tick(interval);
	}
}