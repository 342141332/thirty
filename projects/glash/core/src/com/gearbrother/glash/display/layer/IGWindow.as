package com.gearbrother.glash.display.layer {

	/**
	 * @author neozhang
	 * @create on May 13, 2013
	 */
	public interface IGWindow {
		function canBeNeighbour(other:*):Boolean;

		function compareNeighbour(other:*):int;
	}
}
