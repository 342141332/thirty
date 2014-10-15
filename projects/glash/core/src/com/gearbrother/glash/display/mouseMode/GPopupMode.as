package com.gearbrother.glash.display.mouseMode {
	import flash.display.*;
	import flash.events.*;

	public class GPopupMode {
		protected var _target:DisplayObject;
		protected var _parent:DisplayObjectContainer;
		protected var _stage:Stage;

		public function GPopupMode() { }

		public function attachTarget(target:DisplayObject):void {
			if (_target != null) {
				_target.removeEventListener(MouseEvent.CLICK, onClickRoot);
				_target.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
				if (_target.stage != null) {
					_target.stage.removeEventListener(MouseEvent.CLICK, onClickRoot);
				}
				_target = null;
			}
			_target = target;
			_parent = _target.parent;
			if (_target != null) {
				_target.addEventListener(MouseEvent.CLICK, onClickRoot);
				if (_target.stage == null) {
					_target.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
				} else {
					_stage = _target.stage;
					_target.stage.addEventListener(MouseEvent.CLICK, onClickRoot);
				}
				hide();
			}
		}

		protected function onGlobalMouseDown(event:Event):void {
			hide();
		}

		protected function onClickRoot(event:MouseEvent):void {
			if (event.currentTarget == _target) {
				event.stopPropagation();
				return;
			}
			hide();
		}

		protected function onAddedToStage(event:Event):void {
			_stage = _target.stage;
			_target.stage.addEventListener(MouseEvent.CLICK, onClickRoot, true);
		}

		public function show():void {
			_target.visible = true;
			if (_parent != null) {
				_parent.addChild(_target);
			}
		}

		public function hide():void {
			_target.visible = false;
			if (_parent != null && _parent.contains(_target)) {
				_parent.removeChild(_target);
			}
		}

		public function getTarget():DisplayObject {
			return _target;
		}
		
		public function dispose():void {
			_target.removeEventListener(MouseEvent.CLICK, onClickRoot);
			_target.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			if (_stage)
				_stage.removeEventListener(MouseEvent.CLICK, onClickRoot);
		}
	}
}