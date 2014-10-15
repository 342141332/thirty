package com.gearbrother.glash.display.manager {
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;

	[Event(name = "tick", type = "com.gearbrother.glash.display.manager.GTickEvent")]

	/**
	 * 这个类提供了发布ENTER_FRAME事件的功能，唯一的区别在于在发布的事件里会包含一个interval属性，表示两次事件的间隔毫秒数。
	 * 利用这种机制，接收事件方可以根据interval来动态调整动画播放间隔，单次移动距离，以此实现动画在任何客户机上的恒速播放，
	 * 不再受ENTER_FRAME发布频率的影响，也就是所谓的“跳帧”。
	 *
	 * 相比其他同样利用getTimer()的方式，这种方法并不会进行多余的计算。
	 *
	 */
	public class GTick extends EventDispatcher {
		static public const logger:ILogger = getLogger(GTick);

		/**
		 * 最大两帧间隔（防止待机后返回卡死）
		 */
		static public var MAX_INTERVAL:int = 3000;
		static public var MIN_INTERVAL:int = 0;

		/**
		 * 速度系数
		 * 可由此实现慢速播放
		 *
		 */
		public var speed:Number = 1.0;

		/**
		 * 是否停止发布Tick事件
		 *
		 * Tick事件的发布影响的内容非常多，一般情况不建议设置此属性，而是设置所有需要暂停物品的pause属性。
		 */
		public var pause:Boolean = false;

		private var _prevTime:int; //上次记录的时间
		
		public var maxTick:int;

		public function GTick() {
			maxTick = int.MAX_VALUE;
		}

		/**
		 * 清除掉积累的时间（在暂停之后）
		 *
		 */
		public function clear():void {
			this._prevTime = 0;
		}

		public function tick():void {
			var nextTime:int = getTimer();
			if (!pause) {
				var interval:int;
				if (_prevTime == 0)
					interval = 0;
				else {
					interval = Math.max(MIN_INTERVAL, Math.min(nextTime - _prevTime, MAX_INTERVAL));
					interval *= speed;
					for (var i:int = 0; i < interval; i += maxTick) {
						var e:GTickEvent = new GTickEvent(GTickEvent.TICK);
						e.interval = Math.min(i + maxTick, interval);
						dispatchEvent(e);
					}
					/*CONFIG::debug {
						if (e.interval > 60)
							logger.warn("tick's interval is over 60!");
					}*/
				}
			}
			_prevTime = nextTime;
		}
	}
}
