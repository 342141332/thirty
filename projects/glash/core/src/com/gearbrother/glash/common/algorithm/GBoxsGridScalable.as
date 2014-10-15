package com.gearbrother.glash.common.algorithm {
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import org.as3commons.lang.ObjectUtils;
	import flash.geom.Rectangle;


	/**
	 * 数据按坐标范围划分并随时存取
	 *
	 */
	public class GBoxsGridScalable {
		private var _boxWidth:Number;
		private var _boxHeight:Number;

		//保存元素与当前元素所在数据分割块中的索引
		private var _neighbours:Dictionary;
		private var _boxs:Object;

		public function GBoxsGridScalable(boxWidth:Number, boxHeight:Number):void {
			_boxWidth = boxWidth;
			_boxHeight = boxHeight;

			_neighbours = new Dictionary();
			_boxs = {};
		}

		/**
		 * 获得对象所在的方块数组
		 * @param item
		 * @return
		 *
		 */
		public function isIn(item:DisplayObject):Array {
			var col:int = int((item.x) / _boxWidth);
			var row:int = int((item.y) / _boxHeight);
			var group:Array;
			if (_boxs[row + "-" + col])
				group = _boxs[row + "-" + col];
			else
				group = _boxs[row + "-" + col] = [];
			return group;
		}

		/**
		 * 增加对象
		 * @param item
		 *
		 */
		public function insert(item:DisplayObject):void {
			var col:int = int((item.x) / _boxWidth);
			var row:int = int((item.y) / _boxHeight);
			var box:Array = _boxs[row + "-" + col];
			if (box == null)
				box = _boxs[row + "-" + col] = [];
			box[box.length] = item;
			_neighbours[item] = box;
		}

		/**
		 * 重新插入对象
		 * @param item
		 *
		 */
		public function reinsert(item:DisplayObject):void {
			var list:Array = isIn(item);
			var oldNeighours:Array = _neighbours[item];
			if (list != oldNeighours) {
				if (oldNeighours) {
					var index:int = oldNeighours.indexOf(item);
					if (index != -1)
						oldNeighours.splice(index, 1);
				}

				if (list) {
					list[list.length] = item;
					_neighbours[item] = list;
				}
			}
		}

		/**
		 * 移除对象
		 * @param item
		 *
		 */
		public function remove(item:DisplayObject):void {
			var list:Array = _neighbours[item];
			if (list) {
				var index:int = list.indexOf(item);
				if (index != -1)
					list.splice(index, 1);
			}
		}

		/**
		 * 获得一个范围内的所有对象
		 *
		 * @param rect
		 *
		 */
		public function retrieve(p:Rectangle):Array {
			var leftCol:int = int((p.x) / _boxWidth);
			var rightCol:int = Math.ceil((p.x + p.width) / _boxWidth);
			rightCol = rightCol - leftCol;
			var topRow:int = int((p.y) / _boxHeight);
			var bottomRow:int = Math.ceil((p.y + p.height) / _boxHeight);
			bottomRow = bottomRow - topRow;
			var result:Array = [];
			for (var j:int = 0; j < bottomRow; j++) {
				for (var i:int = 0; i < rightCol; i++) {
					var box:Array = _boxs[(topRow + j) + "-" + (leftCol + i)];
					if (box) {
						result = result.concat(box);
					}
				}
			}
			return result;
		}
		
		public function reset(width:int, height:int):void {
			if (_boxWidth != width || _boxHeight != height) {
				_neighbours = new Dictionary;
				var preBox:Object = _boxs;
				_boxs = {};
				var itemses:Array = ObjectUtils.getProperties(preBox);
				for each (var items:Array in itemses) {
					for each (var item:DisplayObject in items) {
						insert(item);
					}
				}
				_boxWidth = width;
				_boxHeight = height;
			}
		}
	}
}