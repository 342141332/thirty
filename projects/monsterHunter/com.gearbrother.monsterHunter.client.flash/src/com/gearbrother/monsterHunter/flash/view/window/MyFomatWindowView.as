package com.gearbrother.monsterHunter.flash.view.window {
	import com.gearbrother.glash.display.event.GDndEvent;
	import com.gearbrother.monsterHunter.flash.GameMain;
	import com.gearbrother.monsterHunter.flash.command.GameCommandMap;
	import com.gearbrother.monsterHunter.flash.event.MonsterEvent;
	import com.gearbrother.monsterHunter.flash.model.GameModel;
	import com.gearbrother.monsterHunter.flash.model.HunterModel;
	import com.gearbrother.monsterHunter.flash.model.MonsterModel;
	import com.gearbrother.monsterHunter.flash.skin.window.MyFomatWindowSkin;
	import com.gearbrother.monsterHunter.flash.view.common.AvatarView;
	import com.gearbrother.monsterHunter.flash.view.common.MonsterAvatarView;
	import com.gearbrother.monsterHunter.flash.view.common.WindowView;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	

	/**
	 * @author feng.lee
	 * create on 2013-2-21
	 */
	public class MyFomatWindowView extends WindowView {
		private var _fomatArea:Sprite;
		
		private var _fomatLine:Shape;
		
		private var _fomatedMonsters:Array;
		
		public function MyFomatWindowView() {
			var skin:MyFomatWindowSkin = new MyFomatWindowSkin();
			super(skin);
			
			_neighbourWindowClazz = [MyFomatWindowView, MyMonsterWindowView];
			_fomatedMonsters = [];
			_fomatArea = skin.fomatArea;
			var bounds:Rectangle = _fomatArea.getBounds(this);
			_fomatLine = new Shape();
			_fomatLine.x = _fomatArea.x;
			_fomatLine.y = _fomatArea.y;
			skin.addChild(_fomatLine);
			_fomatLine.graphics.lineStyle(1, 0x0000FF);
			var r:int = 0;
			var c:int = 0;
			for (r = 0; r <= 5; r++) {
				c = 0;
				_fomatLine.graphics.moveTo(c * bounds.width / 5, r * bounds.height / 5);
				c = 5;
				_fomatLine.graphics.lineTo(c * bounds.width / 5, r * bounds.height / 5);
			}
			for (c = 0; c <= 5; c++) {
				r = 0;
				_fomatLine.graphics.moveTo(c * bounds.width / 5, r * bounds.height / 5);
				r = 5;
				_fomatLine.graphics.lineTo(c * bounds.width / 5, r * bounds.height / 5);
			}
			addEventListener(MouseEvent.MOUSE_DOWN, _handleMouseEvent);
			addEventListener(MouseEvent.MOUSE_MOVE, _handleMouseEvent);
			_fomatArea.addEventListener(GDndEvent.Drop, _handleMouseEvent);
			data = GameModel.instance.loginedUser;
		}

		override protected function doInit():void {
			super.doInit();
			
			stage.addEventListener(GDndEvent.Drop, _handleMouseEvent);
		}
		
		override public function handleModelChanged(events:Object = null):void {
			if (!events || events.hasOwnProperty(HunterModel.FOMATS)) {
				//clean pre
				while (_fomatedMonsters.length) {
					var monsterView:MonsterAvatarView = _fomatedMonsters.shift();
					monsterView.remove();
				}
				
				for each(var fomatedMonster:MonsterModel in GameModel.instance.loginedUser.fomats) {
					var view:MonsterAvatarView = new MonsterAvatarView();
					view.mouseEnabled = view.mouseChildren = false;
					view.data = fomatedMonster;
					view.direction = AvatarView.DIRECTION_RIGHT;
					var bounds:Rectangle = _fomatArea.getBounds(this);
					view.x = bounds.right - bounds.width * (fomatedMonster.fomat.x + .5) / 5;
					view.y = bounds.top + bounds.height * (fomatedMonster.fomat.y + .5) / 5;
					addChild(view);
					_fomatedMonsters.unshift(view);
				}
			}
		}
		
		private function _handleMouseEvent(event:Event):void {
			var bounds:Rectangle = _fomatArea.getBounds(this);
			var toFomatPt:Point = new Point(int((bounds.right - this.mouseX) / (bounds.width / 5))
				, int((this.mouseY - bounds.top) / (bounds.height / 5)));
//			if (toFomatPt.x > -1 && toFomatPt.x < 5 && toFomatPt.y > -1 && toFomatPt.y < 5 == false)
//				return;
			switch (event.type) {
				case MouseEvent.MOUSE_DOWN:
					var filterPositionView:Function = function(d:*, index:int, array:Array):Boolean {
						var avaterView:MonsterAvatarView = d as MonsterAvatarView;
						if (toFomatPt.equals((avaterView.data as MonsterModel).fomat))
							return true;
						else
							return false;
					}
					var onPositions:Array = _fomatedMonsters.filter(filterPositionView);
					if (onPositions.length > 0) {
						var onPosView:MonsterAvatarView = onPositions[0]
						GameMain.instance.dragLayer.dragData = onPosView.data;
						GameMain.instance.dragLayer.trigger = onPosView;
					}
					event.stopPropagation();
					break;
				case MouseEvent.MOUSE_MOVE:
					return;
					_fomatLine.graphics.beginFill(0x0000FF, .4);
					_fomatLine.graphics.drawRect((4 - toFomatPt.x) * bounds.width / 5, toFomatPt.y * bounds.height / 5, bounds.width / 5, bounds.height / 5);
					_fomatLine.graphics.endFill();
					break;
				case GDndEvent.Drop:
					var dropData:* = (event as GDndEvent).data;
					if (dropData is MonsterModel) {
						var fomat:MonsterModel = dropData as MonsterModel;
						var fomats:Array = GameModel.instance.loginedUser.fomats.concat();
						switch (event.currentTarget) {
							case _fomatArea:
								fomat.fomat = toFomatPt;
								fomats.push(fomat);
								GameCommandMap.instance._eventDispatcher.dispatchEvent(MonsterEvent.getSetFomatEvent(fomats));
								event.stopPropagation();
								break;
							case stage:
								fomat.fomat = null;
								var at:int = fomats.indexOf(fomat);
								if (at != -1)
									fomats.splice(at, 1);
								GameCommandMap.instance._eventDispatcher.dispatchEvent(MonsterEvent.getSetFomatEvent(fomats));
								break;
						}
					}
					break;
			}
		}
		
		override protected function doDispose():void {
			stage.removeEventListener(GDndEvent.Drop, _handleMouseEvent);

			super.doDispose();
		}
	}
}
