package com.gearbrother.mushroomWar.view.tip {
	import com.gearbrother.glash.common.oper.ext.GAliasFile;
	import com.gearbrother.glash.common.oper.ext.GFile;
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.container.GBackgroundContainer;
	import com.gearbrother.glash.display.container.GContainer;
	import com.gearbrother.glash.display.container.GVBox;
	import com.gearbrother.glash.display.control.text.GText;
	import com.gearbrother.glash.display.layout.impl.GridLayout;
	import com.gearbrother.mushroomWar.model.CharacterModel;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;


	/**
	 * @author lifeng
	 * @create on 2014-1-14
	 */
	public class CharacterTip extends GBackgroundContainer {
		public var titleTxt:GText;
		
		public var jobTxt:GText;
		
		public var attackRangeTxt:GText;
		
		public var abilityDamageTxt:GText;
		
		public var intervalTxt:GText;
		
		public var descTxt:GText;
		
		public function CharacterTip() {
			super();

			libs = [new GAliasFile("static/asset/skin/common.swf")];
			/*content = new GText(skin["label"]);
			(content as GText).autoSize = TextFieldAutoSize.LEFT;
			innerRectangle = new Rectangle(content.x, content.y, content.width, content.height);
			outerRectangle = new Rectangle(0, 0, skin.width, skin.height);*/
		}

		override protected function _handleLibsSuccess(res:*):void {
			var file:GFile = libsHandler.cachedOper[libs[0]];
			skin = file.getInstance("TipSkin");
			if (skin["background"]) {
				outerRectangle = skin["background"].getRect(skin);
				backgroundSkin = skin["background"];
			}
			if (skin["content"]) {
				var c:DisplayObject = skin["content"] as DisplayObject;
				c.parent.removeChild(c);
				innerRectangle = c.getRect(skin);
				
				var v:GVBox = new GVBox();
				/****************************************************/
				titleTxt = v.addChild(_newText()) as GText;
				var r:GContainer = new GContainer();
				r.layout = new GridLayout(0, 2);
				/****************************************************/
				(r.addChild(_newText()) as GText).htmlText = "攻击范围：";
				attackRangeTxt = r.addChild(_newText()) as GText;
				/****************************************************/
				(r.addChild(_newText()) as GText).htmlText = "攻击力：";
				abilityDamageTxt = r.addChild(_newText()) as GText;
				/****************************************************/
				(r.addChild(_newText()) as GText).htmlText = "攻击间隔：";
				intervalTxt = r.addChild(_newText()) as GText;
				/****************************************************/
				(r.addChild(_newText()) as GText).htmlText = "职业：";
				jobTxt = r.addChild(_newText()) as GText;
				/****************************************************/
				v.addChild(r);
				descTxt = v.addChild(_newText(0xcccccc)) as GText;
				descTxt.wordWrap = true;
				descTxt.textField.width = 170;
				content = v;
			}
			revalidateBindData();
		}
		
		private function _newText(color:uint = 0xffffff):GText {
			var text:GText = new GText();
			text.fontBold = true;
			text.fontColor = color;
			text.filters = [new GlowFilter(0x000000, 1, 3, 3, 300)];
			return text;
		}

		override public function handleModelChanged(events:Object = null):void {
			if (skin) {
				var characterModel:CharacterModel = bindData;
				titleTxt.htmlText = "<font color=\"#92D050\">" + characterModel.name + " Lv." + (characterModel.level.id + 1) + "</font>";
				if (characterModel.level.attackDamage && characterModel.level.attackDamage.length)
					abilityDamageTxt.htmlText = characterModel.level.attackDamage[0] + " - " + characterModel.level.attackDamage[1];
				intervalTxt.htmlText = String(characterModel.level.interval);
				descTxt.htmlText = characterModel.describe;
			}
		}
	}
}
