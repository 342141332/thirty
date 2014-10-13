package com.gearbrother.glash.display.container {
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.control.GButtonLite;
	import com.gearbrother.glash.display.layer.GAlertLayer;
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;


	/**
	 *
	 * @author feng.lee
	 * create on 2012-11-9 下午2:00:13
	 */
	public class GAlert extends GNoScale {
// don't change, define in .fla =============================
		public var closeBtn:GButtonLite;
		public var closeBtn1:GButtonLite;
		public var closeBtn2:GButtonLite;
// ============================= don't change, define in .fla
		private var _container:GAlertLayer;

		public function GAlert(container:GAlertLayer, skin:DisplayObject = null) {
			super(skin);

			if (skin && skin.hasOwnProperty("closeBtn"))
				closeBtn = new GButtonLite(skin["closeBtn"]);
			if (skin && skin.hasOwnProperty("closeBtn1"))
				closeBtn1 = new GButtonLite(skin["closeBtn1"]);
			if (skin && skin.hasOwnProperty("closeBtn2"))
				closeBtn2 = new GButtonLite(skin["closeBtn2"]);
			_container = container;
			addEventListener(MouseEvent.CLICK, _handleMouseEvent);
		}

		private function _handleMouseEvent(event:MouseEvent):void {
			switch (event.target) {
				case closeBtn:
				case closeBtn1:
				case closeBtn2:
					close();
					break;
			}
		}

		public function open():void {
			_container.addChild(this);
			alpha = scaleX = scaleY = .0;
			TweenLite.to(this, .7, {alpha: 1.0});
		}

		public function close():void {
			TweenLite.to(this, .5, {alpha: .0, onComplete: remove});
		}
	}
}
