package com.gearbrother.mushroomWar.view.window {
	import com.gearbrother.glash.common.oper.ext.GAliasFile;
	import com.gearbrother.glash.common.oper.ext.GFile;
	import com.gearbrother.glash.display.container.GWindow;
	import com.gearbrother.glash.display.event.GDndEvent;
	import com.gearbrother.glash.display.layer.GWindowLayer;
	import com.gearbrother.mushroomWar.model.GameModel;
	import com.gearbrother.mushroomWar.rpc.protocol.bussiness.UserProtocol;
	import com.gearbrother.mushroomWar.view.common.ui.SkillUiView;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import org.as3commons.lang.ObjectUtils;


	/**
	 * @author lifeng
	 * @create on 2014-1-12
	 */
	public class BagDialog extends GWindow {
		public var icons:Array;
		
		override public function canBeNeighbour(window:*):Boolean {
			return window is TankDialog;
		}
		
		override public function compareNeighbour(neighbour:*):int {
			return -1;
		}
		
		override public function set skin(newValue:DisplayObject):void {
			super.skin = newValue;

			icons = [];
			for (var i:int = 0;; i++) {
				var child:DisplayObject = (skin as DisplayObjectContainer).getChildByName("icon" + i);
				if (child)
					icons.push(new SkillUiView(child));
				else
					break;
			}
			bindData = GameModel.instance.loginedUser;
			dragable = false;
			addEventListener(GDndEvent.Drop, _handleDrop);
		}
		
		public function BagDialog(container:GWindowLayer) {
			super(container);
			
			libs = [new GAliasFile("static/asset/skin/bag.swf")];
		}
		
		override protected function _handleLibsSuccess(res:*):void {
			var file:GFile = libsHandler.cachedOper[libs[0]];
			skin = file.getInstance("BagWindowSkin");
		}
		
		override public function handleModelChanged(events:Object=null):void {
			var bagItems:Array = ObjectUtils.getProperties(GameModel.instance.loginedUser.bagItems);
			if (!events || events.hasOwnProperty(UserProtocol.BAG_ITEMS)) {
				for (var i:int = 0; i < icons.length; i++) {
					var icon:SkillUiView = icons[i];
					if (bagItems.length > i) {
						icon.data = bagItems[i];
						icon.dndable = true;
					} else {
						icon.data = null;
					}
				}
			}
		}
		
		private function _handleDrop(event:GDndEvent):void {
			if (event.target is SkillUiView) {
				
			}
		}
	}
}
