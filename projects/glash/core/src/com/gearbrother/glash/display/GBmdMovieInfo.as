package com.gearbrother.glash.display {
	import flash.display.BitmapData;

	/**
	 * @author feng.lee
	 * @create on 2012-12-18
	 */
	public class GBmdMovieInfo {
		public function get memory():int {
			var memory:int = 0;
			for each (var bmd:BitmapData in bmds) {
				memory += uint.length * bmd.height * bmd.width;
			}
			return memory;
		}
		
		public var bmds:Array;

		public var offsets:Array;

		public var labels:Array;

		public var frameRate:Number;

		public var userData:Object;
		
		public function GBmdMovieInfo() {
			bmds = [];
			offsets = [];
			labels = [];
			frameRate = NaN;
		}
	}
}
