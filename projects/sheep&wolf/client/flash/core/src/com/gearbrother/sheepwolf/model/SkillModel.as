package com.gearbrother.sheepwolf.model {
	import com.gearbrother.glash.common.oper.ext.GAliasFile;
	import com.gearbrother.glash.common.oper.ext.GFile;
	import com.gearbrother.sheepwolf.rpc.protocol.bussiness.SkillProtocol;

	public class SkillModel extends SkillProtocol {
		static public const CATEGORY_WEAPON:String = "weapon";
		
		static public const CATEGORY_TOOL:String = "tool";

		static public const SHORT_CUT:String = "short_cut";
		public function get shortCut():int {
			return getProperty(SHORT_CUT);
		}
		public function set shortCut(newValue:int):void {
			setProperty(SHORT_CUT, newValue);
		}
		
		public function get iconFile():GFile {
			return new GAliasFile("static/asset/icon/" + icon);
		}
		
		public function SkillModel(prototype:Object = null) {
			super(prototype);
		}
	}
}
