package com.gearbrother.tool.mapReader.mode {
	import com.gearbrother.glash.display.flixel.GPaper;
	import com.gearbrother.glash.display.mouseMode.GMouseMode;
	import com.gearbrother.glash.display.mouseMode.IGMouseDown;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;


	/**
	 * @author neozhang
	 * @create on Jul 12, 2013
	 */
	public class CleanMode extends GMouseMode implements IGMouseDown {
		private var _dataCall:Function;

		private var _paper:GPaper;
		
		private var _mouseOverPoint:Point;
		
		public function CleanMode(dataCall:Function, target:GPaper, applyNow:Boolean = true) {
			super(target, applyNow);

			_dataCall = dataCall;
			_paper = target;
		}

		public function mouseDown(e:MouseEvent):void {
			_dataCall(e.target);
		}
	}
}
