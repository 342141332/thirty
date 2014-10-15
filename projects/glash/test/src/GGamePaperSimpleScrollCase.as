package {
	import com.gearbrother.glash.GMain;
	import com.gearbrother.glash.common.geom.GDimension;
	import com.gearbrother.glash.common.oper.ext.GFile;
	import com.gearbrother.glash.display.GBitmap;
	import com.gearbrother.glash.display.layout.impl.FillLayout;
	import com.gearbrother.glash.display.flixel.GPaper;
	import com.gearbrother.glash.display.flixel.control.MoveTask;
	import com.gearbrother.glash.display.flixel.display.layer.GPaperLayer;

	import flash.events.MouseEvent;
	import flash.geom.Point;


	/**
	 * @author feng.lee
	 * create on 2012-12-14 下午4:52:06
	 */
	[SWF(width = "1200", height = "700", frameRate = "60")]
	public class GGamePaperSimpleScrollCase extends GMain {
		[Embed(source = "../asset/map.jpg")]
		public var clazz:Class;

		public var paper:GPaper;

		public var avatar:GGameWalker;

		public function GGamePaperSimpleScrollCase(id:String = null) {
			super(id);

			GFile.pathPrefix = "../asset/";

			paper = new GPaper();
			var background:SimpleBackground = new SimpleBackground(paper);
			background.addChild(new clazz());
			paper.addChild(background);
			var avatarlayer:GPaperLayer = new GPaperLayer(paper);
			paper.addChild(avatarlayer);
			rootLayer.layout = new FillLayout();
			rootLayer.addChild(paper);

			avatar = new GGameWalker(avatarlayer); //new GPaperMovieBitmap(20);
			avatar.x = avatar.y = 200;
			avatarlayer.addObject(avatar);
			paper.camera.focus = avatar;
			paper.camera.bound.setSize(new GDimension(3000, 2000));
			addEventListener(MouseEvent.CLICK, _handleMouseEvent);
		}

		private function _handleMouseEvent(event:MouseEvent):void {
			avatar.task = new MoveTask([new Point(avatar.x, avatar.y), paper.camera.screenRect.leftTop().move(stage.mouseX, stage.mouseY)], 200, avatar);
		}
	}
}
import flash.geom.Rectangle;
import com.gearbrother.glash.display.flixel.GPaper;
import com.gearbrother.glash.display.flixel.display.layer.GPaperLayer;

class SimpleBackground extends GPaperLayer {
	private var _scrollRect:Rectangle;

	public function SimpleBackground(paper:GPaper) {
		super(paper);

		_scrollRect = new Rectangle();
		cacheAsBitmap = true;
	}

	override public function tick(interval:int):void {
		if (!_scrollRect.equals(camera.bound)) {
			scrollRect = camera.bound.toRectangle();
			_scrollRect = camera.bound;
		}
	}
}
