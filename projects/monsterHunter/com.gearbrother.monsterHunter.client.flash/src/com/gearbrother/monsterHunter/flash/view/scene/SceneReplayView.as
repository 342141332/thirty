package com.gearbrother.monsterHunter.flash.view.scene {
	import com.gearbrother.glash.common.geom.*;
	import com.gearbrother.glash.common.oper.GOper;
	import com.gearbrother.glash.common.oper.GOperEvent;
	import com.gearbrother.glash.common.oper.GOperGroupListener;
	import com.gearbrother.glash.common.oper.GQueue;
	import com.gearbrother.glash.common.resource.type.GBmdDefinition;
	import com.gearbrother.glash.common.resource.type.GDefinition;
	import com.gearbrother.glash.display.GBmdMovieInfo;
	import com.gearbrother.glash.display.control.GButton;
	import com.gearbrother.glash.paper.GPaper;
	import com.gearbrother.glash.paper.display.GPaperLayerBackground;
	import com.gearbrother.glash.paper.display.layer.GPaperLayer;
	import com.gearbrother.glash.paper.sort.SortYManager;
	import com.gearbrother.monsterHunter.flash.command.GameCommandMap;
	import com.gearbrother.monsterHunter.flash.event.ExploreMapEvent;
	import com.gearbrother.monsterHunter.flash.model.MonsterModel;
	import com.gearbrother.monsterHunter.flash.model.ReplayModel;
	import com.gearbrother.monsterHunter.flash.model.ReplaySignalModel;
	import com.gearbrother.monsterHunter.flash.view.common.AvatarView;
	import com.gearbrother.monsterHunter.flash.view.common.HunterAvatarView;
	import com.gearbrother.monsterHunter.flash.view.replay.ReplayMonsterView;
	import com.gearbrother.monsterHunter.flash.view.replay.ReplayPositionTransformer;
	import com.gearbrother.monsterHunter.flash.view.replay.oper.ReplaySignalOper;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;

	/**
	 * 优化：
	 * 	血条，掉血，buf，出手先后顺序条，死亡，技能释放范围格
	 *
	 * 动画顺序:
	 * 			人物先走到位置 -> 召唤怪物 -> 怪物高亮出现 -> 计算先手值
	 *
	 *
	 *
	 *
	 *
	 * @author feng.lee
	 * create on 2012-12-7 下午3:37:34
	 */
	public class SceneReplayView extends GPaper {
		static public const logger:ILogger = getLogger(SceneReplayView);
		
		static public const OFFSET:Point = new Point(150, 400);
		
		static public const COL:int = 12;
		
		static public const ROW:int = 5;
		
		static public const minColWidth:int = 70;
		
		public var roundLabel:TextField;
		
		private var _outBtn:GButton;

		private var _selectlayer:GPaperLayer;

		public function get selectlayer():GPaperLayer {
			return _selectlayer;
		}

		private var _avatarlayer:GPaperLayer;

		public function get actorlayer():GPaperLayer {
			return _avatarlayer;
		}

		private var _infolayer:GPaperLayer;

		public function get infolayer():GPaperLayer {
			return _infolayer;
		}

		private var _armedSkilllayer:GPaperLayer;

		public function get armedSkilllayer():GPaperLayer {
			return _armedSkilllayer;
		}

		private var _signalViews:Array;

		public function get signalViews():Array {
			return _signalViews;
		}

		private var _signalQueue:GQueue;

		public function get model():ReplayModel {
			return data;
		}

		private var _hunterA:HunterAvatarView;
		
		private var _hunterB:HunterAvatarView;
		
		public var positionTransformer:ReplayPositionTransformer;

		override public function set data(value:*):void {
			if (value is ReplayModel)
				super.data = value;
			else
				throw new ArgumentError("Invalid Params");
		}

		public function SceneReplayView() {
			super();
			
			_outBtn = new GButton();
			_outBtn.text = "left";
			_signalViews = [];
			_signalQueue = new GQueue();
			_signalQueue.addEventListener(GOperEvent.OPERATION_COMPLETE, _handleSignalEvent);
			addEventListener(MouseEvent.CLICK, _handleMouseEvent);
		}

		override public function handleModelChanged(events:Object=null):void {
			var resources:Array = [model.background];
			var monsters:Array = model.monstersA.concat(model.monstersB);
			for each (var actorModel:MonsterModel in monsters) {
				resources.push(actorModel.definitionStand);
			}
			//convert all signals to views
			
			for each (var signalModel:ReplaySignalModel in model.signals) {
				var signalView:ReplaySignalOper = new ReplaySignalOper(signalModel, this);
				resources = resources.concat(signalView.resources);
				_signalViews.push(signalView);
			}
			
			var resloader:GOperGroupListener = new GOperGroupListener();
			for each (var res:GOper in resources) {
				resloader.listenOper(res);
			}
		}
		
		private function _handleResOperEvent():void {
			var _backgroundUpLayer:GPaperLayerBackground = new GPaperLayerBackground(camera, 1);
			_backgroundUpLayer.definition = new GBmdDefinition(new GDefinition(SceneExploreMapView.lastScene.backgoundSrc, "BMD_LOW"));
			addChild(_backgroundUpLayer);
			
			var _backgroundLowLayer:GPaperLayerBackground = new GPaperLayerBackground(camera, .3);
			_backgroundLowLayer.definition = new GBmdDefinition(new GDefinition(SceneExploreMapView.lastScene.backgoundSrc, "BMD_UP"));
			addChild(_backgroundLowLayer);
			
			var cols:Array = [];
			var monsters:Array = model.monstersA.concat(model.monstersB);
			for each (var monster:MonsterModel in monsters) {
				var bmdsInfo:GBmdMovieInfo = monster.definitionStand.result;
				var bmds:Array = bmdsInfo.bmds;
				var avatarWidth:int = (bmds.sortOn("width", Array.DESCENDING | Array.NUMERIC)[0] as BitmapData).width;
				cols[monster.fomat.x] = Math.max(avatarWidth + 10, cols[monster.fomat.x] ? cols[monster.fomat.x] : 0);
			}
			for (var i:int = 0; i < COL + 1; i++) {
				cols[i] = 77;//Math.max(minColWidth, cols[i] ? cols[i] : 0);
			}
			positionTransformer = new ReplayPositionTransformer(OFFSET, cols, 37);
			
			var debugLayer:DebugLayer = new DebugLayer(this, COL, ROW, positionTransformer);
//			addChild(debugLayer);

			_selectlayer = new GPaperLayer(this);
			addChild(_selectlayer);

			_avatarlayer = new AvatarLayer(this);
			_avatarlayer.sortManager = new SortYManager(_avatarlayer);
			addChild(_avatarlayer);

			_infolayer = new GPaperLayer(this);
			addChild(_infolayer);

			_armedSkilllayer = new GPaperLayer(this);
			addChild(_armedSkilllayer);

			addChild(roundLabel);
			
			addChild(_outBtn);

			start();
		}

		public function _handleMouseEvent(event:MouseEvent):void {
			switch (event.target) {
				case _outBtn:
					GameCommandMap.instance._eventDispatcher.dispatchEvent(ExploreMapEvent.getGetEvent(SceneExploreMapView.lastScene.id));
					break;
			}
			return;
			if (event.target is ReplayMonsterView && (event.target as ReplayMonsterView).model) {
				var monster:MonsterModel = (event.target as ReplayMonsterView).model;
				GameCommandMap.instance._eventDispatcher.dispatchEvent(ExploreMapEvent.getCatchEvent(model.id, monster.id));
			}
		}

		public function start():void {
			logger.info("+++++++++++++ play {0} +++++++++++++", [model.signals.length]);

			_avatarlayer.removeAllChildren();

			//format data
			var monsters:Array = model.monstersA.concat(model.monstersB);
			for each (var monsterModel:MonsterModel in monsters) {
				var monsterView:ReplayMonsterView = new ReplayMonsterView(_avatarlayer);
				monsterView.data = monsterModel;
				if (model.monstersA.indexOf(monsterModel) == -1)
					monsterModel.fomat.x = monsterModel.fomat.x + 6;
				else
					monsterModel.fomat.x = 4 - monsterModel.fomat.x;
				var pixelPt:Point = positionTransformer.locationToPixel(monsterModel.fomat, 0);
				monsterView.x = pixelPt.x;
				monsterView.y = pixelPt.y;
				monsterView.direction = model.monstersA.indexOf(monsterModel) == -1 ? AvatarView.DIRECTION_LEFT : AvatarView.DIRECTION_RIGHT;
				_avatarlayer.addChild(monsterView);
			}

			_hunterA = new HunterAvatarView();
			_hunterA.data = model.hunterA;
			pixelPt = positionTransformer.getEdge(new Point(0, 2));
			_hunterA.x = pixelPt.x - 70;
			_hunterA.y = pixelPt.y;
			_avatarlayer.addChild(_hunterA);
			
			if (model.hunterB) {
				_hunterB = new HunterAvatarView();
				_hunterB.direction = AvatarView.DIRECTION_LEFT;
				_hunterB.data = model.hunterB;
				pixelPt = positionTransformer.locationToPixel(new Point(11, 2), 0);
				_hunterB.x = pixelPt.x;
				_hunterB.y = pixelPt.y;
				_avatarlayer.addChild(_hunterB);
			}
			
			for each (var signalView:ReplaySignalOper in _signalViews) {
				signalView.commit(_signalQueue);
			}
			_signalQueue.execute();
		}

		public function stop():void {
			_signalQueue.halt();
		}
		
		private function _handleSignalEvent(event:Event):void {
		}
		
		private function handleResultText(text:DisplayObject):void {
			text.parent.removeChild(text);
		}

		public function getActorView(monsterID:*):ReplayMonsterView {
			for (var i:int = 0; i < _avatarlayer.numChildren; i++) {
				var child:DisplayObject = _avatarlayer.getChildAt(i);
				if (child is ReplayMonsterView && (child as ReplayMonsterView).model.id == monsterID)
					return child as ReplayMonsterView;
			}
			return null;
		}

		override protected function doValidateLayout():void {
			super.doValidateLayout();

			roundLabel.x = width - roundLabel.width >> 1;
			roundLabel.y = 70;
			
			_outBtn.x = (width - _outBtn.width) >> 1;
			_outBtn.y = height - 50;
		}
	}
}
import com.gearbrother.glash.paper.GPaper;
import com.gearbrother.glash.paper.display.layer.GPaperLayer;
import com.gearbrother.monsterHunter.flash.view.replay.ReplayPositionTransformer;

