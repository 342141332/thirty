package {
	import com.gearbrother.glash.GMain;
	import com.gearbrother.glash.common.algorithm.astar.AStar;
	import com.gearbrother.glash.common.algorithm.astar.Grid;
	import com.gearbrother.glash.common.algorithm.astar.Node;
	import com.gearbrother.glash.display.container.GContainer;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;


	/**
	 * @author neozhang
	 * @create on Jul 31, 2013
	 */
	[SWF(width = "800", height = "500", frameRate = "60")]
	public class GCommonAStarCase extends GMain {
		private static const NUM_TILES:int = 100;
		private static var PROB:Number = .1;

		private var _gridModel:Grid;
		private var _grid:Vector.<Vector.<SpriteTile>>;
		private var _currentPos:Point;
		private var _astar:AStar;

		public function GCommonAStarCase() {
			_gridModel = new Grid(NUM_TILES, NUM_TILES);
			_currentPos = new Point(0, 0);
			createGrid();
		}

		/**
		 * Create your the tiles.
		 */
		private function createGrid():void {
			_grid = new Vector.<Vector.<SpriteTile>>();

			var i:int = 0;
			var j:int = 0;

			while (i < NUM_TILES) {
				_grid[i] = new Vector.<SpriteTile>();

				while (j < NUM_TILES) {
					var tile:SpriteTile = new SpriteTile();
					_grid[i][j] = tile;
					addChild(tile);
					tile.x = i * SpriteTile.tileWidth;
					tile.y = j * SpriteTile.tileHeight;

					tile.addEventListener(MouseEvent.CLICK, _handleClick);

					j++;
				}

				j = 0;
				i++;
			}

			for (var h:int = 0; h < _gridModel.height; h++) {
				for (var w:int = 0; w < _gridModel.width; w++) {
					var node:Node = _gridModel.getNodeAt(w, h);
					(_grid[h][w] as SpriteTile).occupied = node.walkable = Math.random() > .5;
				}
			}

			_currentPos = new Point(0, 0);
			_grid[0][0].drawAsCurrentPosition();
		}

		private function _handleClick(e:MouseEvent):void {
			clearPathTiles();

			var x:int = SpriteTile(e.currentTarget).x / SpriteTile.tileWidth;
			var y:int = SpriteTile(e.currentTarget).y / SpriteTile.tileHeight;

			if (!_astar) {
				_astar = new AStar();
			}

			//var avgTime: Number = 0,
			//	minTime: Number = Number.MAX_VALUE,
			//	maxTime: Number = Number.MIN_VALUE;

			//for (var i:uint; i < 10; i++ )
			//{
			var t:Number = getTimer();

			//search.
			var result:Array = _astar.findPath(_currentPos.x, _currentPos.y, x, y, _gridModel);
			var time:Number = getTimer() - t;

			//	avgTime += time;
			//	minTime = Math.min(time, minTime);
			//	maxTime = Math.max(time, minTime);
			//}
			//trace("avg: ", avgTime/10, "min: ", minTime, "max: ", maxTime);

			for each (var node2:Array in _astar.evaluatedTiles)
				_grid[node2[0]][node2[1]].drawWasEvaluated();

			for each (var node:Array in result)
				_grid[node[0]][node[1]].drawForPath();


			_grid[_currentPos.x][_currentPos.y].drawForPath();
			if (result.length > 1) {
				_currentPos = result[result.length - 1].position;
			}
			_grid[_currentPos.x][_currentPos.y].drawAsCurrentPosition();
		}

		private function clearPathTiles():void {
			var i:int = 0;
			var j:int = 0;

			while (i < NUM_TILES) {
				while (j < NUM_TILES) {
					_grid[i][j].clearPath();
					j++;
				}
				j = 0;
				i++;
			}
		}
	}
}
import com.gearbrother.glash.display.GSprite;

import flash.display.Sprite;
import flash.events.MouseEvent;

/**
 * @author tomnewton
 */
class SpriteTile extends GSprite {
	public static const tileWidth:int = 5;
	public static const tileHeight:int = 5;

	private var _occupied:Boolean;
	private var _onPath:Boolean;

	public function SpriteTile() {
		drawEmptyTile();
	}

	public function set occupied(v:Boolean):void {
		_occupied = v;

		if (_occupied) {
			drawOccupiedTile();
		} else {
			drawEmptyTile();
		}
	}

	public function get occupied():Boolean {
		return _occupied;
	}

	public function get onPath():Boolean {
		return _onPath;
	}

	public function drawForPath():void {
		_onPath = true;
		fillWithColor(0x000000);
	}

	public function clearPath():void {
		if (_onPath) {
			drawEmptyTile();
			_onPath = false;
		}
	}

	public function drawWasEvaluated():void {
		_onPath = true;
		fillWithColor(0x000000, .25);
	}

	public function drawAsCurrentPosition():void {
		fillWithColor(0x00FF00);
	}

	public function drawEmptyTile():void {
		this.graphics.clear();
		this.graphics.beginFill(0xFFFFFF);
		this.graphics.lineStyle(1, 0x000000);
		this.graphics.lineTo(tileWidth, 0);
		this.graphics.lineTo(tileWidth, tileWidth);
		this.graphics.lineTo(0, tileWidth);
		this.graphics.lineTo(0, 0);
		this.graphics.endFill();
	}

	private function fillWithColor(colour:uint, alpha:Number = 1):void {
		this.graphics.clear();
		this.graphics.beginFill(colour, alpha);
		this.graphics.lineTo(tileWidth, 0);
		this.graphics.lineTo(tileWidth, tileWidth);
		this.graphics.lineTo(0, tileWidth);
		this.graphics.lineTo(0, 0);
		this.graphics.endFill();
	}

	private function drawOccupiedTile():void {
		fillWithColor(0xFF0000);
	}
}
