package com.gearbrother.glash.display.container {
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.control.GButtonLite;
	import com.gearbrother.glash.display.layer.GWindowLayer;
	import com.gearbrother.glash.display.layer.IGWindow;
	import com.gearbrother.glash.util.display.DepthManager;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;


	/**
	 * 弹出窗口
	 * can drag, drag top depth
	 *
	 * @author feng.lee
	 * create on 2012-8-22 下午6:12:41
	 */
	public class GWindow extends GNoScale implements IGWindow {
// don't change, define in .fla =============================
		public var closeBtn:GButtonLite;
		public var closeBtn1:GButtonLite;
		public var closeBtn2:GButtonLite;
// ============================= don't change, define in .fla
		protected var _neighbourWindowClazz:Array = [];
		
		//窗口是否可独立存在, 当false时窗口会随着屏幕上最后一个窗口的消失而消失
		private var _canExclusive:Boolean = true;
		/**
		 * 窗口能否独立存在
		 * @return false, 当屏幕只留下当前对象时, 默认会移除
		 * 
		 */
		public function get canExclusive():Boolean {
			return _canExclusive;
		}
		
		private var _dragStartWindowPos:Point;
		private var _dragDownStagePt:Point;
		public var dragable:Boolean;
		
		private var _container:GWindowLayer;
		
		override public function set skin(newValue:DisplayObject):void {
			super.skin = newValue;

			if (skin && skin.hasOwnProperty("closeBtn"))
				closeBtn = new GButtonLite(skin["closeBtn"]);
			if (skin && skin.hasOwnProperty("closeBtn1"))
				closeBtn1 = new GButtonLite(skin["closeBtn1"]);
			if (skin && skin.hasOwnProperty("closeBtn2"))
				closeBtn2 = new GButtonLite(skin["closeBtn2"]);
			dragable = true;
			addEventListener(MouseEvent.MOUSE_DOWN, _handleMouseEvent);
			addEventListener(MouseEvent.CLICK, _handleMouseEvent);
		}
		
		public function GWindow(container:GWindowLayer, skin:DisplayObject = null) {
			super(skin);

			_container = container;
		}

		private function _handleMouseEvent(event:MouseEvent):void {
			var target:* = event.target;
			switch (event.type) {
				case MouseEvent.MOUSE_DOWN:
					DepthManager.bringToTop(this);
					if (dragable) {
						if ((target is TextField && TextField(target).type == "input")
								|| (target != this && (target.hasEventListener(MouseEvent.MOUSE_DOWN) || target.hasEventListener(MouseEvent.CLICK)))) {
							//do nothing
						} else {
							stage.addEventListener(MouseEvent.MOUSE_MOVE, _handleMouseEvent);
							stage.addEventListener(MouseEvent.MOUSE_UP, _handleMouseEvent);
							_dragStartWindowPos = new Point(x, y);
							_dragDownStagePt = new Point(stage.mouseX, stage.mouseY);
						}
					}
					break;
				case MouseEvent.MOUSE_MOVE:
					var moveTo:Point = new Point(stage.mouseX, stage.mouseY).subtract(_dragDownStagePt).add(_dragStartWindowPos);
					var rect:Rectangle = new Rectangle(moveTo.x, moveTo.y, width, height);
					if (rect.left < 0)
						rect.x = 0;
					if (rect.right > parent.width)
						rect.x = parent.width - rect.width;
					if (rect.top < 0)
						rect.y = 0;
					if (rect.bottom > parent.height)
						rect.y = parent.height - rect.height;
					x = rect.x;
					y = rect.y;
					event.updateAfterEvent();
					break;
				case MouseEvent.MOUSE_UP:
					stage.removeEventListener(MouseEvent.MOUSE_MOVE, _handleMouseEvent);
					stage.removeEventListener(MouseEvent.MOUSE_UP, _handleMouseEvent);
					break;
				case MouseEvent.CLICK:
					if (target == closeBtn)
						close();
					else if (target == closeBtn1)
						close();
					else if (target == closeBtn2)
						close();
					break;
			}
		}

		/**
		 * 获得与该窗口共存的其他窗口类, 当新窗口显示时, 会把屏幕上与它相同的AttachIDs的窗口保留 
		 * @return Array of Window's Clazz
		 * 
		 */
		public function canBeNeighbour(window:*):Boolean {
			var hasClazz:Boolean = false;
			for each (var attachClazz:Class in _neighbourWindowClazz) {
				if (window is attachClazz) {
					hasClazz = true;
					break;
				}
			}
			return hasClazz;
		}
		
		/**
		 * 对比窗口同时存在时窗口的左右先后顺序 
		 * @param neighbour
		 * @return 1表示当前窗口在后, -1则在前
		 * 
		 */		
		public function compareNeighbour(neighbour:*):int {
			return 0;
		}

		public function open():void {
			_container.addChild(this);
		}
		
		public function close():void {
			_container.removeChild(this);
		}
		
		override protected function doDispose():void {
			super.doDispose();

			removeEventListener(MouseEvent.MOUSE_DOWN, _handleMouseEvent);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, _handleMouseEvent);
			stage.removeEventListener(MouseEvent.MOUSE_UP, _handleMouseEvent);
		}
	}
}