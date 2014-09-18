package com.gearbrother.glash.common.algorithm {
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	/**
	 * 用于存储规则物体的存储，构造比四叉树慢，查询比四叉树快
	 * 正方形格存储坐标存取
	 *
	 */
	public class GBoxsGrid {
		public var rect:Rectangle;
		public var boxWidth:Number;
		public var boxHeight:Number;

		public var dict:Dictionary;
		protected var boxs:Array;

		private var w:int;
		private var h:int;

		public function GBoxsGrid(rect:Rectangle, boxWidth:Number = 100, boxHeight:Number = 100):void {
			this.rect = rect;
			this.boxWidth = boxWidth;
			this.boxHeight = boxHeight;

			this.dict = new Dictionary(true);
			rebuild();
		}
		
		public function clear():void {
			for (var i:int = 0; i < boxs.length; i++)
				(this.boxs[i] as Array).length = 0;
		}
		
		private function rebuild():void {
			this.w = Math.ceil(rect.width / boxWidth);
			this.h = Math.ceil(rect.height / boxHeight);
			var l:int = w * h;
			this.boxs = new Array(l);
			for (var i:int = 0; i < l; i++)
				this.boxs[i] = [];
		}

		/**
		 * 获得对象所在的方块数组
		 * @param item
		 * @return
		 *
		 */
		public function getIndex(item:*):Array {
			var x:int = int((item.x - rect.x) / boxWidth);
			var y:int = int((item.y - rect.y) / boxHeight);
			x = x < 0 ? 0 : x > w ? w : x;
			y = y < 0 ? 0 : y > h ? h : y;
			return boxs[y * w + x];
		}

		/**
		 * 增加对象
		 * @param item
		 *
		 */
		public function insert(item:*):void {
			var box:Array = getIndex(item);
			box[box.length] = item;

			this.dict[item] = box;
		}

		/**
		 * 重新插入对象
		 * @param item
		 *
		 */
		public function reinsert(item:*):void {
			var list:Array = getIndex(item);
			var oldlist:Array = this.dict[item];
			if (list != oldlist) {
				if (oldlist) {
					var index:int = oldlist.indexOf(item);
					if (index != -1)
						oldlist.splice(index, 1);
				}

				if (list) {
					list[list.length] = item;
					this.dict[item] = list;
				}
			}
		}

		/**
		 * 移除对象
		 * @param item
		 *
		 */
		public function remove(item:*):void {
			var list:Array = this.dict[item];
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
		public function retrieve(p:*):Array {
			var x:int = int((p.x - rect.x) / boxWidth);
			var y:int = int((p.y - rect.y) / boxHeight);
			var il:int = Math.ceil((p.x - rect.x + p.width) / boxWidth);
			il = il < w ? il - x : w - x;
			var jl:int = Math.ceil((p.y - rect.y + p.height) / boxHeight);
			jl = jl < h ? jl - y : h - y;
			var result:Array = [];
			for (var j:int = 0; j < jl; j++) {
				for (var i:int = 0; i < il; i++) {
					var box:Array = boxs[(y + j) * w + x + i];
					result.push.apply(null, box);
				}
			}
			return result;
		}
		
		public function reset():void {
			var l:int = this.boxs.length;
			for (var i:int = 0; i < l; i++)
				(this.boxs[i] as Array).length = 0;
		}
	}
}
