package com.gearbrother.glash.display.flixel {
	import com.gearbrother.glash.common.geom.GDimension;
	import com.gearbrother.glash.common.oper.ext.GFile;

	/**
	 * Defines the conversion from pixel map coordinates to the map tiles displayed
	 * on the map.
	 *
	 * @author feng.lee
	 */
	public interface IGPaperTile {
		/**
		 * Returns the size of the tiles.
		 */
		function getTileSize(zoom:int):GDimension;

		/**
		 * Returns the URL of the tile to display at the specified location (in
		 * pixels) and zoom. Returns <code>null</code> if there is no tile at the
		 * specified location, if, for example, it is outside the boundaries of the
		 * map.
		 */
		function getTile(x:int, y:int, zoom:int):GFile;
	}
}