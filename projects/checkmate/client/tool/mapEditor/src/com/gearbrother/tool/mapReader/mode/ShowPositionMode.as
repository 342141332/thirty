package com.gearbrother.tool.mapReader.mode {
	import com.gearbrother.glash.display.mouseMode.GMouseMode;
	import com.gearbrother.glash.display.mouseMode.IGMouseMove;
	import com.gearbrother.glash.display.flixel.GPaper;
	
	import flash.events.MouseEvent;
	
	import org.as3commons.lang.StringUtils;
	
	import spark.components.Button;

	/**
	 * @author neozhang
	 * @create on Jul 15, 2013
	 */
	public class ShowPositionMode extends GMouseMode implements IGMouseMove {
		private var _label:Button;

		public function ShowPositionMode(label:Button, trigger:GPaper) {
			super(trigger);

			_label = label;
		}

		public function mouseMove(e:MouseEvent):void {
			var paper:GPaper = _trigger as GPaper;
			_label.label = StringUtils.substitute("{0},{1}", paper.mouseX, paper.mouseY);
		}
	}
}
