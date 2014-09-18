package com.gearbrother.monsterHunter.flash.view.scene {
	import com.gearbrother.glash.display.GMovieBitmap;
	import com.gearbrother.glash.display.GSprite;
	import com.gearbrother.glash.display.filter.GFilter;
	import com.gearbrother.glash.paper.GPaper;
	import com.gearbrother.glash.paper.display.layer.GPaperLayer;
	import com.gearbrother.glash.paper.sort.SortYManager;
	import com.gearbrother.glash.util.display.GDisplayUtil;
	import com.gearbrother.monsterHunter.flash.GameMain;
	import com.gearbrother.monsterHunter.flash.skin.CatchSkin;
	import com.gearbrother.monsterHunter.flash.view.common.AvatarView;
	import com.gearbrother.monsterHunter.flash.view.common.MonsterAvatarView;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;


	/**
	 * @author feng.lee
	 * @create on 2013-3-7
	 */
	public class AvatarLayer extends GPaperLayer {
		static public const brightFilter:GFilter = GFilter.getBright(70);
		
		private var _brightObj:DisplayObject;
		
		public function get underMouse():DisplayObject {
			return _brightObj;
		}
		
		public function AvatarLayer(paper:GPaper) {
			super(paper);
			
			mouseChildren = false;
			sortManager = new SortYManager(this);
			addEventListener(MouseEvent.MOUSE_MOVE, _handleMouseEvent);
			addEventListener(MouseEvent.MOUSE_OUT, _handleMouseEvent);
		}
		
		public function _handleMouseEvent(e:MouseEvent):void {
			var objs:Array = getObjectsUnderPoint(new Point(stage.mouseX, stage.mouseY)).reverse();
			var overItem:DisplayObject;
			for each (var obj:DisplayObject in objs) {
				if (GDisplayUtil.pixelHitTest(obj, new Point(obj.mouseX, obj.mouseY))) {
					overItem = obj;
					break;
				}
			}
			if (!overItem)
				GameMain.instance.cursorLayer.cursorClazz = null;
			if (_brightObj != overItem) {
				if (_brightObj)
					brightFilter.unapply(_brightObj);
				_brightObj = obj;
				if (_brightObj) {
					brightFilter.apply(_brightObj);
//					GameMain.instance.cursorLayer.cursorClazz = CatchSkin;
				}
			}
		}
		
		override protected function doDispose():void {
			removeEventListener(MouseEvent.MOUSE_MOVE, _handleMouseEvent);
			removeEventListener(MouseEvent.MOUSE_OUT, _handleMouseEvent);
			
			super.doDispose();
		}
	}
}
