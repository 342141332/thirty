package com.gearbrother.mushroomWar.view.common {
	import com.gearbrother.glash.GMain;
	import com.gearbrother.glash.common.collections.IGObject;
	import com.gearbrother.glash.common.oper.GOper;
	import com.gearbrother.glash.common.oper.GOperEvent;
	import com.gearbrother.glash.common.oper.GOperPool;
	import com.gearbrother.glash.common.oper.GQueue;
	import com.gearbrother.glash.common.oper.ext.GBmdDefinition;
	import com.gearbrother.glash.common.oper.ext.GDefinition;
	import com.gearbrother.glash.common.oper.ext.GDisplayToBmdOper;
	import com.gearbrother.glash.display.GBitmapFrame;
	import com.gearbrother.glash.display.GBmdMovieInfo;
	import com.gearbrother.glash.manager.RootManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
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
	 *
	 * @author 	Neo.Zhang
	 * @create 	2014-9-17 下午1:06:00
	 *
	 */
	public class AvatarFile extends GBmdDefinition {
		private var _frame:int;
		
		private var _offsetX:int;
		
		private var _offsetY:int;

		private var _timer:Timer;

		private var _result:GBmdMovieInfo;

		private var _source:MovieClip;
		
		private var _readFrameAt:int;
		
		private var _limitTimeInFrame:int;
		
		public function AvatarFile(frame:int, definition:GDefinition, offsetX:int = -27, offsetY:int = -50) {
			super(definition);
			
			_frame = frame;
			_offsetX = offsetX;
			_offsetY = offsetY;
		}
		
		override protected function _handleDefinitionEvent(event:Event = null):void {
			if (definition.resultType == GOper.RESULT_TYPE_SUCCESS) {
				var movieClip:MovieClip = definition.result;
				movieClip.gotoAndStop(_frame);
				_source = movieClip;
				_result = new GBmdMovieInfo();
				_limitTimeInFrame = 10;
				_timer = new Timer(0, int.MAX_VALUE);
				_timer.addEventListener(TimerEvent.TIMER, timeHandler);
				_timer.start();
			} else {
				notifyFault();
			}
		}

		private function timeHandler(event:Event):void {
			var t:int = getTimer();
			do {
				var movie:MovieClip = _source.getChildAt(0) as MovieClip;
				movie.gotoAndStop(_readFrameAt);
				var res:GBitmapFrame = _handle(_source);
				_result.bmds.push(res.bmd);
				_result.offsets.push(res.regPoint);
				_readFrameAt += 1;
				if (_readFrameAt - movie.totalFrames > 0) {
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
			frame.bmd = bitmapData;
			frame.regPoint = new Point(rect.x + _offsetX, rect.y + _offsetY);
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
		
		override public function dispose():void {
			if (_timer) {
				_timer.removeEventListener(TimerEvent.TIMER, timeHandler);
				_timer.stop();
				_timer = null;
			}
			_source = null;
			
			for each (var bitmapData:BitmapData in _result.bmds)
				bitmapData.dispose();
			GOperPool.instance.returnInstance(definition);
		}

		override public function equals(o:Object):Boolean {
			if (o is AvatarFile) {
				var other:AvatarFile = o as AvatarFile;
				return other._frame == _frame && other.definition.equals(definition);
			} else {
				return false;
			}
		}
	}
}
