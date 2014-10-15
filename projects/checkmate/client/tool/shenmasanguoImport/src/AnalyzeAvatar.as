package {
	import br.com.stimuli.loading.loadingtypes.ImageItem;
	
	import com.adobe.images.JPGEncoder;
	import com.adobe.images.PNGEncoder;
	import com.gearbrother.glash.util.lang.UUID;
	
	import flash.display.BitmapData;
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

			var jpgEncoder:JPGEncoder = new JPGEncoder(100);


			var itemIconSwf:Resource = Resource.ALL["assets/plot/itemicon.swf"];
			
			var equipConfig:Resource = Resource.ALL["assets/plot/equip.dat"];
			var equipIconSwf:Resource = Resource.ALL["assets/plot/equipmenticon.swf"];
			for each (var equipConf:* in equipConfig) {
				var equipLevelConf:* = ObjectUtils.getProperties(equipConfig)[0];
				equipLevelConf.picid;
				equipLevelConf.name;
			}
			
			var skillIconSwf:Resource = Resource.ALL["assets/plot/skillicon.swf"];
			var skillConfigs:Object = {};
			for (var i:int = 1; i < 9; i++) {
				for (var skillId:String in (Resource.ALL["config/plot/skills" + i + ".dat"] as Resource).content) {
					var skillConfig:Object = skillConfigs[skillId] = {};
					var skillLevelConfig:Object = ObjectUtils.getProperties((Resource.ALL["config/plot/skills" + i + ".dat"] as Resource).content[skillId])[0];
					skillConfig.name = skillLevelConfig.name;
					skillConfig.describe = skillLevelConfig.description;
					//skill icon
					var skillClazz:* = (skillIconSwf.item as ImageItem).getDefinitionByName(skillLevelConfig.picid);
					if (skillClazz) {
						var skillIconView:Sprite = new skillClazz();
						var skillIconBmp:BitmapData = new BitmapData(skillIconView.width, skillIconView.height);
						skillIconBmp.draw(skillIconView);
						var bytes:ByteArray = PNGEncoder.encode(skillIconBmp);
						var skillIconPath:String = "assets/plot/skill/" + skillLevelConfig.picid + ".png";
						Resource.writeFile(new File(Resource.localRoot + skillIconPath), bytes);
						skillIconBmp.dispose();
						skillConfig.icon = "static/asset/icon/skill/" + skillLevelConfig.picid + ".png";
					}
				}
			}

			var heroIconSwf:Resource = Resource.ALL["assets/plot/heroicon.swf"];
			var heroIcon01Swf:Resource = Resource.ALL["assets/plot/heroicon01.swf"];
			var descriptConfig:Resource = Resource.ALL["config/plot/herodescription.dat"];
			var avatarConfigs:Object = {};
			//analyze hero
			var heroConfigs:Resource = Resource.ALL["config/hero_v.dat"];
			for each (var node:String in heroConfigs.content) {
				var id:String = node.split("|")[0];
				var heroConfig:Resource = Resource.ALL["config/hero/" + id];
				var levelConfigs:Object = heroConfig.content["1"];
				var avatarConfig:Object = avatarConfigs[UUID.getUUID()] = {};
				C:for each (var levelConfig:Object in levelConfigs) {
					//avatar
					var assetConfig:Resource = Resource.ALL["config/plot/general_asset.dat"];
					var avatar:String = (assetConfig.content as XML).s.(@id == levelConfig.picid)[0];
					
					//skill
					var heroSkills:Array = [];
					for each (skillId in levelConfig.skill) {
						skillConfig = skillConfigs[skillId];
						heroSkills.unshift(skillConfig);
					}
					avatarConfig.skills = heroSkills;

					//describe
					if (levelConfig.hasOwnProperty("describeid") && avatar) {
						var describe:Object = ObjectUtils.getProperties(descriptConfig.content[levelConfig.describeid])[0];
						avatarConfig.name = describe.heroname;
						avatarConfig.nation = describe.nation;
						avatarConfig.avatar = "static/asset/avatar/" + avatar.slice(avatar.lastIndexOf("/") + 1, avatar.length);

						//head
						var headClazz:* = (heroIconSwf.item as ImageItem).getDefinitionByName(describe.headid)
							|| (heroIcon01Swf.item as ImageItem).getDefinitionByName(describe.headid);
						var headView:Sprite = new headClazz();
						var headBmp:BitmapData = new BitmapData(headView.width, headView.height);
						headBmp.draw(headView);
						var headBytes:ByteArray = PNGEncoder.encode(headBmp);
						var headIconPath:String = "assets/plot/head/" + describe.headid + ".png";
						Resource.writeFile(new File(Resource.localRoot + headIconPath), headBytes);
						headBmp.dispose();
						avatarConfig.head = headIconPath;

						avatarConfig.describe = describe.describe;
						avatarConfig.armsType = describe.armstype;
						break C;
					}
				}
			}
			var stream:FileStream = new FileStream();
			var file:File = new File(Resource.localRoot + "config.json");
			stream.open(file, FileMode.WRITE);
			stream.writeMultiByte(JSON.stringify(avatarConfigs, null, "\t"), "utf-8");
			stream.close();
		}
	}
}
