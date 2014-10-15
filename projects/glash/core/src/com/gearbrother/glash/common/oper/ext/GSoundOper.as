package com.gearbrother.glash.common.oper.ext {
	import com.gearbrother.glash.common.oper.GOper;
	import com.gearbrother.glash.common.oper.GQueue;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.getDefinitionByName;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;

	[Event(name = "complete", type = "flash.events.Event")]

	/**
	 * 
	 * @author yi.zhang
	 * 
	 */	
	public class GSoundOper extends GOper {
		static private const logger:ILogger = getLogger(GSoundOper);

		static public var enabledSound:Boolean = true;

		/**
		 * 数据源
		 */
		public var source:*;

		/**
		 * 播放的声音
		 */
		public var channel:SoundChannel;

		/**
		 * 声音开始时间
		 */
		public var startTime:int;

		/**
		 * 循环次数，-1位无限循环
		 */
		public var loops:int;

		/**
		 * 是否在全部下载完毕后才播放
		 */
		public var playWhenComplete:Boolean;

		/**
		 * 声音缓动队列
		 */
		public var tweenQueue:GQueue;

		private var _soundTransform:SoundTransform;

		/**
		 * 声音滤镜对象
		 * @param v
		 *
		 */
		public function set soundTransform(v:SoundTransform):void {
			if (channel)
				channel.soundTransform = v;
			else
				_soundTransform = v;
		}

		public function get soundTransform():SoundTransform {
			if (channel)
				return channel.soundTransform;
			else
				return _soundTransform;
		}

		public function GSoundOper(source:* = null, playWhenComplete:Boolean = true, startTime:int = 0, loops:int = 1, volume:Number = 1.0, panning:Number = 0.5) {
			super(GLoadOper.queue);

			this.source = source;
			this.playWhenComplete = playWhenComplete;
			this.startTime = startTime;
			this.loops = loops;
			this.soundTransform = new SoundTransform(volume, panning);
		}

		/**
		 * 增加一个声音缓动
		 *
		 * @param delay	起始时间
		 * @param duration	持续时间
		 * @param volume	音量
		 * @param pan	声道均衡
		 * @param ease	缓动函数
		 *
		 */
		public function addTween(duration:int = 1000, volume:Number = NaN, pan:Number = NaN, ease:Function = null):void {
			if (!tweenQueue)
				tweenQueue = new GQueue();

			var o:Object = new Object();
			if (!isNaN(volume))
				o.volume = volume;
			if (!isNaN(pan))
				o.pan = pan;
			if (ease != null)
				o.ease = ease;

//			tweenQueue.children.push(new TweenOper(this, duration, o));
		}

		/** @inheritDoc*/
		override public function execute():void {
			if (!enabledSound) {
				notifyResult();
				return;
			}

			super.execute();
			if (source is String) {
				try {
					source = getDefinitionByName(source);
				} catch (e:Error) {
				}
			}

			if (source is Class)
				source = new source();

			if (source is GFile) {
				var s:Sound = new Sound();
				s.addEventListener(IOErrorEvent.IO_ERROR, notifyFault);
				s.addEventListener(Event.COMPLETE, loadSoundComplete);
				s.load(new URLRequest((source as GFile).src), new SoundLoaderContext(1000, true));
				source = s;
				if (playWhenComplete)
					return;
			}

			if (source is Sound)
				playSound(source as Sound)
			else
				logger.error("数据源格式错误")
		}

		private function loadSoundComplete(event:Event):void {
			event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, notifyFault);
			event.currentTarget.removeEventListener(Event.COMPLETE, loadSoundComplete);

			dispatchEvent(event);

			if (playWhenComplete)
				playSound(source as Sound);
		}

		/**
		 * 播放声音
		 *
		 * @param s
		 * @return
		 *
		 */
		protected function playSound(s:Sound):SoundChannel {
			channel = s.play(startTime, (loops >= 0) ? loops : int.MAX_VALUE);
			if (channel) {
				channel.addEventListener(Event.SOUND_COMPLETE, notifyResult);

				if (tweenQueue)
					tweenQueue.execute();
			} else {
				notifyResult(); //无声卡直接播放完成
			}
			return channel;
		}

		/** @inheritDoc*/
		override public function notifyResult(event:* = null):void {
			if (channel)
				channel.removeEventListener(Event.SOUND_COMPLETE, notifyResult);

			super.notifyResult(event);
		}

		/** @inheritDoc*/
		override public function notifyFault(event:* = null):void {
			if (event) {
				event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, notifyFault);
				event.currentTarget.removeEventListener(Event.COMPLETE, loadSoundComplete);
			}

			if (channel)
				channel.removeEventListener(Event.SOUND_COMPLETE, notifyResult);

			super.notifyResult(event);
		}
	}
}
