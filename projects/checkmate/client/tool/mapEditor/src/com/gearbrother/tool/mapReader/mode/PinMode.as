package com.gearbrother.tool.mapReader.mode {
	import com.gearbrother.glash.display.flixel.GPaper;
	import com.gearbrother.glash.display.mouseMode.GMouseMode;
	import com.gearbrother.glash.display.mouseMode.IGMouseDown;
	import com.gearbrother.glash.display.mouseMode.IGMouseUp;
	import com.gearbrother.glash.util.math.GMathUtil;
	import com.gearbrother.mushroomWar.model.BattleModel;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;


	/**
	 * @author neozhang
	 * @create on Jul 12, 2013
	 */
	public class PinMode extends GMouseMode implements IGMouseDown, IGMouseUp {
		private var _dataCall:Function;

		private var _paper:GPaper;
		
		private var _gridSize:int;
		
		private var _data:BattleModel;
		
		private var _mouseOverPoint:Point;
		
		public function PinMode(dataCall:Function, target:GPaper, factor:int, data:BattleModel, applyNow:Boolean = true) {
			super(target, applyNow);

			_dataCall = dataCall;
			_paper = target;
			_data = data;
		}

		public function mouseDown(e:MouseEvent):void {
			_mouseOverPoint = new Point(GMathUtil.roundUpToMultiple(_paper.mouseX, _gridSize)
				, GMathUtil.roundUpToMultiple(_paper.mouseY, _gridSize));
			_trigger.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			mouseMove(e);
		}

		public function mouseUp(e:MouseEvent):void {
			_mouseOverPoint = null;
			_trigger.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		}

		public function mouseMove(e:MouseEvent):void {
			var row:int = _paper.mouseY / _gridSize;
			var col:int = _paper.mouseX / _gridSize;
			if (!_mouseOverPoint.equals(new Point(col, row))) {
				_dataCall(_data, _paper.mouseY, _paper.mouseX);
				_mouseOverPoint = new Point(col, row);
				_data.dispatchEvent(new Event(Event.CHANGE));
			}
		}
	}
}
