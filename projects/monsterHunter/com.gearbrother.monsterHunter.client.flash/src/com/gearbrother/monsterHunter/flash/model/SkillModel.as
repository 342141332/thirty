package com.gearbrother.monsterHunter.flash.model {
	import com.gearbrother.glash.common.resource.type.GAliasFile;
	import com.gearbrother.glash.common.resource.type.GFile;
	import com.gearbrother.glash.mvc.model.GBean;

	/**
	 * @author feng.lee
	 * create on 2012-12-3 下午6:55:41
	 */
	public class SkillModel extends GBean {
		static public const EXP:String = "EXP";

		public var id:*;
		
		private var _level:int
		public function get level():int {
			return _level;
		}

		private var _levelExp:int;
		public function get levelExp():int {
			return _levelExp;
		}
		
		private var _levelNextExp:int;
		public function get levelNextExp():int {
			return _levelNextExp;
		}

		public function get exp():int {
			return getProperty(EXP);
		}
		
		public function set exp(newValue:int):void {
			setProperty(EXP, newValue);
			for (var level:int = _conf.levelExps.length - 1; level > -1; level--) {
				if (newValue >= _conf.levelExps[level]) {
					_level = level;
					_levelExp = newValue - _conf.levelExps[level];
					if (_conf.levelExps.length > _level + 1)
						_levelNextExp = _conf.levelExps[level + 1] - _conf.levelExps[level];
					break;
				}
			}
		}
		
		public function get nextLevelExp():int {
			return 100;
		}
		
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
				_conf = SkillModelConf.confs[_confID]
				if (!_conf)
					throw new Error("can't found skill [" + _confID + "] conf");
			}
		}

		public var owner:MonsterModel;

		public function SkillModel() {
			super();
		}
	}
}
