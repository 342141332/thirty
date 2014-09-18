package {
	import com.gearbrother.glash.GMain;
	import com.gearbrother.glash.common.geom.GDimension;
	import com.gearbrother.glash.display.GDisplayConst;
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.GSprite;
	import com.gearbrother.glash.display.container.GContainer;
	import com.gearbrother.glash.display.layout.impl.BorderLayout;
	import com.gearbrother.glash.display.layout.impl.HorizontalLayout;
	import com.gearbrother.glash.util.display.GColorUtil;
	import com.gearbrother.glash.util.math.GRandomUtil;
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;


	/**
	 * @author feng.lee
	 * create on 2012-5-28 下午11:48:05
	 */
	[SWF(widthPercent = "100", heightPercent = "100", frameRate = "60")]
	public class GDisplayLayoutCase extends GMain {
		public function GDisplayLayoutCase() {
			super();

			rootLayer.layout = new BorderLayout();
			rootLayer.append(newBox(randomColor(), 20, 10), BorderLayout.NORTH);
			rootLayer.append(newBox(randomColor(), 60), BorderLayout.EAST);
			var south:GContainer = new Box(randomColor());
			south.layout = new BorderLayout();
			south.width = 20;
			south.height = 90;
			var east:Box = new Box(randomColor());
			east.layout = new HorizontalLayout(GDisplayConst.ALIGN_CENTER);
			east.width = east.height = 200;
			(east.addChild(new Box(randomColor())) as Box).manualPreferredSize = new GDimension(100, 30);
			(east.addChild(new Box(randomColor())) as Box).manualPreferredSize = new GDimension(100, 30);
			south.append(east, BorderLayout.EAST);
			rootLayer.append(south, BorderLayout.SOUTH);
			rootLayer.append(newBox(randomColor(), 30), BorderLayout.WEST);
			rootLayer.append(newBox(0x0000FF, 20, 90), BorderLayout.CENTER);
			function _handleClick(e:MouseEvent):void {
				e.stopImmediatePropagation();

				switch (e.target) {
					case east:
						var res:Array = [];
						for (var i:int = 0; i < east.numChildren; i++) {
							var c:Box = east.getChildAt(i) as Box;
							res.push(c);
						}
						var b:Box = east.addChild(new Box(randomColor())) as Box;
						b.manualPreferredSize = new GDimension(100, 30);
						b.scaleX = b.scaleY = .0;
						TweenLite.to(b, 1.5, {scaleX: 1.0, scaleY: 1.0, onUpdate: b.revalidateLayout, onComplete: b.revalidateLayout});
						break;
					default:
						var target:Box = e.target as Box;
						TweenLite.to(target, 1.5, {scaleX: .0, scaleY: .0, onUpdate: target.revalidateLayout, onComplete: target.revalidateLayout});
						break;
				}
			}
			addEventListener(MouseEvent.CLICK, _handleClick);
		}

		private function randomColor():uint {
			return GColorUtil.RGB(GRandomUtil.integer(0, 255), GRandomUtil.integer(0, 255), GRandomUtil.integer(0, 255));
		}

		private function newBox(color:uint = 0x000000, width:uint = 50, height:int = 70):GSprite {
			var shape:Box = new Box(color);
			shape.width = width;
			shape.height = height;
			shape.buttonMode = true;
			return shape;
		}
	}
}
import com.gearbrother.glash.display.GNoScale;
import com.gearbrother.glash.display.container.GContainer;

import flash.events.MouseEvent;

class Box extends GContainer {
	private var _color:uint;

	public function Box(color:uint) {
		super();

		_color = color;
	}

	override public function paintNow():void {
		graphics.clear();
		graphics.beginFill(_color, .5);
		graphics.drawRect(0, 0, width, height);
		graphics.endFill();
	}
}