package com.gearbrother.tool.mapReader.view {
	import com.gearbrother.glash.common.oper.ext.GAliasFile;
	import com.gearbrother.glash.common.oper.ext.GBmdDefinition;
	import com.gearbrother.glash.common.oper.ext.GDefinition;
	import com.gearbrother.glash.display.GMovieBitmap;
	import com.gearbrother.glash.display.flixel.GPaperLayer;
	import com.gearbrother.glash.util.camera.Camera;
	import com.gearbrother.sheepwolf.model.BattleModel;
	import com.gearbrother.sheepwolf.rpc.protocol.bussiness.BattleProtocol;
	import com.gearbrother.sheepwolf.rpc.protocol.bussiness.PointBeanProtocol;
	import com.gearbrother.sheepwolf.view.layer.scene.battle.BattleSceneViewCanvas;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.geom.Point;


	/**
	 * @author lifeng
	 * @create on 2014-6-10
	 */
	public class BattleSceneLayerBorn extends GPaperLayer {
		public var sheepBornView:Shape;
		
		public var wolfBornView:Shape;
		
		public var caughtBornView:Shape;
		
		public function BattleSceneLayerBorn(battle:BattleModel, camera:Camera) {
			super(camera);

			addChild(sheepBornView = new Shape());
			addChild(wolfBornView = new Shape());
			addChild(caughtBornView = new Shape());
			bindData = battle;
			mouseEnabled = mouseChildren = false;
		}
		
		override public function handleModelChanged(events:Object=null):void {
			var battle:BattleModel = bindData;
			if (!events || events.hasOwnProperty(BattleProtocol.SHEEP_BORN_BOUNDS)) {
				sheepBornView.graphics.clear();
				sheepBornView.graphics.lineStyle(1, 0x00ff00);
				sheepBornView.graphics.beginFill(0x00ff00, .0);
				sheepBornView.graphics.drawRect(0, 0, (battle.sheepBornBounds.width + 1) * battle.cellPixel, (battle.sheepBornBounds.height + 1) * battle.cellPixel);
				sheepBornView.graphics.endFill();
				sheepBornView.x = battle.sheepBornBounds.x * battle.cellPixel;
				sheepBornView.y = battle.sheepBornBounds.y * battle.cellPixel;
			}
			if (!events || events.hasOwnProperty(BattleProtocol.WOLF_BORN_BOUNDS)) {
				wolfBornView.graphics.clear();
				wolfBornView.graphics.lineStyle(1, 0xff0000);
				wolfBornView.graphics.beginFill(0xff0000, .0);
				wolfBornView.graphics.drawRect(0, 0, (battle.wolfBornBounds.width + 1) * battle.cellPixel, (battle.wolfBornBounds.height + 1) * battle.cellPixel);
				wolfBornView.graphics.endFill();
				wolfBornView.x = battle.wolfBornBounds.x * battle.cellPixel;
				wolfBornView.y = battle.wolfBornBounds.y * battle.cellPixel;
			}
			if (!events || events.hasOwnProperty(BattleProtocol.CAUGHT_BOUNDS)) {
				caughtBornView.graphics.clear();
				caughtBornView.graphics.lineStyle(1, 0x0000ff);
				caughtBornView.graphics.beginFill(0x0000ff, .0);
				caughtBornView.graphics.drawRect(0, 0, (battle.caughtBounds.width + 1) * battle.cellPixel, (battle.caughtBounds.height + 1) * battle.cellPixel);
				caughtBornView.graphics.endFill();
				caughtBornView.x = battle.caughtBounds.x * battle.cellPixel;
				caughtBornView.y = battle.caughtBounds.y * battle.cellPixel;
			}
		}
	}
}
