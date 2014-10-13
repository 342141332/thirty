package com.gearbrother.monsterHunter.flash.view.scene {
	import com.gearbrother.glash.common.resource.type.GAliasFile;
	import com.gearbrother.glash.common.resource.type.GBmdDefinition;
	import com.gearbrother.glash.common.resource.type.GDefinition;
	import com.gearbrother.glash.common.resource.type.GFile;
	import com.gearbrother.glash.common.utils.GHandler;
	import com.gearbrother.glash.display.GMovieBitmap;
	import com.gearbrother.glash.display.GMovieClip;
	import com.gearbrother.glash.display.IGDatable;
	import com.gearbrother.glash.display.event.GDndEvent;
	import com.gearbrother.glash.media.GSoundChannel;
	import com.gearbrother.glash.paper.GPaper;
	import com.gearbrother.glash.paper.control.MoveTask;
	import com.gearbrother.glash.paper.display.GPaperLayerBackground;
	import com.gearbrother.glash.paper.display.layer.GPaperLayer;
	import com.gearbrother.glash.paper.sort.SortYManager;
	import com.gearbrother.glash.util.math.GRandomUtil;
	import com.gearbrother.monsterHunter.flash.GameMain;
	import com.gearbrother.monsterHunter.flash.command.GameCommandMap;
	import com.gearbrother.monsterHunter.flash.event.ExploreMapEvent;
	import com.gearbrother.monsterHunter.flash.model.ExploreMapModel;
	import com.gearbrother.monsterHunter.flash.model.GameModel;
	import com.gearbrother.monsterHunter.flash.model.HunterModel;
	import com.gearbrother.monsterHunter.flash.model.MonsterModel;
	import com.gearbrother.monsterHunter.flash.skin.common.MoveHitSkin;
	import com.gearbrother.monsterHunter.flash.view.common.AvatarView;
	import com.gearbrother.monsterHunter.flash.view.common.HunterAvatarView;
	import com.gearbrother.monsterHunter.flash.view.common.MonsterAvatarView;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * @author feng.lee
	 * create on 2013-1-29
	 */
	public class SceneExploreMapView extends GPaper {
		private var _sound:GSoundChannel;
		
		private var _backgroundUpLayer:GPaperLayerBackground;

		private var _backgroundLowLayer:GPaperLayerBackground;
		
		private var _backgroundProLayer:GPaperLayerBackground;
		
		private var _myAvatar:HunterAvatarView;
		
		private var _myFollow:MonsterAvatarView;

		private var _avatarlayer:AvatarLayer;
		
		private var _moveHitLayer:MoveHitLayer;
		
		private var _wildMonsters:Array;
		
		private var _otherHunters:Array;
		
		private var _moveHit:Sprite;
		
		private var _exit:GMovieBitmap;

		private var _exit2:GMovieBitmap;
		
		static public var lastScene:ExploreMapModel;
		
		public function get model():ExploreMapModel {
			return data as ExploreMapModel;
		}

		override public function set data(newValue:*):void {
			if (!newValue is ExploreMapModel)
				throw new Error("only accept ExploreMapModel");
			super.data = newValue;
			lastScene = newValue;
			_backgroundLowLayer.definition = new GBmdDefinition(new GDefinition(model.backgoundSrc, "BMD_LOW"));
			_backgroundUpLayer.definition = new GBmdDefinition(new GDefinition(model.backgoundSrc, "BMD_UP"));
			_backgroundProLayer.definition = new GBmdDefinition(new GDefinition(model.backgoundSrc, "BMD_PRO"));
			for each (var monster:MonsterModel in model.monsters) {
				var monsterView:MonsterAvatarView = new MonsterAvatarView(_avatarlayer);
				monsterView.x = monster.mapPosition.x;
				monsterView.y = monster.mapPosition.y;
				monsterView.emotion = "sleep";
				monsterView.data = monster;
				monsterView.direction = AvatarView.DIRECTION_LEFT;
				_avatarlayer.addChild(monsterView);
				_wildMonsters.push(monsterView);
			}
			_createRobots();
		}
		
		private function _createRobots():void {
			for each (var hunterModel:HunterModel in model.hunters) {
				var hunterView:HunterAvatarView = new HunterAvatarView(_avatarlayer);
				hunterView.data = hunterModel;
				hunterView.x = GRandomUtil.integer(500, 2000);
				hunterView.y = GRandomUtil.integer(400, 600);
				hunterView.direction = GRandomUtil.choose([AvatarView.DIRECTION_LEFT, AvatarView.DIRECTION_RIGHT]);
				_avatarlayer.addChild(hunterView);
				var follow:MonsterAvatarView = new MonsterAvatarView();
				follow.enableTick = false;
				follow.data = hunterModel.followMonster;
				follow.task = new FollowTask(follow, hunterView, 100);
				follow.x = hunterView.x;
				follow.y = hunterView.y;
				_avatarlayer.addChild(follow);
				hunterView.follow = follow;
				_otherHunters.unshift(hunterView);
			}
		}

		public function SceneExploreMapView() {
			super();

			_otherHunters = [];
			_wildMonsters = [];
//			refreshSeconds = 2;
			camera.bound.width = 2500;
			camera.bound.height = 650;

			addChild(_backgroundLowLayer = new GPaperLayerBackground(camera, .3));

			_backgroundUpLayer = new GPaperLayerBackground(camera, 1);
			addChild(_backgroundUpLayer);

			_avatarlayer = new AvatarLayer(this);
			addChild(_avatarlayer);
			
			_backgroundProLayer = new GPaperLayerBackground(camera, .7);
			addChild(_backgroundProLayer);
			
			_myAvatar = new HunterAvatarView();
			_myAvatar.enableTick = false;
			_myAvatar.data = GameModel.instance.loginedUser;
			_myAvatar.x = 300;
			_myAvatar.y = 500;
			_avatarlayer.addChild(_myAvatar);
			camera.focus = _myAvatar;
			_myFollow = new MonsterAvatarView();
			_myFollow.enableTick = false;
			_myFollow.data = GameModel.instance.loginedUser.followMonster;
			_myFollow.task = new FollowTask(_myFollow, _myAvatar, 100);
			_myFollow.x = 300;
			_myFollow.y = 400;
			_avatarlayer.addChild(_myFollow);
			_myAvatar.follow = _myFollow;
			
			_exit = new GMovieBitmap(10);
			var defintion:GBmdDefinition = new GBmdDefinition(new GDefinition(new GFile("asset/avatar/exit.swf"), "Stand", null, {scaleY: .2}));
			_exit.definition = defintion;
			_exit.x = 200;
			_exit.y = 500;
			var map:ExploreMapModel = new ExploreMapModel();
			map.id = 1;
			_exit.data = map;
			_avatarlayer.addChild(_exit);

			_exit2 = new GMovieBitmap(10);
			defintion = new GBmdDefinition(new GDefinition(new GFile("asset/avatar/exit2.swf"), "Stand", null, {scaleX: .7, scaleY: .2}));
			_exit2.definition = defintion;
			_exit2.x = 2200;
			_exit2.y = 500;
			map = new ExploreMapModel();
			map.id = 2;
			_exit2.data = map;
			_avatarlayer.addChild(_exit2);
			
			_moveHitLayer = new MoveHitLayer(this);
			addChild(_moveHitLayer);
			_moveHit = new GMovieClip(new MoveHitSkin(), 20);

			addEventListener(MouseEvent.CLICK, _handleMouseEvent);
			addEventListener(GDndEvent.Drop, _handleMouseDrop);
			_sound = new GSoundChannel();
			enableTick = true;
		}
		
		override protected function doInit():void {
			super.doInit();
			
			_sound.playURL(new GAliasFile("sound/fight.mp3").url, -1, 1);
		}

		override public function tick(interval:int):void {
			_avatarlayer.tick(interval);
			_backgroundUpLayer.tick(interval);
			_backgroundLowLayer.tick(interval);
			_backgroundProLayer.tick(interval);
			_moveHitLayer.tick(interval);
		}
		
		public function refresh():void {
			var picked:HunterAvatarView = GRandomUtil.pickRandom(_otherHunters);
			var dest:Array = [new Point(_exit.x + GRandomUtil.integer(-40, 40), _exit.y + GRandomUtil.integer(-30, 30))
				, new Point(_exit2.x + GRandomUtil.integer(-40, 40), _exit2.y + GRandomUtil.integer(-30, 30))
				, ];
			for each (var wildMonster:MonsterAvatarView in _wildMonsters) {
				dest.push(new Point(wildMonster.x + picked.x > wildMonster.x ? 100 : -100, wildMonster.y));
			}
			picked.task = new MoveTask([new Point(picked.x, picked.y), GRandomUtil.pickRandom(dest)], 150, picked);
		}
		
		private function _handleMouseEvent(event:Event):void {
			var underMouse:DisplayObject = _avatarlayer.underMouse;
			var leftTop:Point = new Point(camera.screenRect.x, camera.screenRect.y);
			var toPt:Point = leftTop.add(new Point(this.mouseX, this.mouseY));
			_moveHit.x = toPt.x;
			_moveHit.y = toPt.y;
			_moveHitLayer.addChild(_moveHit);
			function arriveAt(pt:Point):void {
				if (underMouse is IGDatable) {
					var mouseHit:* = (underMouse as IGDatable).data;
					if (mouseHit is MonsterModel) {
						GameCommandMap.instance._eventDispatcher.dispatchEvent(
							ExploreMapEvent.getHuntEvent(model.id, ((underMouse as IGDatable).data as MonsterModel).id)
						);
					} else if (mouseHit is ExploreMapModel) {
						GameCommandMap.instance._eventDispatcher.dispatchEvent(
							ExploreMapEvent.getGetEvent((mouseHit as ExploreMapModel).id)
						);
					} else if (mouseHit is HunterModel) {
						GameCommandMap.instance._eventDispatcher.dispatchEvent(
							ExploreMapEvent.getFightEvent((mouseHit as HunterModel).id)
						);
					}
				}
				_moveHit.parent.removeChild(_moveHit);
			}
			_myAvatar.task = new MoveTask([new Point(_myAvatar.x, _myAvatar.y), toPt], 150, _myAvatar, null, null, new GHandler(arriveAt, [new Point(toPt.x, toPt.y)]));
		}
		
		private function _handleMouseDrop(event:GDndEvent):void {
			if (event.data is MonsterModel)
				_myFollow.data = event.data;
		}
		
		override protected function doValidateLayout():void {
			super.doValidateLayout();
			
			this.graphics.beginFill(0x000000, .0);
			this.graphics.drawRect(0, 0, width, height);
			this.graphics.endFill();
		}
		
		override protected function doDispose():void {
			_sound.stop(1);
			
			super.doDispose();
		}
	}
}
import com.gearbrother.glash.display.GSkinSprite;
import com.gearbrother.glash.paper.display.layer.GPaperLayer;
import com.gearbrother.monsterHunter.flash.view.common.MonsterAvatarView;

