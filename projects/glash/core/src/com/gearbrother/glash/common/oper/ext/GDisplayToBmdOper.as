package com.gearbrother.glash.common.oper.ext {
	import com.gearbrother.glash.common.oper.GOper;
	import com.gearbrother.glash.common.oper.GQueue;
	import com.gearbrother.glash.display.GBitmapFrame;
	import com.gearbrother.glash.display.GBmdMovieInfo;
	import com.gearbrother.glash.manager.RootManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
	import org.as3commons.lang.StringUtils;
	
	/**
	 * 将电影剪辑缓存为位图数组的类，可以将其转移到GBitmapMovieClip进行播放
	 * 缓存需要时间，需要监听complete事件，也可以调用renderAllFrames方法立即完成缓存
	 *
	 * @see com.gearbrother.glash.display.movieclip.GBitmapMovieClip
	 *
	 */
	public class GDisplayToBmdOper extends GOper {
		static public const queue:GQueue = new GQueue();
		
		private var _source:DisplayObject;
		public function set source(newValue:DisplayObject):void {
			_source = newValue;
		}
		
		private var _step:uint;
		
		private var _result:GBmdMovieInfo;

		private var _rect:*;
		/**
		 * instance of Array(group of Rectangle) or Rectangle 
		 * @param value
		 * 
		 */		
		public function set rect(value:*):void {
			_rect = value;
		}

		private var _limitTimeInFrame:int;

		private var _startFrame:int; //开始读取的帧
		public function get startFrame():int {
			return _startFrame;
		}

		private var _readFrameAt:int; //预计要读取的帧
		public function get readFrameAt():int {
			return _readFrameAt;
		}

		private var _endFrame:int; //最后一帧的位置
		public function get endFrame():int {
			return _endFrame;
		}
		
		//抓拖后检测边缘透明多余区域并去除, 此方法会消耗一倍cpu, 在多数矢量素材中不需要使用,慎用
		public var removeTransparent:Boolean;
		
		//监测素材上一帧是否于当前帧一样，则复用同一个BitmapData, 设为true时可能会降低内存开销，但会渲染时加大cpu开销, 所以视素材而定
		public var removeDuplicate:Boolean;

		private var _timer:Timer;

		/**
		 * 缓存动画
		 *
		 * @param mc		要缓存的动画
		 * @param rect		绘制范围 instance of array or rectangle
		 * @param skip		跳帧
		 * @param start		起始帧
		 * @param len		长度
		 * @param readWhenPlaying	是否在播放时顺便缓存
		 * @param limitTimeInFrame	每次缓存允许的最高时间
		 */
		public function GDisplayToBmdOper(source:* = null, rect:* = null, start:int = 1, len:int = -1, skip:uint = 0
									  , removeDuplicate:Boolean = false, removeTransparent:Boolean = false) {
			super(queue);

			this.source = source;
			this.rect = rect;
			_startFrame = _readFrameAt = start;
			_endFrame = len;
			_step = skip + 1;
			this.removeDuplicate = removeDuplicate;
			this.removeTransparent = removeTransparent;
			_limitTimeInFrame = 1000 / RootManager.stage.frameRate/* / 2*/;
		}

		override public function execute():void {
			super.execute();

			_result = new GBmdMovieInfo();
			if (_source is Bitmap) {
				_result.bmds.push((_source as Bitmap).bitmapData);
				notifyResult();
			} else {
				if (_source is MovieClip) {
					var movie:MovieClip = _source as MovieClip;
					_result.labels = movie.currentLabels;
					movie.gotoAndStop(_readFrameAt);
					if (_endFrame == -1) {
						_endFrame = movie.totalFrames;
					} else if (_endFrame > movie.totalFrames) {
						_endFrame = movie.totalFrames;
					}
				}
				_timer = new Timer(0, int.MAX_VALUE);
				_timer.addEventListener(TimerEvent.TIMER, timeHandler);
				_timer.start();
			}
		}

		/**
		 * 立即渲染完所有帧
		 *
		 */
		public function renderAllFrames():void {
			_limitTimeInFrame = int.MAX_VALUE;
			timeHandler(null);
		}

		private function timeHandler(event:Event):void {
			var t:int = getTimer();
			do {
				if (_source is MovieClip) {
					var movie:MovieClip = _source as MovieClip;
					movie.gotoAndStop(_readFrameAt);
					var res:GBitmapFrame = _handle(movie);
					if (removeDuplicate && _result.bmds.length > 0) {
						if (res.bmd.compare(_result.bmds[_result.bmds.length - 1] as BitmapData) == 0) {
							res.bmd.dispose();
							res.bmd = _result.bmds[_result.bmds.length - 1];
							res.regPoint = _result.offsets[_result.bmds.length - 1];
						}
					}
					_result.bmds.push(res.bmd);
					_result.offsets.push(res.regPoint);
					_readFrameAt += _step;
					if (_readFrameAt - movie.totalFrames > 0) {
						readCompleteHandler();
						break;
					}
				} else {
					var res2:GBitmapFrame = _handle(movie);
					_result.bmds.push(res2.bmd);
					_result.offsets.push(res2.regPoint);
					readCompleteHandler();
					break;
				}
			} while (getTimer() - t < _limitTimeInFrame)
		}

		protected function _handle(item:DisplayObject):GBitmapFrame {
			var frame:GBitmapFrame = new GBitmapFrame();
			var rect:Rectangle = item.getBounds(item);
			if (Math.floor(rect.x) != rect.x) {	//has float
				rect.left--;
				rect.left = int(rect.left);
			}
			if (Math.floor(rect.y) != rect.y) {
				rect.top--;
				rect.top = int(rect.top);
			}
			if (Math.floor(rect.right) != rect.right) {
				rect.right++;
				rect.right = int(rect.right);
			}
			if (Math.floor(rect.bottom) != rect.bottom) {
				rect.bottom++;
				rect.bottom = int(rect.bottom);
			}
			var bitmapData:BitmapData = new BitmapData(Math.max(1, rect.width), Math.max(1, rect.height), true, 0);
			var m:Matrix = item.transform.matrix;//new Matrix();
			m.translate(-rect.x, -rect.y);
			bitmapData.draw(item, m);
			if (_rect) {
				
			} else if (removeTransparent) {
				var realRect:Rectangle = bitmapData.getColorBoundsRect(0xFF000000, 0x00000000, false);
				var realImg:BitmapData;
				if (realRect.width == 0 || realRect.height == 0)
					realImg = new BitmapData(1, 1, true, 0x00FFFFFF);
				else
					realImg = new BitmapData(realRect.width, realRect.height, true, 0x00FFFFFF);
				realImg.draw(bitmapData, new Matrix(1, 0, 0, 1, -realRect.x, -realRect.y));
				rect.offset(realRect.x, realRect.y);
				bitmapData.dispose();
				bitmapData = realImg;
			}
			frame.bmd = bitmapData;
			frame.regPoint = new Point(rect.x, rect.y);
			/*if (item is MovieClip)
				frame.label = (item as MovieClip).cu*/
			return frame;
		}

		protected function readCompleteHandler():void {
			_timer.removeEventListener(TimerEvent.TIMER, timeHandler);
			_timer.stop();
			_timer = null;
			_source = null;

			notifyResult(_result);
		}

		/**
		 * 回收位图资源
		 *
		 */
		override public function dispose():void {
			if (_timer) {
				_timer.removeEventListener(TimerEvent.TIMER, timeHandler);
				_timer.stop();
				_timer = null;
			}
			_source = null;

			for each (var bitmapData:BitmapData in _result.bmds)
				bitmapData.dispose();
		}
		
		override public function toString():String {
			return StringUtils.substitute("[{0} readFrameAt={1} checkTransparent={2} checkDuplicate={3}]", getQualifiedClassName(this), readFrameAt, removeTransparent, removeDuplicate);
		}
	}
}