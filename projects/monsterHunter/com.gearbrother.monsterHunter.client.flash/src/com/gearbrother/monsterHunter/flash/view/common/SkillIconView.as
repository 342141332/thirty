package com.gearbrother.monsterHunter.flash.view.common {
	import com.gearbrother.glash.display.GSkinSprite;
	import com.gearbrother.glash.display.container.GContainer;
	import com.gearbrother.glash.display.container.GReplacer;
	import com.gearbrother.glash.display.control.GLoader;
	import com.gearbrother.glash.display.control.text.GText;
	import com.gearbrother.glash.display.layout.impl.CenterLayout;
	import com.gearbrother.glash.display.layout.impl.FillLayout;
	import com.gearbrother.glash.mvc.model.GBean;
	import com.gearbrother.glash.mvc.model.GBeanPropertyEvent;
	import com.gearbrother.glash.util.display.GSearchUtil;
	import com.gearbrother.monsterHunter.flash.model.SkillModel;
	import com.gearbrother.monsterHunter.flash.skin.SkillIconSkin;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;


	/**
	 * @author feng.lee
	 * create on 2012-12-10 下午4:55:21
	 */
	public class SkillIconView extends GSkinSprite {
		private var _loader:GLoader;
		
		private var _level:GText;
		
		private var _levelProgress:Sprite;
		
		override public function set data(value:*):void {
			super.data = value;

			tipData = data;
		}
		
		private function get model():SkillModel {
			return data as SkillModel;
		}

		public function SkillIconView(skin:DisplayObject = null) {
			super(skin ||= new SkillIconSkin());
			
			mouseChildren = false;

			_loader = new GLoader();
			_loader.replace(skin["icon"]);
			
			_level = new GText(GSearchUtil.findChildByClass(skin, TextField));
			_levelProgress = skin["levelProgress"];
		}
		
		override public function handleModelChanged(events:Object = null):void {
			if (!events || events) {
				if (model) {
					_loader.source = model.conf.icon;
					_level.value = "Lv." + model.level;
				} else {
					_loader.source = null;
				}
			}
		}
	}
}
