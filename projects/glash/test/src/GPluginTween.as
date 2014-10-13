package {
	import com.greensock.TweenMax;
	
	import flash.events.MouseEvent;
	
	import com.gearbrother.glash.GMain;
	import com.gearbrother.glash.display.GSprite;


	/**
	 * @author feng.lee
	 * create on 2012-12-26 下午5:49:48
	 */
	[SWF(width = "800", height = "600", frameRate = "60")]
	public class GPluginTween extends GMain {
		public var target:GSprite = new GSprite();
		public function GPluginTween(id:String = null) {
			super(id);
			
			target.graphics.beginFill(0xff0000, .3);
			target.graphics.drawEllipse(0, 0, 20, 10);
			target.graphics.endFill();
			rootLayer.addChild(target);
			
			stage.addEventListener(MouseEvent.CLICK, handleMouseEvent);
		}
		
		private function handleMouseEvent(event:MouseEvent):void {
			TweenMax.to(target, 1.3, {shake: {y: -15, num: 2, oneSide: true}});
		}
	}
}
