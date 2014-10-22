package com.gearbrother.mushroomWar.model {

	/**
	 *
	 * @author 	Neo.Zhang
	 * @create 	2014-10-20 下午12:00:12
	 *
	 */
	public class NationModel {
		static public const WEI:NationModel = new NationModel("1", "魏", 0x33ffff);

		static public const SHU:NationModel = new NationModel("2", "蜀", 0xcc0000);

		static public const WU:NationModel = new NationModel("3", "吴", 0x00cc00);

		static public const QUN:NationModel = new NationModel("4", "群", 0xcccc00);

		static public const instances:Object = {};
		{
			instances[WEI.id] = WEI;
			instances[SHU.id] = SHU;
			instances[WU.id] = WU;
			instances[QUN.id] = QUN;
		}

		public var id:String;

		public var name:String;

		public var color:uint;

		public function NationModel(id:String, name:String, color:uint) {
			this.id = id;
			this.name = name;
			this.color = color;
		}
	}
}
