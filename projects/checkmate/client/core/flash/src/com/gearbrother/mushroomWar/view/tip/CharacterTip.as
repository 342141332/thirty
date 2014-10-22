package com.gearbrother.mushroomWar.view.tip {
	import com.gearbrother.glash.common.oper.ext.GAliasFile;
	import com.gearbrother.glash.common.oper.ext.GFile;
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.container.GBackgroundContainer;
	import com.gearbrother.glash.display.container.GContainer;
	import com.gearbrother.glash.display.container.GVBox;
	import com.gearbrother.glash.display.control.text.GText;
	import com.gearbrother.glash.display.layout.impl.GridLayout;
	import com.gearbrother.glash.display.layout.impl.TableLayout;
	import com.gearbrother.mushroomWar.model.CharacterModel;
	import com.gearbrother.mushroomWar.model.NationModel;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;


	/**
	 * @author lifeng
	 * @create on 2014-1-14
	 */
	public class CharacterTip extends GBackgroundContainer {
		public var titleTxt:GText;
		
		public var hpTxt:GText;
		
		public var attackDamageTxt:GText;
		
		public var attackIntervalTxt:GText;
		
		public var attackRange:GNoScale;

		public var jobTxt:GText;
		
		public var nationTxt:GText;
		
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
				v.addChild(_newSperator());
				var table:GContainer = new GContainer();
				table.layout = new TableLayout(2);
				/****************************************************/
				(table.addChild(_newText(0xcccccc)) as GText).htmlText = "血量__：";
				hpTxt = table.addChild(_newText()) as GText;
				/****************************************************/
				(table.addChild(_newText(0xcccccc)) as GText).htmlText = "攻击力_：";
				attackDamageTxt = table.addChild(_newText()) as GText;
				/****************************************************/
				(table.addChild(_newText(0xcccccc)) as GText).htmlText = "攻击间隔：";
				attackIntervalTxt = table.addChild(_newText()) as GText;
				/****************************************************/
				(table.addChild(_newText(0xcccccc)) as GText).htmlText = "攻击范围：";
				attackRange = table.addChild(new GNoScale()) as GNoScale;
				/****************************************************/
				(table.addChild(_newText(0xcccccc)) as GText).htmlText = "所属职业：";
				jobTxt = table.addChild(_newText()) as GText;
				/****************************************************/
				(table.addChild(_newText(0xcccccc)) as GText).htmlText = "所属国家：";
				nationTxt = table.addChild(_newText()) as GText;
				/****************************************************/
				v.addChild(table);
				v.addChild(_newSperator());
				descTxt = v.addChild(_newText(0x999999)) as GText;
				descTxt.wordWrap = true;
				descTxt.textField.width = 170;
				var f:TextFormat = descTxt.textField.defaultTextFormat;
				f.leading = 5;
				descTxt.textField.defaultTextFormat = f;
				descTxt.textField.setTextFormat(f);
				content = v;
			}
			revalidateBindData();
		}
		
		private function _newText(color:uint = 0xcccccc):GText {
			var text:GText = new GText();
			text.fontBold = true;
			text.fontColor = color;
			text.filters = [new GlowFilter(0x000000, 1, 3, 3, 300)];
			return text;
		}
		
		private function _newSperator():GNoScale {
			var seperator:GNoScale = new GNoScale();
			seperator.graphics.beginFill(0xffffff, .3);
			seperator.graphics.drawRect(0, 0, 100, 1);
//			seperator.graphics.beginFill(0xffffff, .7);
//			seperator.graphics.drawRect(0, 1, 100, 1);
			seperator.width = 100;
			seperator.height = 1;
			return seperator;
		}

		override public function handleModelChanged(events:Object = null):void {
			if (skin) {
				var characterModel:CharacterModel = bindData;
				titleTxt.htmlText = "<font color=\"#92D050\">" + characterModel.name + " Lv." + (characterModel.level.id + 1) + "</font>";
				hpTxt.text = characterModel.level.hp;
				if (characterModel.level.attackDamage && characterModel.level.attackDamage.length)
					attackDamageTxt.htmlText = characterModel.level.attackDamage[0] + " - " + characterModel.level.attackDamage[1];
				var intervalSeconds:Number = characterModel.level.interval / 1000;
				attackIntervalTxt.htmlText = (intervalSeconds % 1 == 0 ? intervalSeconds : intervalSeconds.toFixed(1)) + "秒";
				var maxWidth:int = 0;
				var maxHeight:int = 0;
				attackRange.graphics.clear();
				attackRange.graphics.lineStyle(1, 0x333333);
				attackRange.graphics.beginFill(0xffffff, 1);
				attackRange.graphics.drawRect(0, 0, 10, 10);
				attackRange.graphics.beginFill(0xff0000, 1);
				for each (var attackRect:Array in characterModel.level.attackRects) {
					attackRange.graphics.drawRect(10 + attackRect[0] * 10, attackRect[1] * 10, attackRect[2] * 10, attackRect[3] * 10);
					maxWidth = Math.max(maxWidth, 10 + attackRect[0] * 10 + attackRect[2] * 10);
					maxHeight = Math.max(maxHeight, attackRect[1] * 10 + attackRect[3] * 10);
				}
				attackRange.graphics.endFill();
				attackRange.width = maxWidth;
				attackRange.height = maxHeight;
				jobTxt.htmlText = characterModel.job;
				var nation:NationModel = NationModel.instances[characterModel.nation] as NationModel;
				if (nation)
					nationTxt.htmlText = "<font color=\"#" + nation.color.toString(16) + "\">" + nation.name + "</font>";
				else
					nationTxt.htmlText = "<font color=\"#cccccc\">无</font>";
				descTxt.htmlText = characterModel.describe;
			}
		}
	}
}
