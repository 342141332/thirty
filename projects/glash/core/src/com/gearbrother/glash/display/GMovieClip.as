package com.gearbrother.glash.display {
	import com.gearbrother.glash.common.utils.GHandler;
	import com.gearbrother.glash.display.event.GDisplayEvent;
	import com.gearbrother.glash.manager.RootManager;
	
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	
	import org.as3commons.lang.ObjectUtils;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;

	[Event(name = "label_enter", type = "com.gearbrother.glash.display.event.GDisplayEvent")]
	[Event(name = "label_start", type = "com.gearbrother.glash.display.event.GDisplayEvent")]
	[Event(name = "label_end", type = "com.gearbrother.glash.display.event.GDisplayEvent")]
	[Event(name = "label_empty", type = "com.gearbrother.glash.display.event.GDisplayEvent")]
	[Event(name = "label_error", type = "com.gearbrother.glash.display.event.GDisplayEvent")]

	/**
	 * 动画控制类，可以通过setLabel, queueLabel将动画推入列表，实现动画的灵活控制。这种方法可以非常简单地实现多方向行走，表情动作系统。
	 * frameRate可以设置播放速度。采用了getTimer的机制，播放速度不会受到浏览器和机器配置的影响。
	 *
	 * 由于MovieClip播放的异步以及播放速度的不稳定特性，不断执行gotoAndStop等方法时将会造成子动画播放不正常，
	 * 请尽可能避免在动画内再放置“影片剪辑”，而以“图形”代替。
	 *
	 * 设置paused=false时和原本的MovieClip行为相同。
	 */
	public class GMovieClip extends GSkinSprite {
		static public const logger:ILogger = getLogger(GMovieClip);

		/**
		 * 保存着所有的帧上函数
		 */
		static public var labelHandlers:Dictionary = new Dictionary();

		/**
		 * 注册一个根据特定帧标签执行的函数
		 *
		 * @param name
		 * @param h
		 *
		 */
		static public function registerHandler(name:String, h:GHandler):void {
			labelHandlers[name] = h;
		}

		/**
		 * [(FrameLabel)] 
		 */		
		protected var _labels:Array;
		public function set labels(newValue:Array):void {
			_labels = [];
			var frameLabel:GMovieLabel;
			for each (var label:FrameLabel in newValue) {
				frameLabel = _labels[label.frame] ||= new GMovieLabel();
				frameLabel.labels.push(label.name);
				frameLabel.frame = label.frame;
			}
			var keys:Array = ObjectUtils.getKeys(_labels);
			keys.sort(Array.NUMERIC);
			for (var i:int; i < keys.length; i++) {
				var key:int = keys[i];
				frameLabel = _labels[key];
				if (i + 1 < keys.length)
					frameLabel.next = _labels[keys[i + 1]];
			}
		}
		public function get labels():Array {
			return _labels;
		}

		private var _label:GMovieLabel;
		public function get currentLabel():GMovieLabel {
			return _label;
		}
		
		private var _currentFrame:int;

		public function get currentFrame():int {
			return _currentFrame;
		}

		public function set currentFrame(newValue:int):void {
			if (_currentFrame != newValue) {
				_currentFrame = newValue;
				if (_labels && _labels[_currentFrame]) {
					_label = _labels[_currentFrame];
					dispatchEvent(new GDisplayEvent(GDisplayEvent.LABEL_ENTER));
				} else {
					_label = null;
				}
				(skin as MovieClip).gotoAndStop(_currentFrame);
			}
		}

		private var _currentQueueInfo:Array;
		//缓存LabelIndex的序号，避免重复遍历
		private function get _currentQueueLabelIndex():int {
			return _currentQueueInfo[0];
		}
		private function set _currentQueueLabelIndex(newValue:int):void {
			_currentQueueInfo[0] = newValue;
		}
		public function get currentQueueLabelName():String {
			return _currentQueueInfo[1];
		}
		public function set currentQueueLabelName(newValue:String):void {
			_currentQueueInfo[1] = newValue;
		}
		//循环次数，-1为无限循环
		private function get currentQueueLabelLoopNum():int {
			return _currentQueueInfo[2];
		}
		private function set currentQueueLabelLoopNum(newValue:int):void {
			_currentQueueInfo[2] = newValue;
		}

		public var totalFrames:int;

		private var _frameRate:Number;

		public function get frameRate():Number {
			if (!isNaN(_frameRate))
				return _frameRate;
			else
				return RootManager.stage.frameRate;
		}

		/**
		 * 设置帧频，设为NaN表示使用默认帧频，负值则为倒放。
		 */
		public function set frameRate(newValue:Number):void {
			_frameRate = newValue;
		}

		public var speed:Number;

		/**
		 * 随机设置时间初值，可以错开图片更新时机增加性能
		 *
		 */
		public function randomFrameTimer():void {
			frameTimer += Math.random() * 1000 / frameRate;
		}

		private var _nextLabels:Array; //Labels列表

		internal var frameTimer:int; //记时器，小于0则需要播放，直到大于0

		/**
		 * 是否在动画结束后暂停
		 */
		public var playOnce:Boolean;

		/**
		 * 设置相同的Label是否重置
		 */
		public var resetLabel:Boolean;
		
		private var _stopped:Boolean;

		/**
		 *
		 * @param mc	目标动画
		 * @param replace	是否替换
		 * @param paused	是否暂停
		 *
		 */
		public function GMovieClip(skin:MovieClip = null, frameRate:Number = NaN) {
			super(skin);

			skin.stop();
			this.frameRate = frameRate;
			speed = 1.0;
			_nextLabels = [];
			_currentQueueInfo = [];
			_currentQueueLabelIndex = -1;
			currentQueueLabelName = null;
			currentQueueLabelLoopNum = -1;
			totalFrames = skin.totalFrames;
			frameTimer = 0;
			playOnce = false;
			resetLabel = false;
			labels = skin.currentLabels.concat();
			enableTick = true;
			_stopped = false;
		}
		
		public function play():void {
			_stopped = false;
		}
		
		public function gotoAndStop(frame:Object):void {
			if (frame is int) {
				_nextLabels.length = 0;
				currentQueueLabelLoopNum = 0;
				currentQueueLabelName = null;
				currentFrame = frame as int;
				stop();
			} else if (frame is String) {
				for each (var label:GMovieLabel in labels) {
					if (label.labels.indexOf(frame) != -1) {
						gotoAndPlay(label.frame);
						stop();
						return;
					}
				}
			} else {
				throw new Error("unknown frame");
			}
		}
		
		public function gotoAndPlay(frame:Object):void {
			gotoAndStop(frame);
			play();
			currentQueueLabelName = null;
			_currentQueueLabelIndex = -1;
			currentQueueLabelLoopNum = -1;
		}
		
		public function stop():void {
			_stopped = true;
		}

		/**
		 * 获得标签的序号
		 *
		 * @param labelName
		 * @return
		 *
		 */
		public function getLabelIndex(labelName:String):int {
			var len:int = _labels.length;
			for (var i:int = 0; i < len; i++) {
				var frameLabel:GMovieLabel = _labels[i];
				if (frameLabel && frameLabel.labels.indexOf(labelName) != -1)
					return i;
			}
			return -1;
		}

		/**
		 * 是否存在某个标签
		 *
		 * @param labelName
		 * @return
		 *
		 */
		public function hasLabel(labelName:String):Boolean {
			return getLabelIndex(labelName) != -1;
		}

		/**
		 * 设置当前动画
		 * @param labelName		动画名称
		 * @param loops			动画循环次数，设为-1为无限循环
		 * @param clearQueue	是否清除动画队列
		 */
		public function setLabel(labelName:String, loopNum:int = -1, clearQueue:Boolean = true):void {
			if (clearQueue)
				this.clearQueue();

			if (labelName) {
				var index:int = labelName ? getLabelIndex(labelName) : -1;
				if (index != -1) {
					currentQueueLabelLoopNum = loopNum;
					if (!resetLabel && index == _currentQueueLabelIndex)
						return;

					currentFrame = (frameRate < 0) ? getLabelEnd(index) : getLabelStart(index);
					currentQueueLabelName = labelName;
					_currentQueueLabelIndex = index;

					dispatchEvent(new GDisplayEvent(GDisplayEvent.LABEL_QUEUE_START));

					if (labelHandlers[labelName])
						(labelHandlers[labelName] as GHandler).call();
				} else {
					dispatchEvent(new GDisplayEvent(GDisplayEvent.LABEL_QUEUE_END));

					dispatchEvent(new GDisplayEvent(GDisplayEvent.LABEL_QUEUE_ERROR));

					logger.warn("can't found label {0}", [labelName]);
				}
			} else {
				currentQueueLabelLoopNum = loopNum;
				currentQueueLabelName = labelName;
				_currentQueueLabelIndex = -1;
			}
		}

		/**
		 *
		 * 将动画推入列表，延迟播放
		 * @param labelName		动画名称
		 * @param loops			动画循环次数，设为-1为无限循环
		 *
		 */
		public function queueLabel(labelName:String, loopNum:int = -1):void {
			if (_nextLabels.length)
				_nextLabels.push([labelName, loopNum]);
			else
				setLabel(labelName, loopNum);
		}

		/**
		 * 清除动画队列
		 */

		public function clearQueue():void {
			_nextLabels.length = 0;
		}

		/**
		 * 初始化动画
		 *
		 */
		public function reset():void {
			setLabel(null);
		}

		override public function tick(interval:int):void {
			if (currentQueueLabelLoopNum == 0 || totalFrames <= 1 || frameRate == 0 || _stopped)
				return;

			frameTimer -= interval * speed;
			while (currentQueueLabelLoopNum != 0 && frameTimer < 0) {
				if (hasReachedLabelEnd()) {
					if (currentQueueLabelLoopNum > 0)
						currentQueueLabelLoopNum--;

					if (currentQueueLabelLoopNum == 0) {
						dispatchEvent(new GDisplayEvent(GDisplayEvent.LABEL_QUEUE_END));

						if (_nextLabels.length > 0) {
							setLabel(_nextLabels[0][0], _nextLabels[0][1], false);
							_nextLabels.shift();
						} else {
							dispatchEvent(new GDisplayEvent(GDisplayEvent.LABEL_QUEUE_EMPTY));

							frameTimer = 0; //停止动画时需要将延时重置为0
						}
					} else {
						loopBackToStart();
					}
				} else {
					nextFrame();
				}

				frameTimer += 1000 / Math.abs(frameRate);
			}
		}

		/**
		 * 回到当前动画的第一帧（反向播放则是最后一帧）
		 */
		public function loopBackToStart():void {
			currentFrame = (frameRate < 0) ? getLabelEnd(_currentQueueLabelIndex) : getLabelStart(_currentQueueLabelIndex);
		}

		//检测是否已经到达当前区段的尾端（倒放则相反）
		private function hasReachedLabelEnd():Boolean {
			if (frameRate < 0)
				return currentFrame <= getLabelStart(_currentQueueLabelIndex);
			else
				return currentFrame >= getLabelEnd(_currentQueueLabelIndex);
		}

		//取得Label的头部
		private function getLabelStart(labelIndex:int):int {
			if (labelIndex == -1)
				return 1;
			else
				return (_labels && _labels.length > 0) ? (_labels[labelIndex] as GMovieLabel).frame : 1;
		}

		//取得Label的尾端
		private function getLabelEnd(labelIndex:int):int {
			if (labelIndex != -1 && _labels && (_labels[labelIndex] as GMovieLabel).next)
				return (_labels[labelIndex] as GMovieLabel).next.frame - 1;
			else
				return totalFrames;
		}

		/**
		 * 是否有帧标签
		 * @return
		 *
		 */
		public function hasLabels():Boolean {
			return _labels && _labels.length > 0;
		}

		/**
		 * 下一帧（倒放时则是上一帧）
		 *
		 */
		public function nextFrame():void {
			(frameRate < 0) ? currentFrame-- : currentFrame++;
		}
	}
}
