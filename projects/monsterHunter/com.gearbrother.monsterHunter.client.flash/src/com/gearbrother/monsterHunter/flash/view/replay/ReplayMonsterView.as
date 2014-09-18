package com.gearbrother.monsterHunter.flash.view.replay {
	import com.gearbrother.glash.common.resource.type.GAliasFile;
	import com.gearbrother.glash.common.resource.type.GDefinition;
	import com.gearbrother.glash.common.utils.GHandler;
	import com.gearbrother.glash.display.GSkinSprite;
	import com.gearbrother.glash.display.GSprite;
	import com.gearbrother.glash.display.container.GContainer;
	import com.gearbrother.glash.display.control.GLoader;
	import com.gearbrother.glash.display.control.text.GTextRender;
	import com.gearbrother.glash.display.layout.impl.EmptyLayout;
	import com.gearbrother.glash.display.layout.impl.FlowLayout;
	import com.gearbrother.glash.mvc.model.GBeanPropertyEvent;
	import com.gearbrother.glash.paper.display.layer.GPaperLayer;
	import com.gearbrother.monsterHunter.flash.model.MonsterModel;
	import com.gearbrother.monsterHunter.flash.model.ReplaySignalModel;
	import com.gearbrother.monsterHunter.flash.model.SkillModel;
	import com.gearbrother.monsterHunter.flash.view.common.MonsterAvatarView;
	import com.gearbrother.monsterHunter.flash.view.replay.oper.ReplaySignalOper;
	import com.gearbrother.monsterHunter.flash.view.scene.SceneReplayView;
	import com.gearbrother.monsterHunter.flash.view.skin.Fonts;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;


	/**
	 * @author 		lifeng
	 * @version 	1.0.0
	 * create on	2012-12-8 下午1:09:11
	 */
	public class ReplayMonsterView extends MonsterAvatarView {
		static public const label_playInjured:String = "playInjured";
		
		public var hp:int;

		public var mp:int;

		public var exp:int;

		public var level:int;

		public var nextLevel:int;

		public var buffLine:GContainer;

		public function get replayView():SceneReplayView {
			return layer.paper as SceneReplayView;
		}

		private var _signalView:ReplaySignalOper;

		public function set signalView(value:ReplaySignalOper):void {
			if (_signalView != value) {
				var highPriority:ReplaySignalOper;
				if (_signalView && value && value.priority > _signalView.priority) {
					highPriority = value;
				} else if (!_signalView && value) {
					highPriority = value;
				} else if (_signalView && !value) {
					highPriority = value;
				}

				if (_signalView != highPriority) {
					/*if (_signalView) {
						_signalView.kill();
					}*/
					logger.debug("{0} change action from {1} to {2}", [data, _signalView, highPriority]);
					_signalView = highPriority;
					if (_signalView)
						_signalView.execute();
				}
			}
		}

		public function get signalView():ReplaySignalOper {
			return _signalView;
		}

		override public function set data(value:*):void {
			if (!value is MonsterModel)
				throw new Error("only accept ReplayMonsterModel");

			super.data = value;
		}
		
		public function get actorModel():MonsterModel {
			return data as MonsterModel;
		}
		
		private var _propertyAnimation:TweenLite;
		
		private var hpMpBar:HpMpBar;

		public function ReplayMonsterView(layer:GPaperLayer = null) {
			super(layer);
			
			buffLine = new GContainer();
			hpMpBar = new HpMpBar();
			hpMpBar.x -= hpMpBar.width >> 1;
			hpMpBar.y = -70;
			addChild(hpMpBar);
		}
		
		override public function handleModelChanged(events:Object=null):void {
			if (!events || events.hasOwnProperty(MonsterModel.BASE_HP)) {
				var event:GBeanPropertyEvent = events[MonsterModel.BASE_HP];
				hpMpBar.hpProgress.minValue = 0;
				hpMpBar.hpProgress.value = hpMpBar.hpProgress.maxValue = model.hp;
				hpMpBar.mpProgress.minValue = 0;
				hpMpBar.mpProgress.value = hpMpBar.mpProgress.maxValue = model.mp;

				//when hp changed, popup number
				/*var popHp:GRichText = new GRichText(new TextField());
				popHp.autoSize = TextFieldAutoSize.LEFT;
				popHp.wordWrap = false;
				popHp.font = Fonts.FONT_POPUP_HP;
				popHp.fontSize = 27;
				popHp.text = event.oldValue - event.newValue;
				var render:GTextRender = new GTextRender(0xcccc33, 0xcc6633);
				popHp.textRender = render;
				popHp.filters = [new GlowFilter(0xFFFFFF, 1, 2, 2, 2000), new DropShadowFilter(0, 0, 0x000000, 1, 3, 3, 500)];
				popHp.applyTextFormat(new TextFormat("Impact"));
				popHp.alpha = .0;
				addChild(popHp);
				hpMpBar.hpProgress.value = event.newValue;
				TweenLite.to(popHp, .3, {alpha: 1.0, y: -100, onComplete: onHpPop, onCompleteParams: [popHp]});*/
			}
		}
		
		private function onHpPop(display:DisplayObject):void {
			display.parent.removeChild(display);
		}
		
		override public function tick(interval:int):void {
			movie.tick(interval);
		}
	}
}
import com.gearbrother.glash.display.GSkinSprite;
import com.gearbrother.glash.display.control.GProgress;
import com.gearbrother.monsterHunter.flash.skin.HPMPSkin;

import flash.display.DisplayObject;

class HpMpBar extends GSkinSprite {
	public var hpProgress:GProgress;
	
	public var mpProgress:GProgress;
	
	public function HpMpBar() {
		super(new HPMPSkin());
		
		hpProgress = new GProgress(skin["hp_progress"]);
		mpProgress = new GProgress(skin["mp_progress"]);
	}
}