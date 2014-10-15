package com.gearbrother.sheepwolf.view.layer.scene.battle {
	import com.gearbrother.glash.common.oper.ext.GAliasFile;
	import com.gearbrother.glash.common.oper.ext.GBmdDefinition;
	import com.gearbrother.glash.common.oper.ext.GDefinition;
	import com.gearbrother.glash.common.utils.GHandler;
	import com.gearbrother.glash.display.GMovieBitmap;
	import com.gearbrother.glash.display.control.GProgress;
	import com.gearbrother.glash.display.control.text.GText;
	import com.gearbrother.glash.display.filter.GFilter;
	import com.gearbrother.sheepwolf.model.BattleBuffModel;
	import com.gearbrother.sheepwolf.model.BattleColorModel;
	import com.gearbrother.sheepwolf.model.BattleItemUserModel;
	import com.gearbrother.sheepwolf.model.BattleUserActionSkillUsingModel;
	import com.gearbrother.sheepwolf.model.BattleUserActionWalkModel;
	import com.gearbrother.sheepwolf.model.GameModel;
	import com.gearbrother.sheepwolf.model.IBattleItemModel;
	import com.gearbrother.sheepwolf.rpc.protocol.bussiness.BattleItemUserProtocol;
	import com.gearbrother.sheepwolf.view.common.ui.AvatarView;
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextFieldAutoSize;


	/**
	 * @author lifeng
	 * @create on 2013-12-15
	 */
	public class BattleItemUserSceneView extends BattleItemSceneView {
		private var _invisibleHandle:GHandler = new GHandler(function():void {
			var battleUser:BattleItemUserModel = bindData;
			var invisibleBuf:BattleBuffModel = battleUser.buffs[BattleBuffModel.INVISIBLE];
			if (battleUser.battle.loginedBattleUser) {
				if (battleUser.battle.loginedBattleUser.color == battleUser.color) {
					alpha = invisibleBuf.expiredPeriod > GameModel.instance.application.serverTime ? .3 : 1.0;
				} else {
					visible = invisibleBuf.expiredPeriod > GameModel.instance.application.serverTime ? false : true;
				}
			} else {
				alpha = invisibleBuf.expiredPeriod > GameModel.instance.application.serverTime ? .3 : 1.0;
			}
		});
		
		private var _direction:int;
		public function set direction(newValue:int):void {
			_direction = newValue;
			switch (_direction) {
				case BattleUserActionWalkModel.DIRECTION_DOWN:
					if (aim)
						aim.rotation = 90;
					break;
				case BattleUserActionWalkModel.DIRECTION_LEFT:
					if (aim)
						aim.rotation = 180;
					break;
				case BattleUserActionWalkModel.DIRECTION_RIGHT:
					if (aim)
						aim.rotation = 0;
					break;
				case BattleUserActionWalkModel.DIRECTION_UP:
					if (aim)
						aim.rotation = 270;
					break;
			}
		}
		
		public var aim:WeaponSliceAimView;

		public function set aimVisible(newValue:Boolean):void {
			if (newValue) {
				addChild(aim = new WeaponSliceAimView());
				aim.x = width >> 1;
				aim.y = height >> 1;
			}
		}
		
		public function get model():BattleItemUserModel {
			return bindData;
		}
		
		/*private var _hintView:Hint;
		public function set hint(newValue:String):void {
			if (newValue) {
				_hintView ||= new Hint();
				_hintView.label.text = newValue;
			} else {
				if (_hintView) {
					removeChild(_hintView);
					_hintView = null;
				}
			}
		}*/
		
		public var nameLabel:GText;
		
		private var _currentAction:Object;
		
		public var progressView:ProgressView;
		
		private var _pickedItemView:GMovieBitmap;
		
		protected var _lastPosition:Point;
		
		public function BattleItemUserSceneView(model:BattleItemUserModel) {
			super(model);
			
			addChild(nameLabel = new GText());
			nameLabel.autoSize = TextFieldAutoSize.LEFT;
			nameLabel.y = -47;
			nameLabel.fontSize = 11;
			nameLabel.fontColor = model.color == BattleColorModel.WOLF ? 0xff0000 : 0x00FFCC;
			nameLabel.filters = [new GlowFilter(0x000000, 1, 4, 4, 300)];
			
			progressView = new ProgressView();
			_direction = model.direction;
//			aimVisible = true;
			_lastPosition = new Point(model.battle.cellPixel * model.x, model.battle.cellPixel * model.y);
			_oldProperties[BattleItemUserProtocol.ORGINAL_SPEED] = model.orginalSpeed;
			_oldProperties[BattleItemUserProtocol.MONEY] = model.money;
		}

		override public function handleModelChanged(events:Object = null):void {
			super.handleModelChanged(events);

			var model:BattleItemUserModel = bindData;
			if (!events
				|| events.hasOwnProperty(BattleItemUserProtocol.LIFES)
				|| events.hasOwnProperty(BattleItemUserProtocol.LEVEL)
				|| events.hasOwnProperty(BattleItemUserProtocol.MONEY)) {
				nameLabel.text = "Lv." + model.level + " " + model.name + ", life:" + model.lifes + ", Money:" + model.money;
			}
			if (!events || events.hasOwnProperty(BattleItemUserProtocol.CURRENT_ACTION)) {
				_currentAction = model.currentAction;
				if (_currentAction is BattleUserActionWalkModel) {
					direction = (_currentAction as BattleUserActionWalkModel).startFaceTo;
				}
			}
			if (!events || events.hasOwnProperty(BattleItemUserProtocol.IS_CAPTURED)) {
				if (model.isCaptured)
					GFilter.decolor.apply(_avatar);
				else
					GFilter.decolor.unapply(_avatar);
			}
			if (!events || events.hasOwnProperty(BattleItemUserProtocol.MONEY)) {
				var changedMoney:Number = model.money - _oldProperties[BattleItemUserProtocol.MONEY];
				if (changedMoney > 0) {
					popup("+ " + changedMoney.toFixed(1) + " 金币", 0x66cc00);
				} else if (changedMoney < 0) {
					popup(changedMoney.toFixed(1) + " 金币", 0xff3333);
				}
				_oldProperties[BattleItemUserProtocol.MONEY] = model.orginalSpeed;
			}
			if (events && events.hasOwnProperty(BattleItemUserProtocol.ORGINAL_SPEED)) {
				var changedSpeed:Number = model.orginalSpeed - _oldProperties[BattleItemUserProtocol.ORGINAL_SPEED];
				if (changedSpeed > 0) {
					popup("+ " + changedSpeed.toFixed(1) + " 速度", 0x66cc00);
				} else if (changedSpeed < 0) {
					popup(changedSpeed.toFixed(1) + " 速度", 0xff3333);
				}
				_oldProperties[BattleItemUserProtocol.ORGINAL_SPEED] = model.orginalSpeed;
			}
			if (!events || events.hasOwnProperty(BattleItemUserProtocol.PICK_UPED_PUZZLE)) {
				if (_pickedItemView) {
					removeChild(_pickedItemView);
					_pickedItemView = null;
				}
				if (model.pickUpedPuzzle) {
					var movie:GMovieBitmap = new GMovieBitmap();
					movie.definition = new GBmdDefinition(new GDefinition(new GAliasFile(model.pickUpedPuzzle.cartoon), "Value"));
					_pickedItemView = movie;
					movie.x = model.width * model.battle.cellPixel >> 1;
					movie.y = -30;
					addChild(_pickedItemView);
				}
			}
		}

		override public function tick(interval:int):void {
			var model:BattleItemUserModel = bindData;
			if (_lastPosition.x == x && _lastPosition.y == y) {
				switch (_direction) {
					case BattleUserActionWalkModel.DIRECTION_DOWN:
						_avatar.setLabel("standDown");
						_avatar.scaleX = 1;
						break;
					case BattleUserActionWalkModel.DIRECTION_LEFT:
						_avatar.setLabel("standLeft");
						_avatar.scaleX = 1;
						break;
					case BattleUserActionWalkModel.DIRECTION_RIGHT:
						_avatar.setLabel("standLeft");
						_avatar.scaleX = -1;
						break;
					case BattleUserActionWalkModel.DIRECTION_UP:
						_avatar.setLabel("standUp");
						_avatar.scaleX = 1;
						break;
				}
			} else {
				if (x > _lastPosition.x) {
					_avatar.setLabel("moveRight");
					_avatar.scaleX = -1;
					direction = BattleUserActionWalkModel.DIRECTION_RIGHT;
				} else if (x < _lastPosition.x) {
					_avatar.setLabel("moveLeft");
					_avatar.scaleX = 1;
					direction = BattleUserActionWalkModel.DIRECTION_LEFT;
				} else if (y > _lastPosition.y) {
					_avatar.setLabel("moveDown");
					_avatar.scaleX = 1;
					direction = BattleUserActionWalkModel.DIRECTION_DOWN;
				} else if (y < _lastPosition.y) {
					_avatar.setLabel("moveUp");
					_avatar.scaleX = 1;
					direction = BattleUserActionWalkModel.DIRECTION_UP;
				}
			}
			_lastPosition.x = x;
			_lastPosition.y = y;

			if (progressView.parent)
				removeChild(progressView);
			if (model.currentAction is BattleUserActionWalkModel) {
				var walk:BattleUserActionWalkModel = model.currentAction as BattleUserActionWalkModel;
				var pt:Point = walk.getPoint(model, model.battle, GameModel.instance.application.serverTime);
				model.x = pt.x;
				model.y = pt.y;
				x = model.x * model.battle.cellPixel;
				y = model.y * model.battle.cellPixel;
			} else if (model.currentAction is BattleUserActionSkillUsingModel) {
				var eatGrass:BattleUserActionSkillUsingModel = model.currentAction as BattleUserActionSkillUsingModel;
				eatGrass.battleUser = model;
				eatGrass.process();
				if (GameModel.instance.application.serverTime < eatGrass.currentTime + eatGrass.skill.level.preUseCause) {
					if (!progressView.parent)
						addChild(progressView);
					progressView.y = model.battle.cellPixel + 7;
					progressView.minValue = eatGrass.currentTime;
					progressView.maxValue = eatGrass.currentTime + eatGrass.skill.level.preUseCause;
					progressView.value = GameModel.instance.application.serverTime;
				}
			}
		}
	}
}
import com.gearbrother.glash.display.GDisplaySprite;
import com.gearbrother.glash.display.GNoScale;
import com.gearbrother.glash.display.GSkinSprite;
import com.gearbrother.glash.display.container.GBackgroundContainer;
import com.gearbrother.glash.display.control.GProgress;
import com.gearbrother.glash.display.control.text.GText;
import com.gearbrother.glash.util.display.GPen;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Shape;
import flash.text.TextField;


/**
 * @author lifeng
 * @create on 2014-1-16
 */
class WeaponSliceAimView extends GDisplaySprite {
	private var _pen:GPen;

	public function WeaponSliceAimView() {
		super();

		_pen = new GPen(this.graphics);
		_pen.clear();
		_pen.lineStyle(0, 0, 0);
		_pen.beginFill(0xff0000, .2);
		var slice:int = 60;
		_pen.drawSlice(slice, 32 * 1.5, -slice >> 1, 0, 0);
	}
}

class ProgressView extends GProgress {
	public function ProgressView() {
		var shape:Shape = new Shape();
		shape.graphics.beginFill(0xcccc00);
		shape.graphics.drawRect(0, 0, 30, 3);
		shape.graphics.endFill();
		super(shape);
	}
}

class Hint extends GBackgroundContainer {
	public function get label():GText {
		return content as GText;
	}
	
	public function Hint(skin:DisplayObjectContainer) {
		super(skin);
		
		content = new GText(skin["label"]);
	}
}