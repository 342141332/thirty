package {
	import com.gearbrother.glash.GMain;


	/**
	 * @author lifeng
	 * @create on 2014-4-29
	 */
	public class TestCase extends GMain {
		public function TestCase(id:String = null) {
			super(id);
		}

		override protected function doInit():void {
			super.doInit();

			CONFIG::debug {
				var status:FPStatus = new FPStatus();
				status.x = stage.stageWidth - 100;
				stage.addChild(status);

				//initialize FlashConsole
				Cc.startOnStage(stage, "`");

				//set root path to workspace, so remove "bin-debug" folder
				var loaderUrl:String = loaderInfo.loaderURL;
				var folder:String = loaderUrl.substring(0, loaderUrl.lastIndexOf("/"));
				GFile.pathPrefix = folder.substring(0, folder.lastIndexOf("/"));
			}
			if (!CONFIG::debug) {
				captureUncaughtErrors(loaderInfo); //since flash player 10.2, support caught global error.
			}
		}
	}
}
