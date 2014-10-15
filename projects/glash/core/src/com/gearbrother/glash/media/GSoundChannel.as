package com.gearbrother.glash.media {
	import com.gearbrother.glash.common.collections.ArrayList;
	import com.gearbrother.glash.common.collections.List;
	import com.gearbrother.glash.common.oper.ext.GFile;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.plugins.VolumePlugin;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;

	/**
	 * @author feng.lee
	 * create on 2013-2-25
	 */
	public class GSoundChannel {
		static public const logger:ILogger = getLogger(GSoundChannel);
		{
			TweenPlugin.activate([VolumePlugin]);
		}

		static private var _globalVolume:Number = 1.0;

		/**
		 * 设置全局声音的大小
		 *
		 * @param volume	声音
		 * @param duration	变化需要的时间
		 */
		static public function setGlobalVolume(volume:Number, duration:Number = 0):void {
			if (duration == 0)
				SoundMixer.soundTransform = new SoundTransform(volume);
			else
				TweenMax.to(SoundMixer, duration, {volume: volume});
			_globalVolume = volume;
		}

		static private const activeChannels:ArrayList = new ArrayList;

		static public function stopAll(len:Number = 0):void {
			for each (var channel:GSoundChannel in activeChannels) {
				channel.stop(len);
			}
		}

		static public const buttonChannel:GSoundChannel = new GSoundChannel();
		
		private var _sound:Sound;
		
		private var _channel:SoundChannel;

		public function GSoundChannel() {
		}

		/**
		 * 播放
		 *
		 * @param name		名称
		 * @param loop		循环次数，-1为无限循环
		 * @param volume	声音，-1使用默认声音
		 * @param len		渐显需要的时间
		 */
		public function playURL(url:URLRequest, loop:int = 1, volume:Number = -1, len:Number = 0):void {
			_sound = new Sound();
			_sound.load(url, new SoundLoaderContext(1000, true));
			_sound.addEventListener(IOErrorEvent.IO_ERROR, _handleSoundEvent);
			play(_sound, loop, volume, len);
		}

		public function play(sound:Sound, loop:int = 1, volume:Number = -1, len:Number = 0):void {
			stop();
			_sound = sound;
			_channel = _sound.play(0, loop != -1 ? loop : int.MAX_VALUE);
			if (!_channel) {
				logger.info("try to play sound {0}, but there is no channel can use.", [sound.url]);
				return;
			}
			
			if (loop != 0 && loop != -1)
				_channel.addEventListener(Event.SOUND_COMPLETE, _handleSoundEvent);
			
			if (len == 0) {
				_channel.soundTransform = new SoundTransform((volume != -1) ? volume : _globalVolume);
			} else {
				_channel.soundTransform = new SoundTransform(0);
				TweenLite.to(_channel, len, {volume: (volume != -1) ? volume : _globalVolume})
			}
		}
		
		private function _handleSoundEvent(evt:Event = null):void {
			if (evt is IOErrorEvent) {
				logger.info("IOError, Can't play sound {0}", [(evt.target as Sound).url]);
			}
			stop();
		}

		/**
		 * 设置声音的大小
		 *
		 * @param name	名称
		 * @param volume	声音
		 * @param len	变化需要的时间
		 */
		public function setVolume(volume:Number, len:Number = 0):void {
			if (len == 0)
				_channel.soundTransform = new SoundTransform(volume);
			else
				TweenLite.to(_channel, len, {volume: volume});
		}

		/**
		 * 设置声音位置
		 *
		 * @param name	名称
		 * @param pan	声音位置，范围由-1到1
		 * @param len	过渡时间
		 */
		public function setPan(pan:Number, len:Number):void {
			if (len == 0)
				_channel.soundTransform = new SoundTransform(_channel.soundTransform.volume, pan);
			else
				TweenLite.to(_channel, len, {pan: pan});
		}

		/**
		 * 停止播放
		 *
		 * @param name	名称
		 * @param len	渐隐需要的时间
		 */
		public function stop(len:Number = 0):void {
			if (_channel) {
				if (len == 0)
					_channel.stop();
				else
					TweenLite.to(_channel, len, {volume: .0, onComplete: _channel.stop});
			}
			if (_channel) {
				_channel.removeEventListener(Event.SOUND_COMPLETE, _handleSoundEvent);
				_channel = null;
			}
			
			if (_sound) {
				_sound.removeEventListener(IOErrorEvent.IO_ERROR, _handleSoundEvent);
				_sound = null;
			}
			
			activeChannels.remove(this);
		}
	}
}
