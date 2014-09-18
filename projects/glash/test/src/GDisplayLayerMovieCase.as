package {
	import flash.events.MouseEvent;
	
	import com.gearbrother.glash.GMain;
	import com.gearbrother.glash.common.oper.ext.GAliasFile;
	import com.gearbrother.glash.common.utils.GDefinition;


	/**
	 * @author feng.lee
	 * create on 2012-11-30 下午5:50:28
	 */
	[SWF(width = "600", height = "400", frameRate = "60")]
	public class GDisplayLayerMovieCase extends GMain {
		public function GDisplayLayerMovieCase() {
			super();
			
			stage.addEventListener(MouseEvent.CLICK, handleMouseEvent);
		}
		
		public function handleMouseEvent(event:MouseEvent):void {
			switch (event.type) {
				case MouseEvent.CLICK:
					movieLayer.queue(new GDefinition(new GAliasFile("D://beta-asset/asset/asset/ui/widget/user_levelup.swf"), "Main"));
					break;
			}
		}
	}
}
