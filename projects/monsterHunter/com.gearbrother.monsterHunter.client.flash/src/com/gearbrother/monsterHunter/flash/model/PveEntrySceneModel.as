package com.gearbrother.monsterHunter.flash.model {
	import com.gearbrother.flash.util.lang.ArrayEventable;
	import com.joyway.dragonSoul.module.script.model.ScriptMap;
	import com.joyway.dragonSoul.module.script.model.SweepModel;
	import com.joyway.dragonSoul.module.script.view.scriptmap.ScriptMapMediator;

	import flash.events.IEventDispatcher;

	import org.gearbrother.glash.common.pool.GFile;

	public class PveEntrySceneModel extends ArrayEventable implements ISceneModel {
		public function get settleable():Boolean {
			return true;
		}

		public function get sceneView():Class {
			return ScriptMapMediator;
		}

		public function get sceneSound():GFile {
			return null;
		}

		public var sweepModel:SweepModel;

		public function getScriptNameByID(id:int):String {
			for each (var vo:ScriptMap in source) {
				if (vo.id == id)
					return vo.name;
			}
			return "";
		}

		public function getScriptMapByID(id:int):ScriptMap {
			for each (var vo:ScriptMap in source) {
				if (vo.id == id)
					return vo;
			}
			return null;
		}
	}
}
