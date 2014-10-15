package com.gearbrother.sheepwolf.view.layer.scene.battle {
	import com.gearbrother.glash.common.oper.ext.GAliasFile;
	import com.gearbrother.glash.common.oper.ext.GFile;
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.container.GContainer;
	import com.gearbrother.glash.display.container.GHBox;
	import com.gearbrother.glash.display.container.GVBox;
	import com.gearbrother.glash.display.control.GProgress;
	import com.gearbrother.glash.display.control.text.GText;
	import com.gearbrother.glash.display.layout.impl.FlowLayout;
	import com.gearbrother.glash.display.propertyHandler.GPropertyBindDataHandler;
	import com.gearbrother.glash.util.lang.GDateUtil;
	import com.gearbrother.sheepwolf.GameMain;
	import com.gearbrother.sheepwolf.model.BattleItemUserModel;
	import com.gearbrother.sheepwolf.model.BattleModel;
	import com.gearbrother.sheepwolf.model.GameModel;
	import com.gearbrother.sheepwolf.model.SkillModel;
	import com.gearbrother.sheepwolf.rpc.protocol.bussiness.BattleItemUserProtocol;
	import com.gearbrother.sheepwolf.rpc.protocol.bussiness.BattleProtocol;
	import com.gearbrother.sheepwolf.view.common.ui.ProgressView;
	import com.gearbrother.sheepwolf.view.common.ui.SkillUiView;
	
	import flash.display.Shape;
	import flash.filters.GlowFilter;


	/**
	 * @author lifeng
	 * @create on 2014-2-27
	 */
	public class BattleSceneViewUi extends GContainer {
		public var topCenter:GVBox;

		public var clockText:GText;

		public var progressView:ProgressView;
		
		public var skillIcons:GHBox;
		
		public var battle:BattleModel;
		
		private var _bindDataHandler2:GPropertyBindDataHandler;
		public function get bindData2():* {
			return _bindDataHandler2 ? _bindDataHandler2.value : null;
		}
		public function set bindData2(newValue:*):void {
			_bindDataHandler2 ||= new GPropertyBindDataHandler(handleModelChanged, this);
			_bindDataHandler2.value = newValue;
		}
		
		public function BattleSceneViewUi(battle:BattleModel) {
			super();
			
			this.battle = battle;
			libs = [new GAliasFile("static/asset/skin/battle.swf")];
		}
		
		override protected function _handleLibsSuccess(res:*):void {
			var skinFile:GFile  = libsHandler.cachedOper[libs[0]] as GFile;
			var hbox:GHBox = new GHBox();
			hbox.addChild(new GNoScale(skinFile.getInstance("PRODUCE_TIME_ICON")));
			hbox.addChild(clockText = new GText());
			clockText.fontColor = 0xffffff;
			clockText.fontSize = 14;
			clockText.fontBold = true;
			clockText.text = "00:00:00";
			topCenter = new GVBox();
			topCenter.addChild(hbox);
			topCenter.addChild(progressView = new ProgressView(skinFile.getInstance("ProgressSkin")));
			addChild(topCenter);
			addChild(skillIcons = new GHBox());
			
			enableTick = true;
			bindData = battle.loginedBattleUser;
			bindData2 = battle;
		}
		
		override public function tick(interval:int):void {
			var lastTime:Number = battle.expiredPeriod - GameModel.instance.application.serverTime + battle.startTime;
			if (lastTime < 0) {
				GameMain.instance.battleService.getResult();
				enableTick = false;
			}
			clockText.text = GDateUtil.formatSeconds(Math.max(0, lastTime) / 1000);
		}
		
		override public function handleModelChanged(events:Object = null):void {
			var model:BattleItemUserModel = bindData as BattleItemUserModel;
			if (!events || events.hasOwnProperty(BattleItemUserProtocol.SKILLS)) {
				//update shortCut
				skillIcons.removeAllChildren();
				var skillIndex:int = 49;
				for each (var skillModel:SkillModel in model.skills) {
					var skillIcon:SkillUiView = new SkillUiView();
					skillIcon.alpha = .5;
					skillModel.shortCut = skillIndex++;
					skillIcon.bindData = skillModel;
					addChild(skillIcon);
					skillIcons.addChild(skillIcon);
				}
			}
			if (!events || events.hasOwnProperty(BattleProtocol.PUZZLE_FINISHED_TOTAL)) {
				var model2:BattleModel = bindData2;
				progressView.pipe.minValue = 0;
				progressView.pipe.maxValue = model2.puzzleTotal;
				progressView.pipe.value = model2.puzzleFinishedTotal;
				progressView.textLabel.text = model2.puzzleFinishedTotal + "/" + model2.puzzleTotal;
			}
		}
		
		override protected function doValidateLayout():void {
			super.doValidateLayout();
			
			topCenter.width = topCenter.preferredSize.width;
			topCenter.height = topCenter.preferredSize.height;
			topCenter.x = (topCenter.preferredSize.width + width) >> 1;
			topCenter.y = 30;

			skillIcons.x = width - skillIcons.preferredSize.width - 100;
			skillIcons.y = height - skillIcons.preferredSize.height - 30;
			skillIcons.width = skillIcons.preferredSize.width;
			skillIcons.height = skillIcons.preferredSize.height;
		}
	}
}
