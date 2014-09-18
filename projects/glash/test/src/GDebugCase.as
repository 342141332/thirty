package {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import com.gearbrother.glash.debug.FPStatus;
	import com.gearbrother.glash.manager.RootManager;


	/**
	 * @author feng.lee
	 * create on 2012-7-11 下午3:57:32
	 */
	public class GDebugCase extends Sprite {
		public function GDebugCase() {
			super();
			
			RootManager.register(this);
			
//			var bmd:BitmapData = new BitmapData(80, 80, true, 0xFFCCCCCC);
//			this.graphics.beginBitmapFill(bmd);
//			this.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
//			function handleClick(e:MouseEvent):void {
//				bmd.setPixel(0, 0, 0x0000FF);
//				bmd.setPixel(1, 0, 0x0000FF);
//				bmd.setPixel(0, 1, 0x0000FF);
//				bmd.setPixel(1, 1, 0x0000FF);
//				bmd.scroll(1, 0);
//			}
//			stage.addEventListener(MouseEvent.CLICK, handleClick);
//			return;
			
			var status:FPStatus = new FPStatus();
			stage.addChild(status);
		}
	}
}
