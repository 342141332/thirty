package com.gearbrother.monsterHunter.flash.model {
	import com.gearbrother.glash.common.resource.type.GAliasFile;
	import com.gearbrother.glash.common.resource.type.GBmdDefinition;
	import com.gearbrother.glash.common.resource.type.GDefinition;
	import com.gearbrother.glash.common.resource.type.GFile;
	import com.gearbrother.glash.mvc.model.GBean;
	import com.gearbrother.glash.util.math.GRandomUtil;
	import com.gearbrother.monsterHunter.flash.service.DebugServiceImpl;
	
	import flash.geom.Point;

	/**
	 * @author feng.lee
	 * create on 2012-12-7 下午3:40:58
	 */
	public class ReplayModel extends GBean {
		public var id:*;
		
		public var background:GBmdDefinition;

		public var mid:GBmdDefinition;
		
		public var hunterA:HunterModel;

		public var monstersA:Array;
		
		public var hunterB:HunterModel;
		
		public var monstersB:Array;

		public var signals:Array;
		
		/**
		 * true: hunterA胜利
		 */		
		public var winner:Boolean;

		public function ReplayModel() {
			background = new GBmdDefinition(new GDefinition(new GAliasFile("asset/map/3.swf"), "BMD_LOW"));
			background = new GBmdDefinition(new GDefinition(new GAliasFile("asset/map/3.swf"), "BMD_UP"));
			signals = [];
		}
	}
}
