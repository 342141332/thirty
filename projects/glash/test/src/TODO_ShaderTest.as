package {
	import flash.display.Shader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;

	public class TODO_ShaderTest extends Sprite {
		[Embed(source = "PixelColourShader.pbj", mimeType = "application/octet-stream")]
		private var PixelColourShader:Class;
		
		private var loader:URLLoader;

		public function TODO_ShaderTest() {
			var shader:Shader = new Shader();
			shader.byteCode = new PixelColourShader();
		}

		private function loadCompleteHandler(event:Event):void {
			var shader:Shader = new Shader();
			shader.byteCode = loader.data;

			for (var p:String in shader.data) {
				trace(p, ":", shader.data[p]);
				for (var d:String in shader.data[p]) {
					trace("\t", d, ":", shader.data[p][d]);
				}
			}
		}
	}
}
