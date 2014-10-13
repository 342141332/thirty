package com.gearbrother.monsterHunter.flash.model {
	import com.gearbrother.glash.common.resource.type.GFile;
	import com.gearbrother.glash.mvc.model.GBean;
	
	import flash.events.IEventDispatcher;


	/**
	 * @author feng.lee
	 * create on 2013-2-21
	 */
	public class SkillBookModel extends GBean implements IPackagableModel {
		static public const NUM:String = "num";
		
		private var _conf:SkillModelConf;
		public function get conf():SkillModelConf {
			return _conf;
		}

		private var _confID:*;
		public function get confID():* {
			return _confID;
		}
		public function set confID(newValue:*):void {
			if (_confID != newValue) {
				_confID = newValue;
				_conf = SkillModelConf.confs[_confID];
				if (!_conf)
					throw new Error("unknown id");
			}
		}
		
		public function get skillConfID():* {
			return _confID;
		}

		public var id:*;

		/**
		 * 吃下技能书给技能增加的经验 
		 */		
		public var equalExp:int;
		
		public function get num():int {
			return getProperty(NUM);
		}
		
		public function set num(newValue:int):void {
			setProperty(NUM, newValue);
		}

		public function SkillBookModel() {
			super();
		}
	}
}
