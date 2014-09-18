package {
	import com.gearbrother.glash.util.lang.UUID;
	
	import flash.display.Sprite;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.system.System;
	import flash.utils.ByteArray;
	
	import org.as3commons.lang.ObjectUtils;


	/**
	 *
	 * @author 	Neo.Zhang
	 * @create 	2014-9-17 下午2:32:39
	 *
	 */
	public class AnalyzeAvatar extends Sprite {
		public function AnalyzeAvatar() {
			super();
			
			var avatarConfigs:Object = {};
			//analyze hero
			var heroConfigs:Config = Config.ALL["config/hero_v.dat"];
			for each (var node:String in heroConfigs.content) {
				var id:String = node.split("|")[0];
				var heroConfig:Config = Config.ALL["config/hero/" + id];
				var levelConfigs:Object = heroConfig.content["1"];
				var avatarConfig:Object = null;
				for each (var levelConfig:Object in levelConfigs) {
					//avatar
					var assetConfig:Config = Config.ALL["config/plot/general_asset.dat"];
					var avatar:String = (assetConfig.content as XML).s.(@id == levelConfig.picid)[0];
					
					//skill
					var heroSkills:Array = [];
					var skillConfigs:Object = {};
					for (var i:int = 1; i < 9; i++) {
						for (var skillId:String in (Config.ALL["config/plot/skills" + i + ".dat"] as Config).content) {
							skillConfigs[skillId] = (Config.ALL["config/plot/skills" + i + ".dat"] as Config).content[skillId];
						}
					}
					for each (skillId in levelConfig.skill) {
						var skillConfig:Object = skillConfigs[skillId];
						heroSkills.unshift(skillConfig);
					}
					
					//describe
					var descriptConfig:Config = Config.ALL["config/plot/herodescription.dat"];
					if (levelConfig.hasOwnProperty("describeid") && avatar) {
						var describe:Object = ObjectUtils.getProperties(descriptConfig.content[levelConfig.describeid])[0];
						avatarConfig = {};
						avatarConfig.name = describe.heroname;
						avatarConfig.avatar = "static/asset/avatar/" + avatar.slice(avatar.lastIndexOf("/") + 1, avatar.length);
						avatarConfig.nation = describe.nation;
						avatarConfig.head = describe.headid;
						avatarConfig.describe = describe.describe;
						avatarConfig.armsType = describe.armstype;
					}
					continue;
				}
				if (avatarConfig)
					avatarConfigs[UUID.getUUID()] = avatarConfig;
			}
			var bytes:ByteArray = new ByteArray();
			var stream:FileStream = new FileStream();
			var file:File = new File("D:/neo/mine/shenmasanguo/config.json");
			stream.open(file, FileMode.WRITE);
			stream.writeMultiByte(JSON.stringify(avatarConfigs, null, "\t"), "utf-8");
			stream.close();
			System.exit(0);
		}
	}
}
