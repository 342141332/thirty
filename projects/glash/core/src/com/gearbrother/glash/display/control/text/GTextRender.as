package com.gearbrother.glash.display.control.text {
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import org.as3commons.lang.StringUtils;

	/**
	 * @author feng.lee
	 * create on 2013-1-8 下午6:19:36
	 */
	public class GTextRender {
		public var topColor:uint;
		
		public var bottomColor:uint;
		
		public var rotation:Number;
		
		public function GTextRender(topColor:uint = 0xFF00FF, bottomColor:uint = 0xFF0000, rotation:Number = Math.PI / 2) {
			this.topColor = topColor;
			this.bottomColor = bottomColor;
			this.rotation = rotation;
		}
		
		public function render(gradientLayer:Shape, textField:TextField):void {
			gradientLayer.graphics.clear();
			var lineStart:int;
			for (var i:int = 0; i < textField.numLines; i++) {
				var lineLength:int = textField.getLineLength(i);
				var realLineLength:int = StringUtils.deleteSpaces(textField.getLineText(i)).length;
				if (realLineLength > 0) {
					var pixelRect:Rectangle = textField.getCharBoundaries(lineStart).union(textField.getCharBoundaries(lineStart + realLineLength - 1));
					pixelRect.width = Math.min(textField.x + textField.width/* - 4gutter*/, pixelRect.right) - pixelRect.left;
					var m:Matrix = new Matrix();
					m.createGradientBox(pixelRect.width, pixelRect.height, rotation, pixelRect.x, pixelRect.y);
					gradientLayer.graphics.beginGradientFill(GradientType.LINEAR, [topColor, bottomColor], [1, 1], [0, 255], m);
					gradientLayer.graphics.drawRect(pixelRect.x, pixelRect.y, pixelRect.width, pixelRect.height);
					gradientLayer.graphics.endFill();
				}
				lineStart += lineLength;
			}
		};
	}
}
