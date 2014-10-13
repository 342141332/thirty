package com.gearbrother.glash.display {
	import com.gearbrother.glash.display.control.GSelectGroup;
	import com.gearbrother.glash.display.manager.GPaintManager;
	import com.gearbrother.glash.display.propertyHandler.GPropertyBindDataHandler;
	import com.gearbrother.glash.display.propertyHandler.GPropertyTickHandler;
	import com.gearbrother.glash.display.propertyHandler.GPropertyTimerHandler;
	
	import flash.display.Sprite;
	import flash.events.Event;


	/**
	 *  
	 * @author feng.lee
	 * 
	 * @see com.gearbrother.glash.display.IGDisplay
	 * 
	 */	
	public class GDisplaySprite extends Sprite implements IGDisplay {
		private var _enabled:Boolean;

		public function get enabled():Boolean {
			return _enabled;
		}

		public function set enabled(newValue:Boolean):void {
			_enabled = newValue;
		}

		private var _selectedGroup:GSelectGroup;
		public function get selectedGroup():GSelectGroup {
			return _selectedGroup;
		}
		public function set selectedGroup(newValue:GSelectGroup):void {
			if (_selectedGroup != newValue) {
				if (_selectedGroup)
					_selectedGroup.removeEventListener(Event.CHANGE, _handleSelectGroupEvent);
				_selectedGroup = newValue;
				_selectedGroup.addEventListener(Event.CHANGE, _handleSelectGroupEvent);
				_handleSelectGroupEvent();
			}
		}
		
		private function _handleSelectGroupEvent(event:Event = null):void {
			if (_selectedGroup)
				selected = _selectedGroup.selectedItem == this;
		}

		private var _selected:Boolean;
		public function get selected():Boolean {
			return _selected;
		}
		public function set selected(newValue:Boolean):void {
			if (_selected != newValue) {
				_selected = newValue;
				
				dispatchEvent(new Event(Event.SELECT));
				if (_selected && _selectedGroup)
					_selectedGroup.selectedItem = this;
			}
		}

		private var _cursor:*;

		public function get cursor():* {
			return _cursor;
		}

		public function set cursor(newValue:*):void {
			_cursor = newValue;
		}

		private var _toolTip:*;

		public function get toolTip():* {
			return _toolTip;
		}

		public function set toolTip(newValue:*):void {
			_toolTip = newValue;
		}

		private var _tipData:*;

		public function get tipData():* {
			return _tipData;
		}

		public function set tipData(newValue:*):void {
			_tipData = newValue;
		}
		
		private var _dndData:*;
		public function get dndData():* {
			return _dndData;
		}
		public function set dndData(newValue:*):void {
			_dndData = newValue;
		}
		
		private var _bindDataHandler:GPropertyBindDataHandler;
		public function get bindData():* {
			return _bindDataHandler ? _bindDataHandler.value : null;
		}
		public function set bindData(newValue:*):void {
			_bindDataHandler ||= new GPropertyBindDataHandler(handleModelChanged, this);
			_bindDataHandler.value = newValue;
		}
		public function revalidateBindData():void {
			_bindDataHandler ||= new GPropertyBindDataHandler(handleModelChanged, this);
			_bindDataHandler.revalidate();
		}
		public function handleModelChanged(events:Object = null):void {
		}

		private var _data:*;
		public function get data():* {
			return _data;
		}
		public function set data(newValue:*):void {
			_data = newValue;
		}
		
		private var _tickHandler:GPropertyTickHandler;
		public function get enableTick():Boolean {
			return _tickHandler ? _tickHandler.value : false;
		}
		public function set enableTick(newValue:Boolean):void {
			_tickHandler ||= new GPropertyTickHandler(tick, this);
			_tickHandler.value = newValue;
		}
		public function tick(interval:int):void {
		}

		private var _timerHandler:GPropertyTimerHandler;
		public function get refreshTimer():int {
			return _timerHandler ? _timerHandler.value : 0; 
		}
		public function set refreshTimer(newValue:int):void {
			_timerHandler ||= new GPropertyTimerHandler(refresh, this);
			_timerHandler.value = newValue;
		}
		public function refresh(time:int):void {
		}

		public function GDisplaySprite() {
			super();

			addEventListener(Event.ADDED_TO_STAGE, _handleStageEvent);
		}

		//The trouble is, however, this event erroneously fires not only for the given item
		//, but also when its parents are added to the Display List. This runs your init method multiple times, possibly causing problems.
		final private function _handleStageEvent(event:Event):void {
			switch (event.type) {
				case Event.ADDED_TO_STAGE: //“ADDED_TO_STAGE”事件会被派发多次,当当前对象在parent.ADDED_TO_STAGE事件中添加到显示列表时。同理"REMOVED_FROM_STAGE"
					removeEventListener(Event.ADDED_TO_STAGE, _handleStageEvent);
					addEventListener(Event.REMOVED_FROM_STAGE, _handleStageEvent);

					doInit();
					break;
				case Event.REMOVED_FROM_STAGE:
					removeEventListener(Event.REMOVED_FROM_STAGE, _handleStageEvent);
					addEventListener(Event.ADDED_TO_STAGE, _handleStageEvent);

					doDispose();
					break;
			}
		}

		protected function doInit():void {}

		final public function repaint():void {
			GPaintManager.instance.addRepaintComponent(this);
		}

		public function paintNow():void {
		}

		public function remove():void {
			parent.removeChild(this);
		}

		protected function doDispose():void {}
	}
}
