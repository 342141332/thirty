package {
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import com.gearbrother.glash.GMain;


	/**
	 * @author feng.lee
	 * create on 2012-11-30 上午10:59:35
	 */
	public class GAvmContextMenuCase extends GMain {
		public function GAvmContextMenuCase() {
			super();
		}
		
		override protected function doInit():void {
			super.doInit();
			
			var contextMenu:ContextMenu = new ContextMenu();
			contextMenu.hideBuiltInItems();
			var contextMenuItem:ContextMenuItem = new ContextMenuItem("appXml.version[0]", false);
			contextMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleContextMenuEvent);
			contextMenu.customItems.push(contextMenuItem);
			this.contextMenu = contextMenu;
		}
		
		public function handleContextMenuEvent(event:Event):void {
			trace(event);
		}
	}
}
