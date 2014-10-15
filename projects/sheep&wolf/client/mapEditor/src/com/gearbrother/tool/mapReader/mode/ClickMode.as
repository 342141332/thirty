package com.gearbrother.tool.mapReader.mode {
	import com.gearbrother.glash.display.flixel.GPaper;
	import com.gearbrother.glash.display.mouseMode.GMouseMode;
	import com.gearbrother.glash.display.mouseMode.IGMouseDown;
	import com.gearbrother.glash.display.mouseMode.IGMouseUp;
	import com.gearbrother.glash.util.math.GMathUtil;
	import com.gearbrother.sheepwolf.model.BattleModel;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;


	/**
	 * @author neozhang
	 * @create on Jul 12, 2013
	 */
	public class ClickMode extends GMouseMode implements IGMouseDown {
		private var _dataCall:Function;

		private var _paper:GPaper;
		
		private var _gridSize:int;
		
		private var _data:BattleModel;
		
		private var _mouseOverPoint:Point;
		
		public function ClickMode(dataCall:Function, target:GPaper, factor:int, data:BattleModel, applyNow:Boolean = true) {
			super(target, applyNow);

			_dataCall = dataCall;
			_paper = target;
			_gridSize = factor;
			_data = data;
		}

		public function mouseDown(e:MouseEvent):void {
			_mouseOverPoint = new Point(GMathUtil.roundUpToMultiple(_paper.mouseX, _gridSize)
				, GMathUtil.roundUpToMultiple(_paper.mouseY, _gridSize));
			_dataCall(_data, _paper.mouseX, _paper.mouseY);
		}
	}
}
