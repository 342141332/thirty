package com.gearbrother.sheepwolf.view.layer.scene.battle {
	import com.gearbrother.glash.common.oper.GOper;
	import com.gearbrother.glash.common.oper.ext.GFile;
	import com.gearbrother.glash.display.GBitmap;
	import com.gearbrother.glash.display.propertyHandler.GPropertyPoolOperHandler;
	import com.gearbrother.glash.util.display.GDisplayUtil;
	import com.gearbrother.sheepwolf.GameMain;
	import com.gearbrother.sheepwolf.model.BattleItemPuzzleModel;
	import com.gearbrother.sheepwolf.model.BattleItemPuzzleSlotModel;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.geom.Rectangle;


	/**
	 *
	 * @author 	Neo.Zhang
	 * @create 	2014-8-5 下午3:37:19
	 *
	 */
	public class PuzzleBitmap extends GBitmap {
		private var _libsHandler:GPropertyPoolOperHandler;
		public function get libsHandler():GPropertyPoolOperHandler {
			return _libsHandler;
		}
		public function get libs():Array {
			return _libsHandler ? _libsHandler.value : null;
		}
		public function set libs(newValue:Array):void {
			_libsHandler ||= new GPropertyPoolOperHandler(null, this);
			_libsHandler.succHandler = _handleLibsSuccess;
			_libsHandler.value = newValue;
		}
		protected function _handleLibsSuccess(res:*):void {
			var file:GFile = _libsHandler.cachedOper[libs[0]];
			if (file.isStateEnd()) {
				var instance:DisplayObject = file.getInstance("Value");
				instance.width = _item.width;
				instance.height = _item.height;
				//TODO dispose this
				bitmapData = GDisplayUtil.grab(instance
					, new Rectangle(
						_cutRect.x
						, _cutRect.y
						, _cutRect.width
						, _cutRect.height
					)
				);
				if (!GameMain.instance) {
					var unContentRect:Rectangle = bitmapData.getColorBoundsRect(0xff000000, 0xff000000, true);
					if (unContentRect.width != 0 && unContentRect.height != 0) {
						var shape:Shape = new Shape();
						shape.graphics.lineStyle(2, 0xffff00ff, 1);
						shape.graphics.drawRect(0, 0, _cutRect.width, _cutRect.height);
						shape.graphics.endFill();
						bitmapData.draw(shape);
						_item.battle.puzzleTotal++;
					}
				}
			}
		}
		
		private var _item:BattleItemPuzzleSlotModel;
		
		private var _cutRect:Rectangle;
		
		public function PuzzleBitmap(resource:GOper, item:BattleItemPuzzleSlotModel, cutRect:Rectangle, bitmapData:BitmapData = null, pixelSnapping:String = "auto", smoonthing:Boolean = false) {
			super(bitmapData, pixelSnapping, smoonthing);
			
			libs = [resource];
			_item = item;
			_cutRect = cutRect;
		}
	}
}
