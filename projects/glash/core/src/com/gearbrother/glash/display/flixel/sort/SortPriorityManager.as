package com.gearbrother.glash.display.flixel.sort {
	import com.gearbrother.glash.display.flixel.GPaperLayer;
	
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import org.as3commons.lang.ObjectUtils;

	/**
	 * 根据对象的priority属性排序，priority属性可以通过设置对象的sortCalculater属性自动更新
	 *
	 */
	public class SortPriorityManager implements ISortManager {
		public var layer:GPaperLayer;
		/**
		 * 排序依据
		 */
		public var sortFields:*;

		public function SortPriorityManager(layer:GPaperLayer, sortFields:* = "priority") {
			this.layer = layer;
			this.sortFields = sortFields;
		}

		public function sort(child:*):void {
			var l:int = layer.numChildren;
			for (var i:int = 0; i < l; i++) {
				var v:DisplayObject = layer.getChildAt(0);
				if (v.parent == layer && layer.getChildIndex(v) != i) {
					if (sortFunction(child, v)) {
						layer.setChildIndex(child, i);
						break;
					}
				}
			}

			if (layer.getChildIndex(v) != l - 1)
				layer.addChild(child);
		}

		protected function sortFunction(child1:DisplayObject, child2:DisplayObject):Boolean {
			if (sortFields is String) {
				return child1[sortFields] < child2[sortFields];
			} else if (sortFields is Function) {
				return sortFields(child1, child2) == -1;
			} else if (sortFields is Array) {
				for (var j:int = 0; j < sortFields.length; j++) {
					var p:String = sortFields[j];
					if (child1[p] != child2[p])
						return child1[p] < child2[p];
				}
				return false;
			}
			return false;
		}

		public function sortAll():void {
			var data:Array = ObjectUtils.getKeys(layer.childrenInScreenDict);
			for each (var d:DisplayObject in data) {
				if (d.parent != layer)
					throw new Error();
			}
			var result:Array;
			if (sortFields is String)
				result = data.sortOn([sortFields], Array.NUMERIC | Array.RETURNINDEXEDARRAY);
			else if (sortFields is Array)
				result = data.sortOn(sortFields, Array.NUMERIC | Array.RETURNINDEXEDARRAY);
			else if (sortFields is Function)
				result = data.sort(sortFields, Array.NUMERIC | Array.RETURNINDEXEDARRAY);
			else
				result = data.sort(Array.NUMERIC | Array.RETURNINDEXEDARRAY);
			
			for (var i:int = 0; i < result.length; i++) {
				var v:DisplayObject = data[result[i]] as DisplayObject;
				if (v.parent == layer && layer.getChildIndex(v) != i)
					layer.setChildIndex(v, i);
			}
		}
	}
}
