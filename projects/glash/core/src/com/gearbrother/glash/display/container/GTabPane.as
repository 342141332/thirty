package com.gearbrother.glash.display.container {
	import com.gearbrother.glash.display.GNoScale;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;


	/**
	 * skin
	 * @author feng.lee
	 * create on 2013-1-22
	 */
	public class GTabPane extends GNoScale {
		private var _tabs:Dictionary;
		
		public function GTabPane(skin:DisplayObjectContainer = null) {
			super(skin);
			
			_tabs = new Dictionary();
			for (var i:int = 0; i < skin.numChildren; i++) {
				var child:DisplayObject = skin.getChildAt(i);
				if (child.name.indexOf("tab") != -1 && skin.getChildByName(child.name + "-content")) {
					setTab(child["tab"], child[child.name + "-content"]);
				}
			}
			addEventListener(MouseEvent.CLICK, _handleMouseEvent, false, 0, true);
		}
		
		public function setTab(tab:InteractiveObject, tabContent:DisplayObject):void {
			if (_tabs[tab])
				throw new Error("already has tab");
			_tabs[tab] = tabContent;
		}
		
		private function _handleMouseEvent(event:MouseEvent):void {
			var content:DisplayObject = _tabs[event.target];
			if (content) {
				for (var tab:* in _tabs) {
					if (tab == event.target)
						(_tabs[tab] as DisplayObject)
				}
			}
		}
	}
}
