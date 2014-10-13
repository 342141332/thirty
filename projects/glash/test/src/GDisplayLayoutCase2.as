package {
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.container.GScrollBase;
	import com.gearbrother.glash.display.layout.impl.FlowLayout;
	import com.gearbrother.glash.display.layout.impl.HorizontalLayout;
	import com.gearbrother.glash.util.display.GColorUtil;
	import com.gearbrother.glash.util.math.GRandomUtil;
	import com.greensock.TweenLite;
	
	import flash.events.MouseEvent;


	/**
	 * @author feng.lee
	 * create on 2012-5-28 下午11:48:05
	 */
	[SWF(widthPercent = "100", heightPercent = "100", frameRate = "60")]
	public class GDisplayLayoutCase2 extends GCase {
		public function GDisplayLayoutCase2() {
			super();

			layout = new FlowLayout();
			for (var i:int = 0; i < 20; i++) {
				addChild(newBox(randomColor(), GRandomUtil.integer(30, 100), GRandomUtil.integer(30, 100)));
			}
			stage.addEventListener(MouseEvent.CLICK, _handleMouseEvent);
		}

		private function randomColor():uint {
			return GColorUtil.RGB(GRandomUtil.integer(0, 255), GRandomUtil.integer(0, 255), GRandomUtil.integer(0, 255));
		}

		private function newBox(color:uint = 0x000000, width:uint = 50, height:int = 70):GNoScale {
			var shape:GNoScale = new GScrollBase;
			shape.graphics.beginFill(color, .5);
			shape.graphics.drawRect(0, 0, width, height);
			shape.graphics.endFill();
			shape.width = width;
			shape.height = height;
			shape.buttonMode = true;
			shape.cacheAsBitmap = true;
			shape.addEventListener(MouseEvent.CLICK, _handleMouseEvent);
			return shape;
		}

		private function _handleMouseEvent(e:MouseEvent):void {
			switch (e.target) {
				case stage:
					var w:int = GRandomUtil.integer(30, 100);
					var h:int = GRandomUtil.integer(30, 100);
					var b:GNoScale = newBox(randomColor(), w, h);
					b.width = b.height = 0;
					append(b);
					TweenLite.to(b, 1.7, {"width": w, "height": h, onUpdate: b.revalidateLayout, onComplete: b.revalidateLayout});
					break;
				default:
					var target:GNoScale = e.target as GNoScale;
					TweenLite.to(target, 1.7, {"width": .0, "height": .0, onUpdate: target.revalidateLayout, onComplete: target.remove}); 
					e.stopImmediatePropagation();
					break;
			}
		}
	}
}