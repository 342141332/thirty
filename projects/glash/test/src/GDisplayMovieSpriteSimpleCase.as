package {
	import com.gearbrother.glash.GMain;
	import com.gearbrother.glash.display.GMovieClip;
	import com.gearbrother.glash.display.event.GDisplayEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;


	/**
	 * @author feng.lee
	 * create on 2012-11-22 下午12:01:14
	 */
	[SWF(width = "800", height = "600", frameRate = "60")]
	public class GDisplayMovieSpriteSimpleCase extends GMain {
		public var movie:GMovieClip;
		
		public var labels:Array = ["unactive", "active"];
		
		private var labelIndex:int;
		
		public function GDisplayMovieSpriteSimpleCase() {
			super();
			
			stage.addChild(movie = new GMovieClip(new MovieClipSkin(), 10));
			movie.x = movie.y = 300;
			movie.addEventListener(GDisplayEvent.LABEL_ENTER, _handleMovieEvent);
			stage.addEventListener(MouseEvent.CLICK, handleMouseEvent);
		}
		
		private function _handleMovieEvent(event:Event):void {
			logger.debug(event + (event.target as GMovieClip).currentLabel);
		}
		
		public function handleMouseEvent(event:MouseEvent):void {
			switch (event.type) {
				case MouseEvent.CLICK:
					if (!(labels.length > labelIndex))
						labelIndex = 0;
					movie.setLabel(labels[labelIndex++]);
					break;
			}
		}
	}
}
