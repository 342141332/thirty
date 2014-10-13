package {
	import com.gearbrother.glash.GMain;
	import com.gearbrother.glash.common.utils.GClassFactory;
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.animation.GThresholdAnimation;
	import com.gearbrother.glash.display.animation.GTransitionCut;
	import com.gearbrother.glash.display.animation.GTransitionDisslove;
	import com.gearbrother.glash.display.animation.GTransitionMosaic;
	import com.gearbrother.glash.display.control.GBitmapTransition;
	import com.gearbrother.glash.display.layout.impl.EmptyLayout;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;


	/**
	 * @author feng.lee
	 * @create on 2013-2-2
	 */
	[SWF(width = "1200", height = "800", frameRate = "60")]
	public class GDisplayTransitionCase extends GMain {
		[Embed(source = "../asset/pic1.jpg")]
		public var pic1:Class;

		[Embed(source = "../asset/pic2.jpg")]
		public var pic2:Class;
		
		[Embed(source = "../asset/pic3.jpg")]
		public var pic3:Class;
		
		[Embed(source = "../asset/pic4.jpg")]
		public var pic4:Class;		

		private var _transitionLayer:GBitmapTransition;

		private var _transitionIndex:int;

		public function GDisplayTransitionCase() {
			super();

			rootLayer.layout = new EmptyLayout();
			rootLayer.addChild(_transitionLayer = new GBitmapTransition());
			stage.addEventListener(MouseEvent.CLICK, handleMouseEvent);
		}

		private function handleMouseEvent(event:MouseEvent):void {
			var transitions:Array = [
				new GClassFactory(GThresholdAnimation, [1.7])
				, new GClassFactory(GTransitionMosaic, [1.7])
				, new GClassFactory(GTransitionDisslove, [1.7])
				, new GClassFactory(GTransitionCut, [1.7])
			];
			var pics:Array = [new pic1(), new pic2(), new pic3(), new pic4()];
			for (var i:int = 0; i < pics.length; i++) {
				(pics[i] as DisplayObject).width = rootLayer.width;
				(pics[i] as DisplayObject).height = rootLayer.height;
			}
			_transitionLayer.outAnimationClazz = new GClassFactory(GTransitionDisslove);//transitions[_transitionIndex++ % transitions.length];
			if (rootLayer.numChildren > 1)
				_transitionLayer.play(rootLayer.removeChildAt(0));
			var to:GNoScale = new GNoScale(pics[_transitionIndex++ % pics.length]);
			rootLayer.addChildAt(to, 0);
		}
	}
}
