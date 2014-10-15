package com.gearbrother.monsterHunter.flash.view.layer {
	import com.gearbrother.glash.display.container.GContainer;
	import com.gearbrother.glash.display.container.GHBox;
	import com.gearbrother.glash.display.layout.impl.BorderLayout;
	import com.gearbrother.glash.display.layout.impl.CenterLayout;
	import com.gearbrother.glash.mvc.model.GBeanPropertyEvent;
	import com.gearbrother.monsterHunter.flash.model.GameModel;
	import com.gearbrother.monsterHunter.flash.model.HunterModel;
	import com.gearbrother.monsterHunter.flash.skin.mainUI.ActionSkin;
	import com.gearbrother.monsterHunter.flash.skin.mainUI.GoldSkin;
	import com.gearbrother.monsterHunter.flash.skin.mainUI.SilverSkin;
	import com.gearbrother.monsterHunter.flash.view.mainUI.UiMainToolbar;
	
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;


	/**
	 * @author 		lifeng
	 * @version 	1.0.0
	 * create on	2012-12-7 下午11:23:56
	 */
	public class UiLayer extends GContainer {
		private var _top:GContainer;

		private var _topNumericBar:GHBox;
		
		private var _bottom:GContainer;

		private var _gold:NumericLabel;
		
		private var _silver:NumericLabel;
		
		private var _action:NumericLabel;

		public var toolbar:UiMainToolbar;

		public function UiLayer() {
			super();

			layout = new BorderLayout();

			_top = new GContainer();
			_top.layout = new CenterLayout();
			append(_top, BorderLayout.NORTH);
			_topNumericBar = new GHBox();
			_topNumericBar.addChild(_gold = new NumericLabel(new GoldSkin()));
			_topNumericBar.addChild(_silver = new NumericLabel(new SilverSkin()));
			_topNumericBar.addChild(_action = new NumericLabel(new ActionSkin()));
			_silver.filters = _action.filters = _gold.filters
				= [new GlowFilter(0xFFFFFF, 1, 2, 2, 2000), new DropShadowFilter(0, 0, 0x000000, 1, 3, 3, 500)];
			_top.append(_topNumericBar);

			_bottom = new GContainer();
			_bottom.layout = new BorderLayout();
			_bottom.append(toolbar = new UiMainToolbar(), BorderLayout.EAST);
			toolbar.btns = [UiMainToolbar.BTN_MONSTER, UiMainToolbar.BTN_BAG, UiMainToolbar.BTN_FOMAT, UiMainToolbar.BTN_MAP];
			append(_bottom, BorderLayout.SOUTH);
		}
		
		override protected function doInit():void {
			super.doInit();
			
			GameModel.instance.loginedUser.addEventListener(GBeanPropertyEvent.PROPERTY_CHANGE, _handleBeanEvent);
			_handleBeanEvent();
		}
		
		private function _handleBeanEvent(event:GBeanPropertyEvent = null):void {
			if (!event || event.propertyKey == HunterModel.GOLD)
				_gold.text.value = GameModel.instance.loginedUser.gold;
			if (!event || event.propertyKey == HunterModel.SILVER)
				_silver.text.value = GameModel.instance.loginedUser.silver;
			if (!event || event.propertyKey == HunterModel.ACTION_POINT)
				_action.text.value = GameModel.instance.loginedUser.actionPoint;
		}
	}
}
import com.gearbrother.glash.display.GSkinSprite;
import com.gearbrother.glash.display.control.text.GNumeric;
import com.gearbrother.glash.display.control.text.GText;
import com.gearbrother.glash.util.display.GSearchUtil;

import flash.display.DisplayObject;
import flash.text.TextField;

class NumericLabel extends GSkinSprite {
	public var text:GText;
	
	public var icon:DisplayObject;
	
	public function NumericLabel(skin:DisplayObject) {
		super(skin);
		
		text = new GText(GSearchUtil.findChildByClass(skin, TextField));
	}
}