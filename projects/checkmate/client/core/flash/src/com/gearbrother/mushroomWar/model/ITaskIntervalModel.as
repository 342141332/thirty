package com.gearbrother.mushroomWar.model {

	public interface ITaskIntervalModel extends ITaskModel {
		function get lastIntervalTime():Number;

		function get interval():Number;
	}
}
