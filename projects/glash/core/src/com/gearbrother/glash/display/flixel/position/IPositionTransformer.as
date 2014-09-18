package com.gearbrother.glash.display.flixel.position {
	import flash.geom.Point;
	
	import flash.geom.Point;


	public interface IPositionTransformer {
		/**
		 * 转换地图坐标到像素坐标
		 * @param p
		 * @return
		 *
		 */
		function locationToPixel(location:*, zoom:int):Point;

		/**
		 * 转换像素坐标到地图坐标
		 * @param p
		 * @return
		 *
		 */
		function pixelToLocation(pixel:Point, zoom:int):*;

		/**
		 * Returns the magnification coefficient between the two specified zooms,
		 * i.e. how much the map is magnified when the zoom is changed from
		 * <code>startZoom</code> to <code>endZoom</code>. This would normally be a
		 * value larger than 1 if <code>endZoom</code> is larger than
		 * <code>startZoom</code> and vice versa.
		 */
		function getZoomMagnification(startZoom:int, endZoom:int):Number;
	}
}