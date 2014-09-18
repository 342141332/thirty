package com.gearbrother.monsterHunter.flash.model {
	import com.gearbrother.glash.common.resource.type.GFile;

	/**
	 * @author 		lifeng
	 * @version 	1.0.0
	 * create on	2012-12-7 下午11:20:54
	 */
	public class Argument {
		public function set resourceFolder(value:String):void {
			GFile.pathPrefix = value;
		}
		
		public function Argument() {
		}
	}
}
