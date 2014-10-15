package com.gearbrother.sheepwolf.view.common.ui {
	import com.gearbrother.glash.common.oper.ext.GAliasFile;
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.IGDndable;
	import com.gearbrother.glash.display.control.GLoader;
	import com.gearbrother.glash.display.control.GProgress;
	import com.gearbrother.glash.display.control.text.GText;
	import com.gearbrother.glash.display.filter.GFilter;
	import com.gearbrother.glash.display.flixel.input.GAscCode;
	import com.gearbrother.sheepwolf.conf.ExplorerConf;
	import com.gearbrother.sheepwolf.model.GameModel;
	import com.gearbrother.sheepwolf.model.SkillModel;
	import com.gearbrother.sheepwolf.rpc.protocol.bussiness.SkillLevelProtocol;
	import com.gearbrother.sheepwolf.rpc.protocol.bussiness.SkillProtocol;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;


	/**
	 * @author lifeng
	 * @create on 2014-1-7
	 */
	public class SkillUiView extends GNoScale implements IGDndable {
		public var nameLabel:GText;

		public var briefDescLabel:GText;

		public var descLabel:GText;

		public var levelLabel:GText;
		
		public var levelProgress:GProgress;

		public var icon:GLoader;

		public var cooldownBox:CoolDownBox;

		public var shortCutLabel:GText;

		public var selectedFilter:GFilter = new GFilter(new GlowFilter(0x00cc00, 1, 2, 2, 100));

		override public function set selected(newValue:Boolean):void {
			super.selected = newValue;

			if (selected)
				selectedFilter.apply(this);
			else
				selectedFilter.unapply(this);
		}

		private var _dndable:Boolean;
		public function get dndable():Boolean {
			return _dndable;
		}
		public function set dndable(newValue:Boolean):void {
			_dndable = newValue;
		}
		
		public function SkillUiView(skin:DisplayObject = null) {
			if (!skin) {
				var _skin:MovieClip = new MovieClip();
				_skin.graphics.lineStyle(2, 0x000000);
				_skin.graphics.beginFill(0xAC5102);
				_skin.graphics.drawCircle(20, 20, 20);
				_skin.graphics.endFill();
				var _icon:Sprite = new Sprite();
				_icon.name = "icon";
				_icon.graphics.beginFill(0x0000ff);
				_icon.graphics.drawRect(0, 0, 20 << 1, 20 << 1);
				_icon.graphics.endFill();
				_skin.addChild(_icon);
				_skin["icon"] = _icon;
				skin = _skin;
				var nameText:TextField = new TextField();
				nameText.autoSize = TextFieldAutoSize.LEFT;
				nameText.wordWrap = false;
				_skin["nameLabel"] = nameText;
				_skin.addChild(nameText);
				var shortCutText:TextField = new TextField();
				shortCutText.autoSize = TextFieldAutoSize.LEFT;
				shortCutText.y = 25;
				_skin["shortCutLabel"] = shortCutText;
				_skin.addChild(shortCutText);
			}
			super(skin);

			if (skin.hasOwnProperty("nameLabel")) {
				nameLabel = new GText(skin["nameLabel"] as TextField);
				nameLabel.fontBold = true;
				nameLabel.fontColor = 0xffffff;
				nameLabel.textField.filters = [new GlowFilter(0x000000, 1, 3, 3, 350)];
			}
			if (skin.hasOwnProperty("briefDescLabel") && skin["briefDescLabel"])
				briefDescLabel = new GText(skin["briefDescLabel"]);
			if (skin.hasOwnProperty("descLabel") && skin["descLabel"])
				descLabel = new GText(skin["descLabel"]);
			if (skin.hasOwnProperty("levelLabel") && skin["levelLabel"])
				levelLabel = new GText(skin["levelLabel"]);
			if (skin.hasOwnProperty("levelProgress"))
				levelProgress = new GProgress(skin["levelProgress"]);
			if (skin.hasOwnProperty("icon")) {
				icon = new GLoader();
				icon.scalePolicy = GLoader.SCALE_POLICY_FILL;
				icon.replace(skin["icon"]);
			}
			if (skin.hasOwnProperty("shortCutLabel"))
				shortCutLabel = new GText(skin["shortCutLabel"]);
			mouseChildren = false;
		}

		override public function handleModelChanged(events:Object = null):void {
			if (bindData is SkillModel) {
				var model:SkillModel = bindData as SkillModel;
				if (nameLabel) {
					nameLabel.text = (model.num == -1 ? "" : " X " + model.num + "") + model.name;
				}
				if (model.num == 0) {
					GFilter.decolor.apply(this);
				} else {
					GFilter.decolor.unapply(this);
				}
				if ((model.lastUseTime + model.level.cooldown) < GameModel.instance.application.serverTime) {
					enableTick = false;
					if (cooldownBox && cooldownBox.parent)
						cooldownBox.remove();
				} else {
					cooldownBox ||= new CoolDownBox();
					cooldownBox.width = icon.width;
					cooldownBox.height = icon.height;
					cooldownBox.startTime = model.lastUseTime;
					cooldownBox.cicyle = model.level.cooldown;
					addChild(cooldownBox);
					enableTick = true;
					alpha = 1.0;
				}
				if (!events || events.hasOwnProperty(SkillModel.SHORT_CUT)) {
					if (shortCutLabel) {
						shortCutLabel.text = GAscCode.instance.codeToKey[model.shortCut];
					}
				}
				if (levelLabel)
					levelLabel.text = "lv." + (model.level.id + 1);
				if (levelProgress) {
					var ceil:SkillLevelProtocol = model.levels.hasOwnProperty(model.level.id + 1) ? model.levels[model.level.id + 1] : model.levels[model.level.id];
					levelProgress.visible = true;
					levelProgress.maxValue = ceil.exp;
					levelProgress.minValue = model.level.exp;
					levelProgress.value = model.exp;
				}
				if (icon)
					icon.source = new GAliasFile(model.icon);
			} else {
				if (nameLabel)
					nameLabel.visible = false;
				if (briefDescLabel)
					briefDescLabel.visible = false;
				if (descLabel)
					descLabel.visible = false;
				if (levelLabel)
					levelLabel.visible = false;
				if (icon)
					icon.source = null;
				if (cooldownBox)
					cooldownBox.parent.removeChild(cooldownBox);
				if (levelProgress)
					levelProgress.visible = false;
			}
		}

		override public function tick(interval:int):void {
			var skillModel:SkillModel = bindData as SkillModel;
			var currentTime:Number = GameModel.instance.application.serverTime;
			if ((skillModel.lastUseTime + skillModel.level.cooldown) > currentTime) {
				if (cooldownBox)
					cooldownBox.tick(interval);
			} else {
				if (cooldownBox && cooldownBox.parent) {
					cooldownBox.remove();
				}
				enableTick = false;
			}
		}
	}
}
import com.gearbrother.glash.display.GNoScale;
import com.gearbrother.glash.util.display.GPen;
import com.gearbrother.sheepwolf.model.GameModel;

class CoolDownBox extends GNoScale {
	public var startTime:Number;

	public var cicyle:Number;

	private var _pen:GPen;

	public function CoolDownBox() {
		super();

		_pen = new GPen(this.graphics);
	}

	override public function tick(interval:int):void {
		_pen.clear();
		_pen.lineStyle(0, 0, 0);
		_pen.beginFill(0x000000, .7);
		var slice:int = 360 * ((GameModel.instance.application.serverTime - startTime) % cicyle) / cicyle;
		var radius:Number = Math.max(width >> 1, height >> 1);
		_pen.drawSlice(360 - slice, radius, -90 + slice, width >> 1, height >> 1);
	}
}
