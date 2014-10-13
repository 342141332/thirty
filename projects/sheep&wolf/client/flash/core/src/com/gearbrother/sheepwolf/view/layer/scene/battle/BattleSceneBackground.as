package com.gearbrother.sheepwolf.view.layer.scene.battle {
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.flixel.GPaperLayer;
	import com.gearbrother.glash.util.camera.Camera;
	import com.gearbrother.glash.util.math.GMathUtil;
	import com.gearbrother.sheepwolf.conf.BattleConf;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.geom.Point;
	
	import org.as3commons.lang.ObjectUtils;


	/**
	 * @author lifeng
	 * @create on 2014-5-15
	 */
	public class BattleSceneBackground extends GNoScale {
		private var _conf:BattleConf;

		private var _camera:Camera;
		
		private var _dirtyPieces:Array;
		
		private var _usingPieces:Object;
		
		private var _bitmap:Bitmap;

		public function BattleSceneBackground(battleConf:BattleConf, camera:Camera) {
			super();

			_conf = battleConf;
			_camera = camera;
			_dirtyPieces = [];
			_usingPieces = {};
		}
		
		override protected function doInit():void {
			super.doInit();
			
			_camera.addEventListener(Event.CHANGE, _handleCameraChanged);
			_handleCameraChanged();
		}
		
		private function _handleCameraChanged(event:Event = null):void {
			var leftTop:Point = new Point(GMathUtil.roundDownToMultiple(_camera.screenRect.left, BattleConf.GRID_SIZE * BattleSceneBackgroundPiece.PIECE_COL)
				, GMathUtil.roundDownToMultiple(_camera.screenRect.top, BattleConf.GRID_SIZE * BattleSceneBackgroundPiece.PIECE_COL));
			var rightBottom:Point = new Point(GMathUtil.roundUpToMultiple(_camera.screenRect.right, BattleConf.GRID_SIZE * BattleSceneBackgroundPiece.PIECE_COL)
				, GMathUtil.roundUpToMultiple(_camera.screenRect.bottom, BattleConf.GRID_SIZE * BattleSceneBackgroundPiece.PIECE_COL));
			var usingPieceKeys:Array = ObjectUtils.getKeys(_usingPieces);
			var requirePiecesKey:Array = [];
			for (var r:int = leftTop.y; r < rightBottom.y; r += BattleConf.GRID_SIZE * BattleSceneBackgroundPiece.PIECE_COL) {
				for (var c:int = leftTop.x; c < rightBottom.x; c += BattleConf.GRID_SIZE * BattleSceneBackgroundPiece.PIECE_COL) {
					var index:int = usingPieceKeys.indexOf(r + "-" + c);
					if (index < 0)
						requirePiecesKey.push([r, c]);
					else
						usingPieceKeys.splice(index, 1);
				}
			}
			//add require piece
			var unUsingPieceKeys:Array = usingPieceKeys;
			for each (var pt:Array in requirePiecesKey) {
				var unUsingPiece:BattleSceneBackgroundPiece;
				var unUsingPieceKey:String = unUsingPieceKeys.shift();
				if (unUsingPieceKey) {
					unUsingPiece = _usingPieces[unUsingPieceKey];
					delete _usingPieces[unUsingPieceKey];
				} else {
					unUsingPiece = _dirtyPieces.shift();
					if (unUsingPiece) {
						addChild(unUsingPiece);
					} else {
						addChild(unUsingPiece = new BattleSceneBackgroundPiece(_conf));
					}
				}
				unUsingPiece.row = pt[0] / BattleConf.GRID_SIZE;
				unUsingPiece.col = pt[1] / BattleConf.GRID_SIZE;
				unUsingPiece.y = pt[0];
				unUsingPiece.x = pt[1];
				unUsingPiece.update();
				_usingPieces[unUsingPiece.y + "-" + unUsingPiece.x] = unUsingPiece;
			}
			//put unUsingPiece to dirty
			while (unUsingPieceKeys.length) {
				unUsingPiece = _usingPieces[unUsingPieceKeys.shift()];
				delete _usingPieces[unUsingPiece.y + "-" + unUsingPiece.x];
				removeChild(unUsingPiece);
				_dirtyPieces.push(unUsingPiece);
			}
		}
		
		override protected function doDispose():void {
			_camera.removeEventListener(Event.CHANGE, _handleCameraChanged);
			
			super.doDispose();
		}
	}
}