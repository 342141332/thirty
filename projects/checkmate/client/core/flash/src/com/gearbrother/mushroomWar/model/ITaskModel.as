package com.gearbrother.mushroomWar.model {

	public interface ITaskModel {
		function get instanceId():String;

		function get nextExecuteTime():Number;

		function execute(now:Number):void;
	}
}
