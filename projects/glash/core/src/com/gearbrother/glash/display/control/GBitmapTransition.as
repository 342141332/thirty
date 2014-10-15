package com.gearbrother.glash.display.control {
	import com.gearbrother.glash.common.oper.GQueue;
	import com.gearbrother.glash.common.oper.ext.GHandleOper;
	import com.gearbrother.glash.common.utils.GClassFactory;
	import com.gearbrother.glash.common.utils.GHandler;
	import com.gearbrother.glash.display.GBitmap;
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.animation.GAnimation;
	import com.gearbrother.glash.util.display.GDisplayUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;


	/**
	 * @author neozhang
	 * @create on May 21, 2013
	 */
	public class GBitmapTransition extends GNoScale {
		public var outAnimationClazz:GClassFactory;

		public var animationQueue:GQueue;
		
		public function GBitmapTransition(outAnimation:GClassFactory = null) {
			super();

			this.outAnimationClazz = outAnimation;
			this.animationQueue = new GQueue();
		}

		public function play(to:DisplayObject):void {
			if (outAnimationClazz) {
				var canvas:Bitmap = new Bitmap();
				var bmd:BitmapData = new BitmapData(to.width, to.height);
				bmd.draw(to, to.transform.matrix);
				function addBmp():void {
					canvas.bitmapData = bmd;
					addChild(canvas);
				}
				new GHandleOper(new GHandler(addBmp)).commit(animationQueue);
				var inAnimation:GAnimation = outAnimationClazz.newInstance();
				inAnimation.target = canvas;
				inAnimation.commit(animationQueue);
				function removeBmp():void {
					removeChild(canvas);
				}
				new GHandleOper(new GHandler(removeBmp)).commit(animationQueue);
			}
		}
	}
}
