package com.gearbrother.monsterHunter.flash.view.common {
	import com.gearbrother.glash.common.geom.GPointUtil;
	import com.gearbrother.glash.common.resource.type.GAliasFile;
	import com.gearbrother.glash.common.resource.type.GBmdDefinition;
	import com.gearbrother.glash.common.resource.type.GDefinition;
	import com.gearbrother.glash.display.GMovieBitmap;
	import com.gearbrother.glash.display.GMovieClip;
	import com.gearbrother.glash.display.GSkinSprite;
	import com.gearbrother.glash.display.GSprite;
	import com.gearbrother.glash.display.control.text.GText;
	import com.gearbrother.glash.paper.display.IGPaperTask;
	import com.gearbrother.glash.paper.display.item.GPaperSprite;
	import com.gearbrother.glash.paper.display.layer.GPaperLayer;
	import com.gearbrother.monsterHunter.flash.model.IAvatarable;
	
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.utils.getTimer;


	/**
	 * @author feng.lee
	 * create on 2013-1-29
	 */
	public class AvatarView extends GPaperSprite {
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
		
		private var _emotion:GSprite;

		public function set emotion(value:String):void {
			if (_emotion) {
				_emotion.remove();
				_emotion = null;
			}
			if (value) {
				_emotion = new GMovieClip(new Sleep(), 24);
				addChild(_emotion);
			}
		}

		public var movie:GMovieBitmap;

		public function get avatar():IAvatarable {
			return data as IAvatarable;
		}

		override public function set data(newValue:*):void {
			if (!newValue is IAvatarable)
				throw new Error();

			super.data = newValue;
			movie.data = newValue;
			movie.definition = avatar.definitionStand;
			_name.value = data.name;
			_name.x = -_name.width >> 1;
		}

		public var speed:int = 145;
		
		public function AvatarView(layer:GPaperLayer = null) {
			super(layer);

			movie = new GMovieBitmap();
			movie.enabledTick = false;
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
			if (x > lastTickX)
				direction = DIRECTION_RIGHT;
			else if (x < lastTickX)
				direction = DIRECTION_LEFT;
			if (direction == DIRECTION_LEFT) {
				movie.scaleX = 1;
			} else if (direction == DIRECTION_RIGHT) {
				movie.scaleX = -1;
			}

			if (moved) {
				movie.definition = avatar.definitionMove;
			} else {
				movie.definition = avatar.definitionStand;
			}

			movie.tick(interval);
			
			super.tick(interval);
		}
	}
}
