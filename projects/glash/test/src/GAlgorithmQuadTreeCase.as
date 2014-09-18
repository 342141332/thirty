package {
	import com.gearbrother.glash.common.algorithm.GBoxsGrid;
	import com.gearbrother.glash.common.algorithm.GQuadtree;
	import com.gearbrother.glash.display.manager.GPaintManager;
	import com.gearbrother.glash.util.math.GRandomUtil;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;

	[SWF(width = "800", height="600", frameRate="20")]

	/**
	 * @author lifeng
	 * @create on 2013-12-26
	 */
	public class GAlgorithmQuadTreeCase extends Sprite {
		static public const num:int = 500;
		
		private var _boxs:Array;
		
		private var _tree:*;
		
		private var _camera:Shape;

		public function GAlgorithmQuadTreeCase() {
			super();
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			GPaintManager.instance.stage = stage;

			_boxs = [];
			var s:int = getTimer();
			var loop:int = 1;
			for (var i:int = 0; i < loop; i++) {
				_tree = new GQuadtree(new Rectangle(0, 0, stage.stageWidth, stage.stageHeight), 4, 7, 1, this.graphics);
//				_tree = new GBoxsGrid(new Rectangle(0, 0, stage.stageWidth, stage.stageHeight));
			}
			trace("build loop " + loop + " caused " + (getTimer() - s) + " milliseconds");
			for (var i:int = 0; i < num; i++) {
				var box:Box = new Box(GRandomUtil.integer(0, stage.stageWidth), GRandomUtil.integer(0, stage.stageHeight)
					, GRandomUtil.integer(20, 70), GRandomUtil.integer(5, 20));
				_boxs.push(box);
				_tree.insert(box);
				addChild(box);
			}
			_camera = new Shape();
			_camera.graphics.lineStyle(1, 0x000000);
			_camera.graphics.beginFill(0x000000, .0);
			_camera.graphics.drawRect(0, 0, 100, 70);
			_camera.graphics.endFill();
			stage.addEventListener(MouseEvent.CLICK, _handleClick);
		}
		
		private function _handleClick(event:MouseEvent):void {
			for each (var box:Box in _boxs) {
				box.overlap = false;
			}
			stage.addChild(_camera);
			_camera.x = stage.mouseX;
			_camera.y = stage.mouseY;
			var s:int = getTimer();
			var loop:int = 1;
			for (var i:int = 0; i < loop; i++) {
				var overlaps:Array = _tree.retrieve(new Rectangle(_camera.x, _camera.y, _camera.width, _camera.height));
			}
			trace("loop " + loop + " caused " + (getTimer() - s) + " milliseconds");
			for each (var o:Box in overlaps) {
				o.overlap = true;
			}
			trace("found num:" + overlaps.length + "/" + num);
		}
	}
}
import com.gearbrother.glash.display.GNoScale;
import com.gearbrother.glash.display.GSprite;
import com.gearbrother.glash.display.flixel.FlxObject;
import com.gearbrother.glash.util.math.GRandomUtil;

class Box extends GNoScale {
	private var _overlap:Boolean;
	
	public function set overlap(newValue:Boolean):void {
		if (_overlap != newValue) {
			_overlap = newValue;
			repaint();
		}
	}
	
	public function Box(x:int, y:int, width:int, height:int) {
		super();
		
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
	}
	
	override protected function doInit():void {
		super.doInit();
		
		repaint();
	}
	
	override public function paintNow():void {
		graphics.clear();
		graphics.lineStyle(1, 0x000000, .3);
		graphics.beginFill(0xff0000, _overlap ? .3 : .0);
		graphics.drawRect(0, 0, width, height);
		graphics.endFill();
	}
}