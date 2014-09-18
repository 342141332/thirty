package com.gearbrother.glash.display.mouseMode {

	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;

	/**
	 * 鼠标事件处理类, 把针对某一鼠标操作封装成一个类, 脱离对显示对象功能的鼠标处理的以达到复用性.
	 * @author feng.lee
	 *
	 */
	public class GMouseMode {
		protected var _trigger:InteractiveObject;

		public function GMouseMode(trigger:InteractiveObject, applyNow:Boolean = true) {
			_trigger = trigger;
			if (applyNow)
				apply();
		}

		protected function apply():void {
			if (this is IGMouseClick) {
				_trigger.addEventListener(MouseEvent.CLICK, (this as IGMouseClick).click);
			}
			if (this is IGMouseDoubleClick) {
				_trigger.addEventListener(MouseEvent.DOUBLE_CLICK, (this as IGMouseDoubleClick).dClick);
			}
			if (this is IGMouseDown) {
				_trigger.addEventListener(MouseEvent.MOUSE_DOWN, (this as IGMouseDown).mouseDown);
			}
			if (this is IGMouseMove) {
				_trigger.addEventListener(MouseEvent.MOUSE_MOVE, (this as IGMouseMove).mouseMove);
			}
			if (this is IGMouseOut) {
				_trigger.addEventListener(MouseEvent.MOUSE_OUT, (this as IGMouseOut).mouseOut);
			}
			if (this is IGMouseOver) {
				_trigger.addEventListener(MouseEvent.MOUSE_OVER, (this as IGMouseOver).mouseOver);
			}
			if (this is IGMouseRollOut) {
				_trigger.addEventListener(MouseEvent.ROLL_OUT, (this as IGMouseRollOut).rollOut);
			}
			if (this is IGMouseRollOver) {
				_trigger.addEventListener(MouseEvent.ROLL_OVER, (this as IGMouseRollOver).rollOver);
			}
			if (this is IGMouseUp) {
				_trigger.addEventListener(MouseEvent.MOUSE_UP, (this as IGMouseUp).mouseUp);
			}
			if (this is IGMouseWheel) {
				_trigger.addEventListener(MouseEvent.MOUSE_WHEEL, (this as IGMouseWheel).mouseWheel);
			}
		}

		public function remove():void {
			if (this is IGMouseClick) {
				_trigger.removeEventListener(MouseEvent.CLICK, (this as IGMouseClick).click);
			}
			if (this is IGMouseDoubleClick) {
				_trigger.removeEventListener(MouseEvent.DOUBLE_CLICK, (this as IGMouseDoubleClick).dClick);
			}
			if (this is IGMouseDown) {
				_trigger.removeEventListener(MouseEvent.MOUSE_DOWN, (this as IGMouseDown).mouseDown);
			}
			if (this is IGMouseMove) {
				_trigger.removeEventListener(MouseEvent.MOUSE_MOVE, (this as IGMouseMove).mouseMove);
			}
			if (this is IGMouseOut) {
				_trigger.removeEventListener(MouseEvent.MOUSE_OUT, (this as IGMouseOut).mouseOut);
			}
			if (this is IGMouseOver) {
				_trigger.removeEventListener(MouseEvent.MOUSE_OVER, (this as IGMouseOver).mouseOver);
			}
			if (this is IGMouseRollOut) {
				_trigger.removeEventListener(MouseEvent.ROLL_OUT, (this as IGMouseRollOut).rollOut);
			}
			if (this is IGMouseRollOver) {
				_trigger.removeEventListener(MouseEvent.ROLL_OVER, (this as IGMouseRollOver).rollOver);
			}
			if (this is IGMouseUp) {
				_trigger.removeEventListener(MouseEvent.MOUSE_UP, (this as IGMouseUp).mouseUp);
			}
			if (this is IGMouseWheel) {
				_trigger.removeEventListener(MouseEvent.MOUSE_WHEEL, (this as IGMouseWheel).mouseWheel);
			}
		}

		public function set enable(v:Boolean):void {
			if (v)
				apply();
			else
				remove();
		}
	}
}
