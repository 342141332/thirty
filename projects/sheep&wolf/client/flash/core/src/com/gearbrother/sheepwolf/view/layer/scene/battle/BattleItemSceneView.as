package com.gearbrother.sheepwolf.view.layer.scene.battle {
	import com.gearbrother.glash.common.oper.ext.GAliasFile;
	import com.gearbrother.glash.common.oper.ext.GBmdDefinition;
	import com.gearbrother.glash.common.oper.ext.GDefinition;
	import com.gearbrother.glash.display.GMovieBitmap;
	import com.gearbrother.glash.display.GSkinSprite;
	import com.gearbrother.glash.display.control.GProgress;
	import com.gearbrother.glash.display.control.text.GText;
	import com.gearbrother.glash.display.filter.GFilter;
	import com.gearbrother.sheepwolf.model.BattleItemUserModel;
	import com.gearbrother.sheepwolf.model.IBattleItemModel;
	import com.gearbrother.sheepwolf.rpc.protocol.bussiness.BattleItemProtocol;
	import com.gearbrother.sheepwolf.rpc.protocol.bussiness.BattleItemUserProtocol;
	import com.gearbrother.sheepwolf.view.common.ui.AvatarView;
	import com.greensock.TweenLite;
	
	import flash.display.Shape;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;


	/**
	 *
	 * @author 	Neo.Zhang
	 * @create 	2014-7-28 下午5:46:29
	 *
	 */
	public class BattleItemSceneView extends GSkinSprite {
		static public const coupleFilter:GFilter = new GFilter(new DropShadowFilter(0, 0, 0xFDCE1E, 1, 3, 3, 200));
		
		private var _brightFilter:GFilter = GFilter.getBright(170);
		
		private var _unBrightDelayID:int;
		
		public var hp:GProgress;
		
		protected var _avatar:AvatarView;
		
		protected var _oldProperties:Object;

		public function BattleItemSceneView(model:IBattleItemModel) {
			super();

			bindData = model;
			this.graphics.beginFill(0xffffff, .1);
			this.graphics.drawRect(0, 0, model.battle.cellPixel * model.width, model.battle.cellPixel * model.height);
			this.graphics.endFill();
			
			addChildAt(_avatar = new AvatarView(), 0);
			_avatar.enableTick = false;
			_avatar.x = model.battle.cellPixel >> 1;
			_avatar.y = model.battle.cellPixel >> 1;

			if (model.isDestoryable) {
				var progressSkin:Shape = new Shape();
				progressSkin.graphics.beginFill(0x00cc00, 1);
				progressSkin.graphics.drawRect(0, 0, model.width * model.battle.cellPixel, 2);
				progressSkin.graphics.endFill();
				addChild(hp = new GProgress(progressSkin));
				hp.filters = [new GlowFilter(0x000000, 1, 4, 4, 300)];
				hp.maxValue = model.maxHp;
				hp.minValue = 0;
				hp.value = model.hp;
				hp.x = 0;
				hp.y = -23;
				_oldProperties = {};
				_oldProperties[BattleItemUserProtocol.HP] = model.hp;
			}
		}

		override public function handleModelChanged(events:Object=null):void {
			var model:IBattleItemModel = bindData;
			if (!events) {
				if (model is IBattleItemModel) {
					var movie:GMovieBitmap = _addMovie((model as IBattleItemModel).cartoon);
					movie.x = model.width * model.battle.cellPixel >> 1;
					movie.y = model.height * model.battle.cellPixel >> 1;
				} else {
					throw new Error("unknown item");
				}
			}
			if (events && (events.hasOwnProperty(BattleItemProtocol.HP) || events.hasOwnProperty(BattleItemProtocol.MAX_HP))) {
				if (model.isDestoryable) {
					var changedHp:int = model.hp - _oldProperties[BattleItemUserProtocol.HP];
					if (changedHp > 0) {
						popup("+ " + changedHp + " HP", 0x66cc00);
					} else if (changedHp < 0) {
						popup(changedHp + " HP", 0xff3333);
					}
					hp.maxValue = model.maxHp;
					_oldProperties[BattleItemUserProtocol.HP] = hp.value = model.hp;
					_brightFilter.apply(_avatar);
					clearTimeout(_unBrightDelayID);
					_unBrightDelayID = setTimeout(_brightFilter.unapply, 200, _avatar);
				}
			}
		}

		protected function _addMovie(file:String):GMovieBitmap {
			_avatar = new AvatarView();
			_avatar.definition = new GBmdDefinition(new GDefinition(new GAliasFile(file), "Value"));
			addChildAt(_avatar, 0);
			return _avatar;
		}
		
		private var _texts:Array;
		public function popup(text:String, fontColor:uint = 0xffffff, fontSize:int = 13):void {
			_texts ||= [];
			_texts.push({"text": text, "fontColor": fontColor, "fontSize": fontSize});
			refreshTimer = 500;
		}
		
		override public function refresh(time:int):void {
			if (_texts.length) {
				var msg:Object = _texts.shift();
				var popup:GText = new GText();
				popup.fontBold = true;
				popup.text = msg.text;
				popup.fontColor = msg.fontColor;
				popup.fontSize = msg.fontSize;
				popup.filters = [new GlowFilter(0x000000, 1, 3, 3, 300)];
				addChild(popup);
				TweenLite.to(popup, 1.3, {y: - 70, alpha: .1, onComplete: removeChild, onCompleteParams: [popup]});
			} else {
				refreshTimer = 0;
			}
		}
	}
}
