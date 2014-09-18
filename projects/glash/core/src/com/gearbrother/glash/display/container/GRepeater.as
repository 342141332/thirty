package com.gearbrother.glash.display.container {

	import com.gearbrother.glash.common.geom.GDimension;
	import com.gearbrother.glash.display.GSprite;
	import com.gearbrother.glash.display.event.GDisplayEvent;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.as3commons.lang.ObjectUtils;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;


	/**
	 * 矩阵显示数组, 元素的显示对象大小必须都是一样
	 * 相较于其他容器每条数据都有自身的显示对象, 该容器重复使用数据显示对象以达到良好的性能, 性能只取决于当前容器的大小, 而非显示数据的大小
	 * 经测试100w条数据依旧表现出良好的性能.
	 * @author feng.lee
	 *
	 */
	public class GRepeater extends GContainer {
		static public const logger:ILogger = getLogger(GRepeater);

		private var _alwaysSelectOne:Boolean;

		public function get alwaysSelectOne():Boolean {
			return _alwaysSelectOne;
		}

		public function set alwaysSelectOne(v:Boolean):void {
			_alwaysSelectOne = v;
		}

		/**
		 * 当前显示区域data与view的对应 
		 */		
		public var _itemViews:Array;
		
		/**
		 * 不使用的脏对象, 数组大小应该是保存可视范围内最大数量 
		 */		
		protected var _dirtyPool:Array;

		private var _itemDisplayClazz:Class;

		private var _selectedItem:*;

		public function get selectedItem():* {
			return _selectedItem;
		}

		public function set selectedItem(v:*):void {
			if (_selectedItem != v) {
				_selectedItem = v;
				dispatchEvent(new GDisplayEvent(GDisplayEvent.SELECT_CHANGE));
			}
		}

		public var _itemSize:GDimension;
		
		private var _col:int;
		
		private var _hGap:int;
		
		private var _vGap:int;
		
		private var _dataArray:Array;
		
		public function set dataArray(newValue:Array):void {
			_dataArray = newValue;
			var keys:Array = ObjectUtils.getKeys(_itemViews);
			for each (var key:* in keys) {
				var item:DisplayObject = _itemViews[key];
				removeChild(item);
				delete _itemViews[key];
				_dirtyPool.push(item);
			}
			_refreshItems();
			dispatchEvent(new GDisplayEvent(GDisplayEvent.SCROLL_CHANGE));
		}

		public function get dataArray():Array {
			return _dataArray;
		}
		
		override public function set scrollH(newValue:int):void {
			var oldScrollH:int = scrollH;
			super.scrollH = newValue;
			if (oldScrollH != scrollH)
				_refreshItems();
		}
		
		override public function set scrollV(newValue:int):void {
			var oldScrollV:int = scrollV;
			super.scrollV = newValue;
			if (oldScrollV != scrollV)
				_refreshItems();
		}
		
		override public function get preferredSize():GDimension {
			if (_cachedPreferredSize) {
				return _cachedPreferredSize;
			} else {
				_cachedPreferredSize = new GDimension(_col * _itemSize.width + _hGap * Math.max(0, _col - 1)
					, Math.ceil(dataArray.length / _col) * _itemSize.height + _vGap * Math.max(0, Math.ceil(dataArray.length / _col) - 1));
				return _cachedPreferredSize;
			}
		}
		
		/**
		 * 
		 * @param itemDisplayClazz instance of GSprite
		 * @param col
		 * @param hGap
		 * @param vGap
		 * 
		 */		
		public function GRepeater(itemDisplayClazz:Class, col:int, hGap:int = 5, vGap:int = 5) {
			super();

			_itemDisplayClazz = itemDisplayClazz;
			var instance:DisplayObject = new itemDisplayClazz();
			_itemSize = new GDimension(instance.width, instance.height);
			_col = col;
			_hGap = hGap;
			_vGap = vGap;
			_itemViews = [];
			_dirtyPool = [];
			dataArray = [];
		}
		
		public function getItemPosition(data:*):Point {
			var index:int = dataArray.indexOf(data);
			if (index != -1)
				return new Point(index % _col * _itemSize.width + _hGap * Math.max(0, index % _col - 1)
					, int(index / _col) * _itemSize.height + _vGap * Math.max(0, int(index / _col) - 1));
			else
				return null;
		}
		
		private function _refreshItems():void {
			var renderRect:Rectangle = new Rectangle();
			renderRect.left = Math.floor(scrollH / (_itemSize.width + _hGap));
			renderRect.right = Math.min(_col, Math.ceil((scrollH + width) / (_itemSize.width + _hGap)));
			renderRect.top = Math.floor(scrollV / (_itemSize.height + _vGap));
			renderRect.height = Math.ceil((scrollV + height) / (_itemSize.height + _vGap));
			var keys:Array = ObjectUtils.getKeys(_itemViews);
			for each (var index:* in keys) {
				if (!renderRect.containsPoint(new Point(int(index % _col), int(index / _col)))
					|| !dataArray.hasOwnProperty(index)) {
					var item:DisplayObject = _itemViews[index];
					removeChild(item);
					delete _itemViews[index];
					_dirtyPool.push(item);
				}
			}
			//check not exist to add
			for (var r:int = renderRect.top; r < renderRect.bottom; r++) {
				for (var c:int = renderRect.left; c < renderRect.right; c++) {
					if (dataArray.hasOwnProperty(c + r * _col)) {
						var addItem:GSprite;
						if (!_itemViews.hasOwnProperty(c + r * _col)) {
							addItem = _dirtyPool.shift();
							if (!addItem)
								addItem = new _itemDisplayClazz() as GSprite;
							_itemViews[c + r * _col] = addItem;
							addItem.data = dataArray[c + r * _col];
							addItem.x = c * _itemSize.width + c * _hGap;
							addItem.y = r * _itemSize.height + r * _vGap;
							addChild(addItem);
						}
					}
				}
			}
		}
	}
}
