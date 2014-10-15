package {
	import com.gearbrother.glash.GMain;
	import com.gearbrother.glash.display.GSkinSprite;
	import com.gearbrother.glash.display.GSprite;
	import com.gearbrother.glash.display.container.GContainer;
	import com.gearbrother.glash.util.display.GDisplayUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;


	/**
	 * @author neozhang
	 * @create on May 20, 2013
	 */
	[SWF(width = "1200", height = "800", frameRate = "60")]
	public class GDisplayEffectCase extends GMain {
		[Embed(source = "../asset/pic1.jpg")]
		public var pic1:Class;

		public var pic:GSprite;
		
		public var m:Array;
		
		public function GDisplayEffectCase() {
			super();
			
			m = [];
			rootLayer.layout = null;
			rootLayer.addChild(pic = new GSkinSprite(new pic1()));
			stage.addEventListener(MouseEvent.CLICK, _handleMouseEvent);
		}
		
		private function _handleMouseEvent(event:MouseEvent):void {
			enableTick = true;
			m.push(new GSkinSprite(new Bitmap(GDisplayUtil.grab(pic))));
			rootLayer.addChild(m[m.length - 1]);
		}
		
		override public function tick(interval:int):void {
			for each (var l:DisplayObject in m) {
				l.scaleX += .01;
				l.scaleY += .01;
				l.alpha -= .01;
				l.x = (pic.width - l.width) / 2;
				l.y = (pic.height - l.height) / 2;
				if (l.alpha == 0)
					l.parent.removeChild(l);
			}
		}
	}
}
