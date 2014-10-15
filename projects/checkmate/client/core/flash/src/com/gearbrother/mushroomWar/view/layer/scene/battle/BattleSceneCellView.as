package com.gearbrother.mushroomWar.view.layer.scene.battle
{
	import com.gearbrother.glash.common.oper.ext.GAliasFile;
	import com.gearbrother.glash.common.oper.ext.GBmdDefinition;
	import com.gearbrother.glash.common.oper.ext.GDefinition;
	import com.gearbrother.glash.common.oper.ext.GFile;
	import com.gearbrother.glash.display.GMovieBitmap;
	import com.gearbrother.glash.display.GSprite;
	import com.gearbrother.glash.display.filter.GFilter;
	import com.gearbrother.glash.display.propertyHandler.GPropertyFlickerHandler;
	import com.gearbrother.mushroomWar.GameMain;
	import com.gearbrother.sheepwolf.model.BattleItemGiftModel;
	import com.gearbrother.sheepwolf.model.BattleItemPuzzleModel;
	import com.gearbrother.mushroomWar.model.GameModel;
	import com.gearbrother.sheepwolf.rpc.protocol.bussiness.BattleCollisionProtocol;
	import com.gearbrother.sheepwolf.view.GameSkin;
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.filters.DropShadowFilter;
	import flash.filters.ShaderFilter;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	/**
	 *
	 * @author 	Neo.Zhang
	 * @create 	2014-7-24 下午6:19:44
	 *
	 */
	public class BattleSceneCellView extends GSprite {
		private var _contentView:DisplayObject;
		
		private var _giftView:DisplayObject;
		
		private var _flickerHandler:GPropertyFlickerHandler;
		public function set flicker(newValue:int):void {
			_flickerHandler ||= new GPropertyFlickerHandler(this);
			_flickerHandler.value = newValue;
		}
		
		private var _oldCellData:Object;
		
		private var _bright:Boolean;
		private var _brightTween:TweenMax;
		public function get bright():Boolean {
			return _bright;
		}
		public function set bright(newValue:Boolean):void {
			if (_bright != newValue) {
				_bright = newValue;
				if (!numChildren)
					return;
				if (_bright) {
					_brightTween ||= TweenMax.to(this, .5, {colorTransform: {brightness: 1.1}, yoyo: true, repeat: -1});
				} else if (_brightTween) {
					_brightTween.kill({colorTransform: {brightness: 1}});
					var colorTransform:ColorTransform = this.transform.colorTransform;
					colorTransform.blueMultiplier = colorTransform.redMultiplier = colorTransform.greenMultiplier = 1;
					colorTransform.blueOffset = colorTransform.redOffset = colorTransform.greenOffset = 0;
					this.transform.colorTransform = colorTransform;
					_brightTween = null;
				}
			}
		}
		
		public function BattleSceneCellView(cell:BattleCollisionProtocol) {
			super();
			
			this.bindData = cell;
			cacheAsBitmap = true;
		}
		
		override public function handleModelChanged(events:Object=null):void {
			var cell:BattleCollisionProtocol = bindData as BattleCollisionProtocol;
		}
	}
}