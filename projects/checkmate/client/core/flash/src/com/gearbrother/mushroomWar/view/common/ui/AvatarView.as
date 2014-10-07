package com.gearbrother.mushroomWar.view.common.ui {
	import com.gearbrother.glash.common.oper.ext.GAliasFile;
	import com.gearbrother.glash.common.oper.ext.GBmdDefinition;
	import com.gearbrother.glash.common.oper.ext.GDefinition;
	import com.gearbrother.glash.common.oper.ext.GFile;
	import com.gearbrother.glash.display.GMovieBitmap;
	import com.gearbrother.glash.display.propertyHandler.GPropertyPoolOperHandler;
	import com.gearbrother.mushroomWar.model.AvatarModel;
	import com.gearbrother.mushroomWar.view.common.AvatarFile;


	/**
	 *
	 * @author 	Neo.Zhang
	 * @create 	2014-8-19 下午1:55:53
	 *
	 */
	public class AvatarView extends GMovieBitmap {
		static public const STATE_STOP_UP:int = 1;
		static public const STATE_STOP_RIGHT:int = 2;
		static public const STATE_STOP_DOWN:int = 3;
		static public const STATE_STOP_LEFT:int = 4;
		
		static public const STATE_MOVE_UP:int = 9;
		static public const STATE_MOVE_RIGHT:int = 10;
		static public const STATE_MOVE_DOWN:int = 11;
		static public const STATE_MOVE_LEFT:int = 12;

		public static const STATE_SKILL_UP:int = 25;
		public static const STATE_SKILL_RIGHT:int = 26;
		public static const STATE_SKILL_DOWN:int = 27;
		public static const STATE_SKILL_LEFT:int = 28;

		private var _cartoon:String;
		private var _currentState:int;
		private var _cartoonFile:GFile;
		public function setCartoon(cartoon:String, state:int):void {
			if (cartoon) {
				if (_cartoon != cartoon) {
					_cartoonFile = new GAliasFile(cartoon);
				}
				if (_cartoon != cartoon || _currentState != state) {
					_cartoon = cartoon;
					_currentState = state;
					var def:String;
					var frame:int;
					switch (_currentState) {
						case STATE_MOVE_DOWN:
							def = "Soldier";
							frame = 3;
							break;
						case STATE_MOVE_LEFT:
							def = "Soldier";
							frame = 4;
							break;
						case STATE_MOVE_RIGHT:
							def = "Soldier";
							frame = 2;
							break;
						case STATE_MOVE_UP:
							def = "Soldier";
							frame = 1;
							break;
						case STATE_STOP_DOWN:
							def = "Soldier";
							frame = 3;
							break;
						case STATE_STOP_LEFT:
							def = "Soldier";
							frame = 4;
							break;
						case STATE_STOP_RIGHT:
							def = "Soldier";
							frame = 2;
							break;
						case STATE_STOP_UP:
							def = "Soldier";
							frame = 1;
							break;
						case STATE_SKILL_UP:
							def = "Soldier";
							frame = 5;
							break;
						case STATE_SKILL_RIGHT:
							def = "Soldier";
							frame = 6;
							break;
						case STATE_SKILL_DOWN:
							def = "Soldier";
							frame = 7;
							break;
						case STATE_SKILL_LEFT:
							def = "Soldier";
							frame = 8;
							break;
						default:
							throw new Error();
					}
					definition = new AvatarFile(frame, new GDefinition(_cartoonFile, def));
				}
			} else {
				_cartoon = definition = null;
			}
		}

		public function AvatarView() {
			super();

			frameRate = 10;
		}

		override public function handleModelChanged(events:Object = null):void {
			var model:AvatarModel = bindData;
			if (model) {
				setCartoon(model.cartoon, STATE_STOP_DOWN);
			} else {
				definition = null;
			}
		}
	}
}
