package {
	import com.gearbrother.glash.GMain;
	import com.gearbrother.glash.common.oper.ext.GBmdDefinition;
	import com.gearbrother.glash.common.oper.ext.GDefinition;
	import com.gearbrother.glash.common.oper.ext.GFile;
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.manager.GTickEvent;
	import com.gearbrother.glash.display.flixel.GPaper;
	import com.gearbrother.glash.display.flixel.control.MoveTask;
	import com.gearbrother.glash.display.flixel.display.GPaperLayerBackground;
	import com.gearbrother.glash.display.paper.display.item.GPaperSprite;
	import com.gearbrother.glash.display.flixel.display.layer.GPaperLayer;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;


	/**
	 * @author feng.lee
	 * create on 2012-5-9 上午10:39:11
	 */
	[SWF(width = "1200", height = "700", frameRate = "60")]
	public class GGame2DMapCase extends GMain {
		public static const grid:uint = 20;

		private var paper:GPaper;

		private var avatar:GWalker;

		private var avatarLayer:GPaperLayer;

		public function GGame2DMapCase() {
			super();

			paper = new GPaper();
			paper.camera.bound.width = 3500;
			paper.camera.bound.height = 750;

			var background:GPaperLayerBackground = new GPaperLayerBackground(paper.camera, .5);
			background.definition = new GDefinition(new GFile("asset/map/2d/3.swf"), "BMD_LOW");
			paper.addChild(background);

			background = new GPaperLayerBackground(paper.camera, 1);
			background.definition = new GDefinition(new GFile("asset/map/2d/3.swf"), "BMD_UP");
			paper.addChild(background);

			avatarLayer = new GPaperLayer(paper.camera);
			avatar = new GWalker(avatarLayer); //new GPaperMovieBitmap(20);
			avatar.x = 500;
			avatar.y = 400;
			avatarLayer.addChild(avatar);
			paper.addChild(avatarLayer);
			paper.camera.focus = avatar;

			addChild(paper);
//			GPaintManager.instance.tickGameChannel.addEventListener(GTickEvent.TICK, __onTick);
			addEventListener(MouseEvent.CLICK, _handleMouseEvent);
		}

		private function __onTick(e:GTickEvent):void {
			var interval:int = e.interval;
			var global:Point = new Point(avatar.x, avatar.y);
			var offsetX:int = avatarLayer.mouseX - global.x;
			var offsetY:int = avatarLayer.mouseY - global.y;
			var changedX:int;
			var changedY:int;
			if (Math.abs(offsetX) >= 8)
				changedX = int(offsetX / Math.abs(offsetX) * interval / 1000 * 270);
			if (Math.abs(offsetY) >= 5)
				changedY = int(offsetY / Math.abs(offsetY) * interval / 1000 * 170);
			avatar.x += changedX;
			avatar.y += changedY;
		}

		private function _handleMouseEvent(e:MouseEvent):void {
//			var toPoint:Point = new Point(int(paper.mouseX / grid), int(paper.mouseY / grid));
//			var prevTime:int = getTimer();
//			var path:D2Path = finder.findPath(new Point(int(avator.x / grid), int(avator.y / grid)), toPoint);
//			trace("search cost = ", getTimer() - prevTime);
//			return;
			var leftTop:Point = new Point(paper.camera.screenRect.left, paper.camera.screenRect.top);
			avatar.task = new MoveTask([new Point(avatar.x, avatar.y), leftTop.add(new Point(stage.mouseX, stage.mouseY))], 200, avatar);
		}
	}
}

import com.gearbrother.glash.util.math.GPointUtil;
import com.gearbrother.glash.common.oper.ext.GBmdDefinition;
import com.gearbrother.glash.common.oper.ext.GDefinition;
import com.gearbrother.glash.common.oper.ext.GFile;
import com.gearbrother.glash.display.GMovieBitmap;
import com.gearbrother.glash.display.paper.display.item.GPaperSprite;
import com.gearbrother.glash.display.flixel.display.layer.GPaperLayer;

import flash.geom.Point;


/**
 * @author feng.lee
 * create on 2012-12-7 上午10:43:11
 */
class GWalker extends GPaperSprite {
	static public const direct_left:int = 1;
	static public const direct_right:int = 2;
	
	private var _direction:int;
	
	private var _movieControl:Function;

	private var _movie:GMovieBitmap;

	public function GWalker(layer:GPaperLayer = null) {
		super(layer);

		_movie = new GMovieBitmap(12);
		_movie.enableTick = false;
		_movie.definition = new GBmdDefinition(new GDefinition(new GFile("asset/avatar/5.swf"), "Move"), 0, true, true);
		addChild(_movie);
		enableTick = true;
	}

	override public function tick(interval:int):void {
		if (task)
			task.process(this, interval);
		_movie.tick(interval);
		return;

		var position:Point = new Point(x, y);
		var direction:int = _direction;
		var moved:Boolean = GPointUtil.distance(position, new Point(lastTickX, lastTickY)) > 0;
		if (position.x > lastTickX)
			direction = direct_right;
		else if (position.x < lastTickX)
			direction = direct_left;
		if (direction == direct_left) {
			_movie.scaleX = -1;
		} else if (direction == direct_right) {
			_movie.scaleX = 1;
		}
		if (moved)
			_movie.definition = new GBmdDefinition(new GDefinition(new GFile("asset/avatar/5.swf"), "Move"), 0, true, true);
		else
			_movie.definition = new GBmdDefinition(new GDefinition(new GFile("asset/avatar/5.swf"), "Rest"), 0, true, true);
		_movie.tick(interval);

		super.tick(interval);
	}
}
