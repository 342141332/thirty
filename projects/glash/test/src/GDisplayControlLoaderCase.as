package {
	import com.gearbrother.glash.GMain;
	import com.gearbrother.glash.common.oper.ext.GAliasFile;
	import com.gearbrother.glash.common.oper.ext.GDefinition;
	import com.gearbrother.glash.common.oper.ext.GFile;
	import com.gearbrother.glash.display.container.GContainer;
	import com.gearbrother.glash.display.control.GLoader;
	import com.gearbrother.glash.display.layout.impl.FlowLayout;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;


	/**
	 * @author feng.lee
	 * create on 2012-11-9 下午4:56:45
	 */
	[SWF(widthPercent="700", heightPercent="500", frameRate="60")]
	public class GDisplayControlLoaderCase extends GCase {
		public var loaders:Array = [];
		
		public function GDisplayControlLoaderCase() {
			super();

			stage.color = 0xcccccc;
			var lastIndex:int = loaderInfo.loaderURL.lastIndexOf("/", loaderInfo.loaderURL.lastIndexOf("/") - 1);
			GAliasFile.pathPrefix = loaderInfo.loaderURL.substring(0, lastIndex) + "/asset";
			var rootLayer:GContainer = new GContainer();
			rootLayer.layout = new FlowLayout();
			addChild(rootLayer);
			var testFiles:Array = [
				new GAliasFile("icon/noExist.png")									//.png file
				, new GAliasFile("icon/icon1.png")									//.png file
				, new GAliasFile("icon/icon2.png")									//.png file
				, new GAliasFile("icon/icon2.png")									//.png duplicate file
				, new GAliasFile("icon/icon1.jpg")									//.jpg
				, new GAliasFile("icon/icon1.jpg")									//.jpg duplicate file
//				, new GDefinition(new GAliasFile("icon/skill1.swf"), "Target")		//.swf Class
//				, new GDefinition(new GAliasFile("icon/skill2.swf"), "Target")		//.swf Class
//				, new GDefinition(new GAliasFile("icon/skill2.swf"), "Target")		//.swf Class
			];
			for each (var file:* in testFiles) {
				var loader:GLoader = new GLoader();
				loader.width = loader.height = 100;
				loader.source = file;
				loaders.push(loader);
				rootLayer.addChild(loader);
			}
		}
		
		override protected function doInit():void {
			super.doInit();
			
			return;
			stage.addEventListener(MouseEvent.CLICK, handleMouseEvent);
		}
		
		private var _caseID:int = 0;
		private function handleMouseEvent(event:MouseEvent):void {
			trace("caseID:", _caseID);
			var loader:GLoader;
			var i:int = 0;
			switch (_caseID++) {
				case i++:
					(loaders[0] as GLoader).source = (loaders[1] as GLoader).source = null;
					break;
				case i++:
					for each (loader in loaders) {
						loader.source = new GAliasFile("icon/noExits.png");
					}
					break;
				case i++:
					for each (loader in loaders) {
						loader.source = new GAliasFile("icon/icon1.png");
					}
					break;
				case i++:
					for each (loader in loaders) {
						loader.source = new GAliasFile("icon/icon.swf");
					}
					break;
				case i++:
					for each (loader in loaders) {
						loader.source = new GDefinition(new GAliasFile("icon/skill1.swf"), "Target");
					}
					break;
			}
		}
	}
}