import flash.events.MouseEvent;

class ExploreMapMonsterView extends MonsterAvatarView {

	public function ExploreMapMonsterView(layer:GPaperLayer = null) {
		super(layer);
	}
}

import com.gearbrother.glash.paper.display.IGPaperTask;
import com.gearbrother.monsterHunter.flash.view.common.AvatarView;

import flash.display.DisplayObject;
import flash.geom.Point;


/**
 * @author feng.lee
 * create on 2012-10-16 下午3:39:50
 */
class FollowTask implements IGPaperTask {
	public var offset:uint;
	
	public var me:AvatarView;
	
	public var target:AvatarView;
	
	function FollowTask(me:AvatarView, target:AvatarView, offset:uint) {
		this.me = me;
		this.target = target;
		this.offset = offset;
	}
	
	public function process(owner:*, interval:int):void {
		var targetPt:Point = new Point(target.x + (target.direction == AvatarView.DIRECTION_LEFT ? offset : -offset), target.y);
		var distance:Number = Point.distance(new Point(me.x, me.y), targetPt);
		var interpolate:Point = Point.interpolate(targetPt, new Point(me.x, me.y)
			, Math.max(0, Math.min(1, interval / 1000 * me.speed / distance)));
		if (distance == 0)
			me.direction = target.x > me.x ? AvatarView.DIRECTION_RIGHT : AvatarView.DIRECTION_LEFT;
		me.x = interpolate.x;
		me.y = interpolate.y;
	}
	
	public function added():void {
	}
	
	public function removed():void {
	}
}
