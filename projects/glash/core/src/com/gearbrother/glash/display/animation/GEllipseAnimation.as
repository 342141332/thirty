package com.gearbrother.glash.display.animation {
	import com.gearbrother.glash.util.math.GEllipse;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.events.TweenEvent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;

	public class GEllipseAnimation {
		private static const __vars:Object = {width: 800, height: 300};

		private var _displayObj:DisplayObject;
		
		public function GEllipseAnimation(displayObj:DisplayObject, ... vars) {
			vars.unshift(__vars);
			_displayObj = displayObj;
		}

		private var __ellipse:GEllipse;

		protected function buildTween(vars:Object):TweenMax {
			__ellipse = new GEllipse(0, 0, vars.width, vars.height);
			return TweenMax.to(_displayObj, vars.duration, {onUpdate: __onUpdate});
		}

		private function __onUpdate(e:Event = null):void {
			var tween:TweenMax = e.target as TweenMax;

			var progress:Number// = tween.currentTime / tween.duration;
			var toPt:Point = __ellipse.getPointOfDegree(36 * progress);
			_displayObj.x = int(toPt.x);
			_displayObj.y = int(toPt.y);
		}
	}
}