import flash.geom.Point;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;



/**
 * @author feng.lee
 * create on 2012-6-7 下午9:13:24
 */
class DebugLayer extends GPaperLayer {
	private var _col:uint;
	private var _row:uint;

	public function DebugLayer(paper:GPaper, col:uint, row:uint, posTrans:ReplayPositionTransformer) {
		super(paper);
		
		_col = col;
		_row = row;
		mouseEnabled = mouseChildren = false;
		cacheAsBitmap = true;

		graphics.clear();
		graphics.lineStyle(1, 0xFF0066);
		var r:int = 0;
		var c:int = 0;
		var from:Point;
		var to:Point;
		for (r = 0; r < _row + 1; r++) {
			from = posTrans.getEdge(new Point(0, r));
			to = posTrans.getEdge(new Point(_col, r));
			graphics.moveTo(from.x, from.y);
			graphics.lineTo(to.x, to.y);
		}
		for (c = 0; c < _col + 1; c++) {
			from = posTrans.getEdge(new Point(c, 0));
			to = posTrans.getEdge(new Point(c, _row));
			graphics.moveTo(from.x, from.y);
			graphics.lineTo(to.x, to.y);
		}
		for (r = 0; r < _row; r++) {
			for (c = 0; c < _col; c++) {
				var l:TextField = new TextField();
				l.border = true;
				l.defaultTextFormat = new TextFormat(null, 13, 0xFFFFFF);
				l.autoSize = TextFieldAutoSize.LEFT;
				l.text = "[" + c + "," + r + "]";
				var pt:Point = posTrans.locationToPixel(new Point(c, r), 0);
				l.x = pt.x - (l.textWidth >> 1);
				l.y = pt.y - (l.textHeight >> 1);
				addChild(l);
			}
		}
	}
}