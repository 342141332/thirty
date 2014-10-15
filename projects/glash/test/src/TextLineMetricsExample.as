package {
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.*;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextLineMetrics;
	import flash.utils.setTimeout;

	public class TextLineMetricsExample extends Sprite {
		private var gutter:int = 10;
		private var label:TextField;

		public function TextLineMetricsExample() {
			configureAssets();
			configureListeners();
			resizeHandler(new Event(Event.RESIZE));
			stage.addEventListener(MouseEvent.CLICK, handleMouse);
			
			var matrix1:Matrix = new Matrix(1, 0, 0, 1, 10, 10);
			trace(matrix1);
			matrix1.invert();
			trace(matrix1);
			
			var matrix2:Matrix = new Matrix(1, 0, 0, 1, 10, 10);
			matrix2.concat(matrix1);
			trace(matrix2);
		}
		
		private function handleMouse(event:MouseEvent):void {
			gutter += 10;
			draw();
			showMetrics();
		}

		private function showMetrics():void {
			var metrics:TextLineMetrics = label.getLineMetrics(0);
			var reader:LineMetricsReader = new LineMetricsReader(metrics);
			trace("lineText: " + label.getLineText(0));
			trace("metrics: " + reader);
		}

		private function configureAssets():void {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			label = new TextField();
			label.background = true;
			label.backgroundColor = 0xFFFFFF;
			label.multiline = true;
			label.wordWrap = true;
			label.text = getLabelText();
			addChild(label);
		}

		private function configureListeners():void {
			stage.addEventListener(Event.RESIZE, resizeHandler);
		}

		private function resizeHandler(event:Event):void {
			draw();
			setTimeout(showMetrics, 100);
		}

		private function draw():void {
			label.x = gutter;
			label.y = gutter;
			label.width = stage.stageWidth - (gutter * 2);
			label.height = stage.stageHeight - (gutter * 2);
		}

		private function getLabelText():String {
			var text:XML = <body>The Flex product line enables developers to build rich Internet applications that blend the responsiveness of desktop software, the cross-platform reach of the web, and the expressiveness of the Flash Platform.</body>
			return text.toString();
		}
	}
}

import flash.text.TextLineMetrics;

class LineMetricsReader {
	private var metrics:TextLineMetrics;

	public function LineMetricsReader(metrics:TextLineMetrics) {
		this.metrics = metrics;
	}

	public function toString():String {
		return "[TextLineMetrics ascent:" + metrics.ascent + ", descent:" + metrics.descent + ", leading:" + metrics.leading + ", width:" + metrics.width + ", height:" + metrics.height + ", x:" + metrics.x + "]";
	}
}
