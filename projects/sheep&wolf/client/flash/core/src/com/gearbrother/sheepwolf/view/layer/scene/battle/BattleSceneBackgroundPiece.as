package com.gearbrother.sheepwolf.view.layer.scene.battle {
	import com.gearbrother.glash.display.GDisplayBitmap;
	import com.gearbrother.glash.util.display.GColorUtil;
	import com.gearbrother.sheepwolf.conf.BattleConf;
	import com.gearbrother.sheepwolf.view.layer.scene.battle.BattleSceneBackground;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	
	
	/**
	 * @author lifeng
	 * @create on 2014-5-15
	 */
	public class BattleSceneBackgroundPiece extends GDisplayBitmap {
		static public const PIECE_COL:int = 12;

		static public const WALL:Shape = new Shape();
		static public const GRASS:Shape = new Shape();
		{
			WALL.graphics.beginFill(0xff0000);
			WALL.graphics.drawRect(0, 0, BattleConf.GRID_SIZE, BattleConf.GRID_SIZE);
			WALL.graphics.endFill();
			
			GRASS.graphics.beginFill(0x00ff00);
			GRASS.graphics.drawRect(0, 0, BattleConf.GRID_SIZE, BattleConf.GRID_SIZE);
			GRASS.graphics.endFill();
		}
		
		public var battleConf:BattleConf;
		
		public var row:int;
		
		public var col:int;
		
		public function BattleSceneBackgroundPiece(battleConf:BattleConf) {
			super();
			
			this.battleConf = battleConf;
		}
		
		public function update():void {
			if (!stage)
				return;

			if (bitmapData) {
				bitmapData.dispose();
			}
			bitmapData = new BitmapData(BattleSceneBackgroundPiece.PIECE_COL * BattleConf.GRID_SIZE
				, BattleSceneBackgroundPiece.PIECE_COL * BattleConf.GRID_SIZE);
			for (var r:int = row; r < row + BattleSceneBackgroundPiece.PIECE_COL; r++) {
				for (var c:int = col; c < col + BattleSceneBackgroundPiece.PIECE_COL; c++) {
					if (r < battleConf.cells.length - 1) {
						var d:String = battleConf.cells[r][c];
						switch (d) {
							case BattleConf.LAND_BLOCK:
								bitmapData.draw(WALL, new Matrix(1, 0, 0, 1, (c - col) * BattleConf.GRID_SIZE, (r - row) * BattleConf.GRID_SIZE));
								break;
							case BattleConf.LAND_LAND:
								break;
							case BattleConf.LAND_GRASS:
								bitmapData.draw(GRASS, new Matrix(1, 0, 0, 1, (c - col) * BattleConf.GRID_SIZE, (r - row) * BattleConf.GRID_SIZE));
								break;
							case BattleConf.LAND_GIFT:
								break;
							case BattleConf.LAND_BORN:
								break;
						}
					}
				}
			}
		}
		
		override protected function doDispose():void {
			bitmapData.dispose();
			bitmapData = null;
			
			super.doDispose();
		}
	}
}