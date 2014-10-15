package com.gearbrother.sheepwolf.model {
	import com.gearbrother.glash.common.oper.ext.GAliasFile;
	import com.gearbrother.glash.common.oper.ext.GBmdDefinition;
	import com.gearbrother.glash.common.oper.ext.GDefinition;
	import com.gearbrother.sheepwolf.rpc.protocol.bussiness.AvatarProtocol;


	/**
	 * @author lifeng
	 * @create on 2014-6-24
	 */
	public class AvatarModel extends AvatarProtocol {
		public function get cartoonWalk():GBmdDefinition {
			return new GBmdDefinition(new GDefinition(new GAliasFile(cartoon), "Value"));
		}
		
		public function AvatarModel(prototype:Object = null) {
			super(prototype);
		}
	}
}
