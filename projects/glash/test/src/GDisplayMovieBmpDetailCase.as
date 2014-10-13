package {
	import com.gearbrother.glash.GMain;
	import com.gearbrother.glash.common.oper.ext.GBmdDefinition;
	import com.gearbrother.glash.common.oper.ext.GDefinition;
	import com.gearbrother.glash.common.oper.ext.GFile;
	import com.gearbrother.glash.display.GMovieBitmap;
	import com.gearbrother.glash.display.GSprite;
	import com.gearbrother.glash.display.event.GDisplayEvent;
	import com.gearbrother.glash.display.layout.impl.EmptyLayout;
	import com.greensock.TweenMax;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;

	[SWF(width = "800", height = "600", frameRate = "60")]
	public class GDisplayMovieBmpDetailCase extends GMain {
		static public const logger:ILogger = getLogger(GDisplayMovieBmpDetailCase);

		public var movie:GMovieBitmap;

		public var target:GSprite;

		public function GDisplayMovieBmpDetailCase(id:String = null) {
			super(id);
			
			stage.color = 0xcccccc;
			rootLayer.layout = new EmptyLayout();
			movie = new GMovieBitmap();
			movie.definition = new GBmdDefinition(new GDefinition(new GFile("asset/avatar/6.swf"), "Rest"), 0, false, false, ["target"]);
			movie.addEventListener(GDisplayEvent.LABEL_QUEUE_START, _handleMovieEvent);
			movie.x = movie.y = 300;
			rootLayer.addChild(movie);
			
			var box:GSprite = new GSprite();
			box.graphics.beginFill(0x000000);
			box.graphics.drawRect(0, 0, 5, 5);
			box.graphics.endFill();
			box.x = box.y = 300;
			rootLayer.addChild(box);
			
//			var movie2:GMovieBitmap = new GMovieBitmap();
//			movie2.definition = new GBmdDefinition(new GFile("../asset/avatar/1.swf"), "Rest");
//			movie2.x = 400;
//			movie2.y = 300;
//			rootLayer.addChild(movie2);

			stage.addEventListener(MouseEvent.CLICK, _handleMouseEvent);
		}

		private function _handleMovieEvent(event:GDisplayEvent):void {
			logger.debug(event);
			logger.debug(movie.bmdsInfo.userData["target"]);
			if (!target) {
				target = new GSprite();
				target.graphics.beginFill(0xff0000, .3);
				target.graphics.drawEllipse(0, 0, 20, 10);
				target.graphics.endFill();
				target.x = movie.x + (movie.bmdsInfo.userData["target"] as Point).x - (target.width >> 1);
				target.y = movie.y + (movie.bmdsInfo.userData["target"] as Point).y - (target.height >> 1);
				rootLayer.addChild(target);
			}
		}

		private function _handleMouseEvent(event:MouseEvent):void {
			var objs:Array = rootLayer.getObjectsUnderPoint(new Point(rootLayer.mouseX, rootLayer.mouseY));
			return;
			movie.definition = new GBmdDefinition(new GFile("../asset/avatar/6.swf"), "Attack");
			movie.setLabel(null, 1);
			movie.addEventListener(GDisplayEvent.LABEL_QUEUE_END, _handleMovieEvent2);
			movie.addEventListener(GDisplayEvent.LABEL_QUEUE_START, _handleMovieEvent2);
			TweenMax.to(target, 1.3, {shake: {y: -15, num: 2, oneSide: true}});
		}
		
		private function _handleMovieEvent2(event:Event):void {
			trace(event);
		}
	}
}
