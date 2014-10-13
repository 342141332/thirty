package {
	import flash.geom.Point;
	import com.gearbrother.glash.common.oper.ext.GAliasFile;
	import com.gearbrother.glash.common.oper.ext.GBmdDefinition;
	import com.gearbrother.glash.display.GMovieBitmap;
	import com.gearbrother.glash.display.paper.display.item.GPaperSprite;
	import com.gearbrother.glash.display.flixel.display.layer.GPaperLayer;
	
	
	/**
	 * @author feng.lee
	 * create on 2012-12-7 上午10:43:11
	 */
	public class GGameWalker extends GPaperSprite {
		static public const direct_left:int = 1;
		static public const direct_right:int = 2;
		
		private var _direction:int;
		
		private var _movieControl:Function;
		
		private var _movie:GMovieBitmap;
		
		public function GGameWalker(layer:GPaperLayer = null) {
			super(layer);
			
			_movie = new GMovieBitmap(15);
			_movie.enabledTick = false;
			addChild(_movie);
			enableTick = true;
		}
		
		override public function tick(interval:int):void {
			if (task)
				task.process(this, interval);
			
			var direction:int = _direction;
			var moved:Boolean = (position as Point).distance(new Point(lastTickX, lastTickY)) > 0;
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
				_movie.definition = new GBmdDefinition(new GAliasFile("avatar/5.swf"), "Move", 1, true, true);
			else
				_movie.definition = new GBmdDefinition(new GAliasFile("avatar/5.swf"), "Rest", 1, true, true);
			_movie.tick(interval);
			
			super.tick(interval);
		}
	}
}
