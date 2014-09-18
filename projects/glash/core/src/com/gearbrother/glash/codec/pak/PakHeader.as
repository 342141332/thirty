package com.gearbrother.glash.codec.pak {
	import flash.display.FrameLabel;
	import flash.geom.Point;
	import flash.geom.Rectangle;


	/**
	 * Pak 文件头 定义一些信息
	 * @author feng.lee
	 * create on 2012-5-9 下午5:21:36
	 */
	public class PakHeader {
		public var quality:int;
		public var alphaQuality:int;
		public var alphaFilter:int;
		public var labels:Array = [];
		public var regPoints:Array = [];
		public var cutRects:Array = [];
		
		public function PakHeader(source:Object = null) {
			if (source) {
				quality = source["quality"];
				alphaQuality = source["alphaQuality"];
				alphaFilter = source["alphaFilter"];
				for each (var labelObj:Object in source["labels"]) {
					var label:FrameLabel = new FrameLabel(labelObj["name"], labelObj["frame"]);
					labels.push(label);
				}
				for each (var p:Object in source["regPoints"]) {
					regPoints.push(new Point(p["x"], p["y"]));
				}
				for each (var r:Object in source["cutRects"]) {
					cutRects.push(new Rectangle(r["x"], r["y"], r["w"], r["h"]));
				}
			}
		}
		
		public function toObject():Object {
			var l:Array = [];
			for each (var label:FrameLabel in labels) {
				l.push({frame: label.frame, name: label.name});
			}
			
			var rp:Array = [];
			for each (var regPt:Point in regPoints) {
				rp.push({x: regPt.x, y: regPt.y});
			}
			
			var cr:Array = [];
			for each (var cutRect:Rectangle in cutRects) {
				cr.push({x: cutRect.x, y: cutRect.y, w: cutRect.width, h: cutRect.height});
			}
			return {quality: quality, alphaQuality: alphaQuality, alphaFilter: alphaFilter, labels: l, regPoints: rp, cutRects: cr};
		}
	}
}
