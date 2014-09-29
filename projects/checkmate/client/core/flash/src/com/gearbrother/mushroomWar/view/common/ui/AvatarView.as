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
		static public const idle:String = "idle";
		static public const running:String = "running";
		static public const runningEnd:String = "runningEnd";
		static public const fighting:String = "fighting";
		static public const fightingEnd:String = "fightingEnd";
		static public const dead:String = "dead";
		static public const deadEnd:String = "deadEnd";

		private var _cartoon:String;
		private var _cartoonFile:GFile;
		private var _label:String;
		public function setCartoon(cartoon:String, label:String):void {
			if (cartoon) {
				if (_cartoon != cartoon) {
					_cartoonFile = new GAliasFile(cartoon);
					definition = new GBmdDefinition(new GDefinition(_cartoonFile, "Avatar"));
				}
				if (_label != label) {
					_label = label;
					_definitionHandler.revalidate();
				}
			} else {
				_cartoon = definition = null;
			}
		}

		override protected function _handleDefinition(handler:GPropertyPoolOperHandler):void {
			super._handleDefinition(handler);
			
			if (definition) {
				switch (_label) {
					case fighting:
						setLabel(_label, 1);
						queueLabel(idle);
						break;
					default:
						setLabel(_label);
						break;
				}
			}
		}

		public function AvatarView() {
			super();

			frameRate = 10;
		}

		override public function handleModelChanged(events:Object = null):void {
			var model:AvatarModel = bindData;
			if (model) {
				setCartoon(model.cartoon, idle);
			} else {
				definition = null;
			}
		}
	}
}
