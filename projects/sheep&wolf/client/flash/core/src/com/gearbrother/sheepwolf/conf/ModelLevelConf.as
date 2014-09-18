package com.gearbrother.sheepwolf.conf {

	/**
	 * @author lifeng
	 * @create on 2014-3-7
	 */
	public class ModelLevelConf {
		public var hp:int;
		public var dragX:int;
		public var dragY:int;
		public var accelerationX:int;
		public var accelerationY:int;
		public var maxVelocityX:int;
		public var maxVelocityY:int;

		public function ModelLevelConf(prototype:Object = null) {
			if (prototype) {
				if (prototype.hasOwnProperty("hp"))
					hp = prototype["hp"];
				if (prototype.hasOwnProperty("dragX"))
					dragX = prototype["dragX"];
				if (prototype.hasOwnProperty("dragY"))
					dragY = prototype["dragY"];
				if (prototype.hasOwnProperty("accelerationX"))
					accelerationX = prototype["accelerationX"];
				if (prototype.hasOwnProperty("accelerationY"))
					accelerationY = prototype["accelerationY"];
				if (prototype.hasOwnProperty("maxVelocityX"))
					maxVelocityX = prototype["maxVelocityX"];
				if (prototype.hasOwnProperty("maxVelocityY"))
					maxVelocityY = prototype["maxVelocityY"];
			}
		}
	}
}
