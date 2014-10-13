package com.gearbrother.monsterHunter.flash.view.common {
	import com.gearbrother.glash.display.GSkinSprite;
	import com.gearbrother.glash.display.IGDndable;
	import com.gearbrother.glash.display.container.GReplacer;
	import com.gearbrother.glash.display.control.GLoader;
	import com.gearbrother.glash.display.control.text.GText;
	import com.gearbrother.glash.display.event.GDisplayEvent;
	import com.gearbrother.glash.mvc.model.GBean;
	import com.gearbrother.glash.mvc.model.GBeanPropertyEvent;
	import com.gearbrother.glash.util.display.GSearchUtil;
	import com.gearbrother.monsterHunter.flash.model.SkillBookModel;
	import com.gearbrother.monsterHunter.flash.skin.ItemBackground;
	
	import flash.display.DisplayObject;
	import flash.text.TextField;


	/**
	 * @author feng.lee
	 * create on 2013-2-21
	 */
	public class BagItemView extends GSkinSprite implements IGDndable {
		private var _loader:GLoader;
		
		private var _num:GText;
		
		public function get dndData():* {
			return data;
		}
		
		public function BagItemView() {
			var skin:ItemBackground = new ItemBackground();
			super(skin);
			
			mouseChildren = false;
			
			_loader = new GLoader();
			_loader.replace(skin["icon"]);
			
			_num = new GText(GSearchUtil.findChildByClass(skin, TextField));
		}
		
		override public function handleModelChanged(events:Object=null):void {
			var model:SkillBookModel = data as SkillBookModel;
			if (!events || events.hasOwnProperty(SkillBookModel.NUM)) {
				if (model)
					_num.value = "×" + (data as SkillBookModel).num;
				else
					_num.value = "";
			}
			if (!events) {
				if (model)
					_loader.source = (data as SkillBookModel).conf.icon;
				else
					_loader.source = null;
			}
		}
	}
}
