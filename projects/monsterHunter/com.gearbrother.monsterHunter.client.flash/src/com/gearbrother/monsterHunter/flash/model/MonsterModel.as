package com.gearbrother.monsterHunter.flash.model {
	import com.gearbrother.glash.common.resource.type.GAliasFile;
	import com.gearbrother.glash.common.resource.type.GBmdDefinition;
	import com.gearbrother.glash.common.resource.type.GFile;
	import com.gearbrother.glash.mvc.model.GBean;
	
	import flash.geom.Point;

	/**
	 * @author feng.lee
	 * create on 2012-12-7 下午3:47:08
	 */
	public class MonsterModel extends GBean implements IAvatarable {
		static public const BASE_HP:String = "hp";

		static public const MP:String = "mp";
		
		static public const EXP:String = "EXP";
		
		static public const LEVEL:String = "LEVEL";

		static public const SPEED:String = "SPEED";

		static public const ATTACK_DAMAGE:String = "ATTACK_DAMAGE";

		static public const ATTACK_ARMOR:String = "ATTACK_ARMOR";

		static public const ABILITY_POWER:String = "ABILITY_POWER";

		static public const ABILITY_ARMOR:String = "ABILITY_ARMOR";

		static public const SKILLS:String = "SKILLS";

		static public const ARMED_SKILLS:String = "CARRAY_SKILLS";
		
		static public const POSITION:String = "POSITION";
		
		static public const FOMAT:String = "FOMAT";

		public var id:*;
		
		public function get exp():int {
			return getProperty(EXP);
		}
		
		public function set exp(newValue:int):void {
			setProperty(EXP, newValue);
		}
		
		private var _level:int;
		public function get level():int {
			return _level;
		}
		public function set level(newValue:int):void {
			_level = newValue;
		}
		
		public function get name():String {
			return _conf.name;
		}

		public var rarity:Number;
		
		public var rank:int;
		
		public function get rankStr():String {
			return ["D", "C", "B", "A", "S"][rank - 1];
		}
		
		public function get hp():int {
			return getProperty(BASE_HP);
		}

		public function set hp(value:int):void {
			setProperty(BASE_HP, value);
		}
		
		public function get mp():int {
			return getProperty(MP);
		}
		
		public function set mp(value:int):void {
			setProperty(MP, value);
		}

		public function get attackDamage():int {
			return getProperty(ATTACK_DAMAGE);
		}

		public function set attackDamage(value:int):void {
			setProperty(ATTACK_DAMAGE, value);
		}

		public function get attackArmor():int {
			return getProperty(ATTACK_ARMOR);
		}
		
		public function set attackArmor(newValue:int):void {
			setProperty(ATTACK_ARMOR, newValue);
		}
		
		public function get abilityPower():int {
			return getProperty(ABILITY_POWER);
		}

		public function set abilityPower(value:int):void {
			setProperty(ABILITY_POWER, value);
		}
		
		public function get abilityArmor():int {
			return getProperty(ABILITY_ARMOR);
		}
		public function set abilityArmor(newValue:int):void {
			setProperty(ABILITY_ARMOR, newValue);
		}
		
		public function get speed():int {
			return getProperty(SPEED);
		}
		public function set speed(newValue:int):void {
			setProperty(SPEED, newValue);
		}

		public function get skills():Array {
			return getProperty(SKILLS);
		}

		public function set skills(value:Array):void {
			setProperty(SKILLS, value);
		}

		/*public function get armedSkills():Array {
			return getProperty(ARMED_SKILLS);
		}

		public function set armedSkills(value:Array):void {
			setProperty(ARMED_SKILLS, value);
		}*/
		
		public function get mapPosition():Point {
			return getProperty(POSITION);
		}
		
		public function set mapPosition(newValue:Point):void {
			setProperty(POSITION, newValue);
		}

		public function get fomat():Point {
			return getProperty(FOMAT);
		}
		public function set fomat(newValue:Point):void {
			setProperty(FOMAT, newValue);
		}
		
		/**
		 * 当前Monster跟随Hunter 
		 */		
		public var follow:Boolean;
		
		public var user:HunterModel;

		public function get definitionStand():GBmdDefinition {
			return _conf.definitionStand;
		}

		public function get definitionMove():GBmdDefinition {
			return _conf.definitionMove;
		}

		public function get definitionADMovie():GBmdDefinition {
			return _conf.definitionAttackMovie;
		}

		public function get definitionApMovie():GBmdDefinition {
			return _conf.definitionAbilityMovie;
		}

		private var _confID:*;
		public function get confID():* {
			return _confID;
		}
		public function set confID(newValue:*):void {
			if (_confID != newValue) {
				_confID = newValue;
				_conf = MonsterModelConf.confs[newValue];
				if (!_conf)
					throw new Error("unknown confID");
			}
		}
		
		private var _conf:MonsterModelConf;
		
		public function MonsterModel() {
			super();
		}
		
		public function clone():* {
			var clone:MonsterModel = new MonsterModel();
			clone.abilityArmor = abilityArmor;
			clone.abilityPower = abilityPower;
//			clone.armedSkills = armedSkills;
			clone.attackArmor = attackArmor;
			clone.attackDamage = attackDamage;
			clone.confID = confID;
			clone.follow = follow;
			clone.fomat = fomat;
			clone.hp = hp;
			clone.id = id;
			clone.mapPosition = mapPosition;
			clone.mp = mp;
			clone.rank = rank;
			clone.rarity = rarity;
			clone.skills = skills;
			clone.speed = speed;
			clone.user = user;
			return clone;
		}
	}
}
