package {
	import flash.display.BlendMode;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import com.gearbrother.glash.GMain;
	import com.gearbrother.glash.debug.Logo;
	import com.gearbrother.glash.display.GResourceLoader;

	/**
	 * @author feng.lee
	 * create on 2012-9-29 下午6:07:55
	 */
	[SWF(width = "400", height = "300", frameRate = "60")]
	public class BlendModeTest extends GMain {
		[Embed(source = "bg.jpg")]
		public var bgClazz:Class;

		[Embed(source = "mask.png")]
		public var maskClazz:Class;
		
		public var maskPane:GResourceLoader;

		public function BlendModeTest() {
			super();
		}

		override protected function doInit():void {
			super.doInit();

			stage.addEventListener(MouseEvent.CLICK, handleClick);
			var bgPane:GResourceLoader = new GResourceLoader(new bgClazz());
			bgPane.blendMode = BlendMode.LAYER;
			rootLayer.addChild(bgPane);
			
			maskPane = new GResourceLoader(new maskClazz());
			maskPane.blendMode = BlendMode.INVERT;
			bgPane.addChild(maskPane);
		}
		
		public function handleClick(e:MouseEvent):void {
			var modes:Array = [BlendMode.ADD
				, BlendMode.ALPHA
				, BlendMode.DARKEN
				, BlendMode.DIFFERENCE
				, BlendMode.ERASE
				, BlendMode.HARDLIGHT
				, BlendMode.INVERT
				, BlendMode.LAYER
				, BlendMode.LIGHTEN
				, BlendMode.MULTIPLY
				, BlendMode.NORMAL
				, BlendMode.OVERLAY
				, BlendMode.SCREEN
				, BlendMode.SHADER
				, BlendMode.SUBTRACT];
			var at:int = modes.indexOf(maskPane.blendMode);
			at++;
			if (at == modes.length)
				at = 0;
			maskPane.blendMode = modes[at];
			trace(maskPane.blendMode);
		}
	}
}
