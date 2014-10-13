package com.gearbrother.monsterHunter.flash.model {
	import com.gearbrother.glash.common.resource.type.GAliasFile;
	import com.gearbrother.glash.common.resource.type.GBmdDefinition;
	import com.gearbrother.glash.common.resource.type.GDefinition;
	import com.gearbrother.glash.common.resource.type.GFile;
	import com.gearbrother.glash.mvc.model.GBean;

	/**
	 * @author feng.lee
	 * create on 2012-12-3 下午6:41:49
	 */
	public class HunterModel extends GBean implements IAvatarable {
		static public const MONSTERS:String = "MONSTERS";
		
		static public const MONSTER_MAXIMUM:String = "MONSTER_CAPACITY";

		static public const BAG_ITEMS:String = "BAG";
		
		static public const BAG_MAXIMUM:String = "BAG_MAXIMUM";
		
		static public const GOLD:String = "GOLD";

		static public const SILVER:String = "SILVER";
		
		static public const ACTION_POINT:String = "ACTION_POINT";
		
		static public const FOLLOW_MONSTER:String = "FOLLOW_MONSTER";
		
		static public const FOMATS:String = "FOMATS";
		
		static public const ENTRY:String = "ENTRY";

		public var id:*;

		public var name:String;

		public function get monsters():Array {
			return getProperty(MONSTERS);
		}

		public function set monsters(newValue:Array):void {
			setProperty(MONSTERS, newValue);
		}
		
		public function get monsterMaximum():int {
			return getProperty(MONSTER_MAXIMUM);
		}
		public function set monsterMaximum(newValue:int):void {
			setProperty(MONSTER_MAXIMUM, newValue);
		}

		public function get bagItems():Array {
			return getProperty(BAG_ITEMS);
		}
		
		public function set bagItems(newValue:Array):void {
			setProperty(BAG_ITEMS, newValue);
		}
		
		public function get fomats():Array {
			return getProperty(FOMATS);
		}
		
		public function set fomats(newValue:Array):void {
			setProperty(FOMATS, newValue);
		}
		
		public function get gold():int {
			return getProperty(GOLD);
		}
		public function set gold(newValue:int):void {
			setProperty(GOLD, newValue);
		}

		public function get silver():int {
			return getProperty(SILVER);
		}
		public function set silver(newValue:int):void {
			setProperty(SILVER, newValue);
		}
		
		public function get actionPoint():int {
			return getProperty(ACTION_POINT);
		}
		public function set actionPoint(newValue:int):void {
			setProperty(ACTION_POINT, newValue);
		}

		public var avatarFile:GFile;

		public function get definitionStand():GBmdDefinition {
			return new GBmdDefinition(new GDefinition(avatarFile, "Rest"));
		}

		public function get definitionMove():GBmdDefinition {
			var def:GBmdDefinition = new GBmdDefinition(new GDefinition(avatarFile, "Move"));
			return def;
		}

		public function get definitionADMovie():GBmdDefinition {
			var hit:GBmdDefinition = new GBmdDefinition(new GDefinition(avatarFile, "Attack"));
			hit.signalChildrenNames = ["target"];
			return hit;
		}

		public function get definitionApMovie():GBmdDefinition {
			var def:GBmdDefinition = new GBmdDefinition(new GDefinition(avatarFile, "CfAttack"));
			def.signalChildrenNames = ["target"];
			return def;
		}
		
		public function get followMonster():MonsterModel {
			return getProperty(FOLLOW_MONSTER);
		}
		public function set followMonster(newValue:MonsterModel):void {
			setProperty(FOLLOW_MONSTER, newValue);
		}

		public function get mapID():* {
			return getProperty(ENTRY);
		}
		public function set mapID(newValue:*):void {
			setProperty(ENTRY, newValue);
		}
		
		public function HunterModel() {
			avatarFile = new GAliasFile("asset/avatar/male.swf")
		}
	}
}
