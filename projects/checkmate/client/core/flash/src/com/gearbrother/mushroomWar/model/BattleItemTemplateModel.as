package com.gearbrother.mushroomWar.model {
	import com.gearbrother.glash.mvc.model.GBean;


	/**
	 *
	 * @author 	Neo.Zhang
	 * @create 	2014-8-20 下午7:32:35
	 *
	 */
	public class BattleItemTemplateModel extends GBean {
		public var cartoon:String;
		
		public function BattleItemTemplateModel(prototype:Object = null) {
			super(prototype);
		}

		public function decode(obj:Object):BattleItemTemplateModel {
			for (var k:String in obj) {
				this[k] = obj[k];
			}
			return this;
		}
		
		public function encode():Object {
			return {"cartoon": cartoon};
		}
	}
}
