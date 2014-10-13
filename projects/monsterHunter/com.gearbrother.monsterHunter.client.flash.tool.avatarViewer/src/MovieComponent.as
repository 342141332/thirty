package {
	import com.gearbrother.glash.common.resource.type.GBmdDefinition;
	import com.gearbrother.glash.display.GMovieBitmap;
	
	import flash.events.Event;
	
	import mx.core.UIComponent;


	/**
	 * @author lifeng
	 * create on 2013-1-31
	 */
	public class MovieComponent extends UIComponent {
		private var _movie:GMovieBitmap;
		public function get movie():GMovieBitmap {
			return _movie;
		}

		private var _definition:GBmdDefinition;
		public function set definition(newValue:GBmdDefinition):void {
			_movie = new GMovieBitmap();
			_movie.definition = newValue;
			_movie.addEventListener(Event.COMPLETE, _handleMovieEvent, false, 0, true);
			addChild(_movie);
		}

		private function _handleMovieEvent(event:Event):void {
			_movie.x = -_movie.bmdsInfo.offsets[0].x;
			_movie.y = -_movie.bmdsInfo.offsets[0].y;
			this.width = _movie.width + 10;
			this.height = _movie.height + 10;
			dispatchEvent(event);
		}

		public function MovieComponent(definition:GBmdDefinition) {
			super();

			this.definition = definition;
		}
	}
}
