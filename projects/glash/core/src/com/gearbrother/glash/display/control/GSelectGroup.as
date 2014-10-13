package com.gearbrother.glash.display.control {
	import com.gearbrother.glash.display.GDisplaySprite;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;


	[Event(name = "change", type = "flash.events.Event")]

	/**
	 * 单选框组对象。
	 * 请用getGroupByName方法创建并获取。
	 *
	 * @author feng.lee
	 *
	 */
	public class GSelectGroup extends EventDispatcher {
		private var _selectedItem:GDisplaySprite;

		/**
		 * 选择的组
		 */
		public function get selectedItem():GDisplaySprite {
			return _selectedItem;
		}

		public function set selectedItem(newValue:GDisplaySprite):void {
			if (_selectedItem != newValue) {
				_selectedItem = newValue;

				dispatchEvent(new Event(Event.CHANGE));
			}
		}

		public function GSelectGroup(canSelectNum:int = 1) {
		}
	}
}
